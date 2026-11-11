{inputs}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hosts.valinor.moria;
  admins = (import ../../keys.nix).drobson03;

  name = "moria";
  tap = "vm-${name}";
  hostAddress = "10.77.0.1";
  guestAddress = "10.77.0.2";
  # The guest sits in the LAN's /64 (reachable directly, mirroring 10.77.0.2)
  # but is routed through valinor rather than bridged. valinor answers
  # neighbour solicitations for it on the LAN and is its gateway at fe80::1.
  hostAddress6 = "fe80::1";
  inherit (cfg) guestAddress6 sitePrefix6;
  port = 3773;
  lanInterface = "enp4s0";

  ip = lib.getExe' pkgs.iproute2 "ip";

  # Volumes live under /var/lib/microvms on the SSD root, not the tank pool.
  stateDir = "${config.microvm.stateDir}/${name}";
  storeOverlayImage = "nix-store-overlay.img";

  privateRanges = [
    "10.0.0.0/8"
    "100.64.0.0/10"
    "169.254.0.0/16"
    "172.16.0.0/12"
    "192.168.0.0/16"
    "224.0.0.0/4"
  ];
  privateRanges6 = [
    sitePrefix6
    "fc00::/7"
    "fe80::/10"
    "ff00::/8"
  ];
in {
  imports = [
    inputs.microvm.nixosModules.host
    # Prebuilt t3code and agent CLIs for the guest closure built here.
    inputs.self.nixosModules.llm-agents-cache
  ];

  options.hosts.valinor.moria = {
    guestAddress6 = lib.mkOption {
      type = lib.types.singleLineStr;
      description = "The guest's public address in the LAN's /64, routed through valinor.";
    };
    sitePrefix6 = lib.mkOption {
      type = lib.types.singleLineStr;
      description = "The site's IPv6 prefix; the guest may not connect into it, and only it may reach T3.";
    };
  };

  config = {
    microvm.vms.${name} = {
      specialArgs = {inherit inputs;};
      config = import ./t3code-guest.nix {
        inherit (config.networking) domain;
        inherit admins guestAddress guestAddress6 hostAddress hostAddress6 port storeOverlayImage tap;
      };
    };

    # Give the routed /30 and IPv6 gateway to the tap once microvm.nix creates
    # it, route the guest's LAN address to it, and never take router
    # advertisements from the guest.
    systemd.services."microvm-tap-interfaces@${name}".serviceConfig.ExecStartPost = [
      "${ip} addr replace ${hostAddress}/30 dev ${tap}"
      "${pkgs.procps}/bin/sysctl -w net.ipv6.conf.${tap}.accept_ra=0"
      "${ip} -6 addr replace ${hostAddress6}/64 dev ${tap} nodad"
      "${ip} -6 route replace ${guestAddress6}/128 dev ${tap}"
      # Best effort: the dispatcher below covers the LAN link coming up later.
      "-${ip} -6 neigh add proxy ${guestAddress6} dev ${lanInterface}"
    ];

    # The kernel drops proxy entries when the LAN link goes down, so re-add it
    # whenever NetworkManager brings the link back up.
    networking.networkmanager.dispatcherScripts = [
      {
        type = "basic";
        source = pkgs.writeShellScript "t3-vm-proxy-ndp" ''
          if [ "$1" = ${lanInterface} ] && [ "$2" = up ]; then
            ${ip} -6 neigh add proxy ${guestAddress6} dev ${lanInterface}
          fi
        '';
      }
    ];

    # NetworkManager handles RAs on the LAN itself, so forwarding does not
    # affect valinor's own addressing.
    boot.kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = lib.mkDefault true;
      "net.ipv6.conf.default.forwarding" = lib.mkDefault true;
      # Only answers for explicit proxy entries.
      "net.ipv6.conf.all.proxy_ndp" = true;
    };

    # The guest's store is an overlay on a virtiofs share of /nix/store, and
    # overlayfs cannot cope with its lower layer changing underneath it. The
    # nightly `nix-store --optimise` swaps existing store files for hardlinks,
    # after which every exec in the guest fails with ESTALE until it reboots.
    # Deduplicate as paths are added instead, before the guest can see them.
    nix.optimise.automatic = lib.mkForce false;
    nix.settings.auto-optimise-store = true;

    # The Nix database forgets overlay paths across boots, so recreate the
    # writable store overlay every start.
    systemd.services."microvm@${name}".serviceConfig.ExecStartPre = [
      "${pkgs.coreutils}/bin/rm -f ${stateDir}/${storeOverlayImage}"
    ];

    networking.networkmanager.unmanaged = ["interface-name:${tap}"];

    networking.nat = {
      enable = true;
      internalInterfaces = [tap];
      externalInterface = lanInterface;
      forwardPorts = [
        {
          proto = "tcp";
          sourcePort = port;
          destination = "${guestAddress}:${toString port}";
        }
      ];
    };

    # Internet only: the guest may answer connections from the LAN (T3 remote
    # access via the DNAT above, or directly over IPv6) but cannot open new ones
    # to private ranges, the LAN or the host itself.
    networking.firewall.extraCommands = ''
      iptables -N t3-vm-fwd 2>/dev/null || iptables -F t3-vm-fwd
      iptables -A t3-vm-fwd -m conntrack --ctstate ESTABLISHED,RELATED -j RETURN
      ${lib.concatMapStringsSep "\n" (range: "iptables -A t3-vm-fwd -d ${range} -j DROP") privateRanges}
      iptables -D FORWARD -i ${tap} -j t3-vm-fwd 2>/dev/null || true
      iptables -I FORWARD -i ${tap} -j t3-vm-fwd

      iptables -D INPUT -i ${tap} -m conntrack ! --ctstate ESTABLISHED,RELATED -j DROP 2>/dev/null || true
      iptables -I INPUT -i ${tap} -m conntrack ! --ctstate ESTABLISHED,RELATED -j DROP

      # Firewall reloads leave rules in the built-in chains, so clear the blanket
      # drops the IPv6-less setup added or they shadow the chains below.
      ip6tables -D INPUT -i ${tap} -j DROP 2>/dev/null || true
      ip6tables -D FORWARD -i ${tap} -j DROP 2>/dev/null || true

      # IPv6 mirrors the above. Reverse-path filtering is loose, so also pin the
      # guest to its own source address.
      ip6tables -N t3-vm-fwd6 2>/dev/null || ip6tables -F t3-vm-fwd6
      ip6tables -A t3-vm-fwd6 ! -s ${guestAddress6} -j DROP
      ip6tables -A t3-vm-fwd6 -m conntrack --ctstate ESTABLISHED,RELATED -j RETURN
      ${lib.concatMapStringsSep "\n" (range: "ip6tables -A t3-vm-fwd6 -d ${range} -j DROP") privateRanges6}
      ip6tables -D FORWARD -i ${tap} -j t3-vm-fwd6 2>/dev/null || true
      ip6tables -I FORWARD -i ${tap} -j t3-vm-fwd6

      # The guest's address is public, so only the site may connect in, and only
      # to T3.
      ip6tables -N t3-vm-in6 2>/dev/null || ip6tables -F t3-vm-in6
      ip6tables -A t3-vm-in6 -m conntrack --ctstate ESTABLISHED,RELATED -j RETURN
      ip6tables -A t3-vm-in6 -p icmpv6 -j RETURN
      ip6tables -A t3-vm-in6 -p tcp --dport ${toString port} -s ${sitePrefix6} -j RETURN
      ip6tables -A t3-vm-in6 -j DROP
      ip6tables -D FORWARD -o ${tap} -j t3-vm-in6 2>/dev/null || true
      ip6tables -I FORWARD -o ${tap} -j t3-vm-in6

      # Neighbour discovery is untracked, so accept it ahead of the drop.
      ip6tables -D INPUT -i ${tap} -m conntrack ! --ctstate ESTABLISHED,RELATED -j DROP 2>/dev/null || true
      ip6tables -I INPUT -i ${tap} -m conntrack ! --ctstate ESTABLISHED,RELATED -j DROP
      for type in neighbour-solicitation neighbour-advertisement; do
        ip6tables -D INPUT -i ${tap} -p icmpv6 --icmpv6-type $type -m hl --hl-eq 255 -j ACCEPT 2>/dev/null || true
        ip6tables -I INPUT -i ${tap} -p icmpv6 --icmpv6-type $type -m hl --hl-eq 255 -j ACCEPT
      done
    '';
    networking.firewall.extraStopCommands = ''
      iptables -D FORWARD -i ${tap} -j t3-vm-fwd 2>/dev/null || true
      iptables -F t3-vm-fwd 2>/dev/null || true
      iptables -X t3-vm-fwd 2>/dev/null || true
      iptables -D INPUT -i ${tap} -m conntrack ! --ctstate ESTABLISHED,RELATED -j DROP 2>/dev/null || true
      ip6tables -D FORWARD -i ${tap} -j t3-vm-fwd6 2>/dev/null || true
      ip6tables -F t3-vm-fwd6 2>/dev/null || true
      ip6tables -X t3-vm-fwd6 2>/dev/null || true
      ip6tables -D FORWARD -o ${tap} -j t3-vm-in6 2>/dev/null || true
      ip6tables -F t3-vm-in6 2>/dev/null || true
      ip6tables -X t3-vm-in6 2>/dev/null || true
      ip6tables -D INPUT -i ${tap} -m conntrack ! --ctstate ESTABLISHED,RELATED -j DROP 2>/dev/null || true
      for type in neighbour-solicitation neighbour-advertisement; do
        ip6tables -D INPUT -i ${tap} -p icmpv6 --icmpv6-type $type -m hl --hl-eq 255 -j ACCEPT 2>/dev/null || true
      done
    '';
  };
}
