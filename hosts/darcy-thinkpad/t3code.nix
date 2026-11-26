{inputs}: {
  config,
  lib,
  pkgs,
  ...
}: let
  admins = (import ../../keys.nix).drobson03;

  name = "orthanc";
  tap = "vm-${name}";
  hostAddress = "10.77.1.1";
  guestAddress = "10.77.1.2";
  port = 3773;
  # The thinkpad's own T3 Code server already listens on 3773.
  hostPort = 3774;

  ip = lib.getExe' pkgs.iproute2 "ip";

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
in {
  imports = [
    inputs.microvm.nixosModules.host
    # Prebuilt t3code and agent CLIs for the guest closure built here.
    inputs.self.nixosModules.llm-agents-cache
  ];

  microvm.vms.${name}.config = {
    imports = [inputs.self.nixosModules.t3code-guest];

    networking.hostName = name;
    networking.domain = config.networking.domain;
    microvm = {
      vcpu = 8;
      mem = 32 * 1024;
    };

    t3code-guest = {
      inherit admins tap storeOverlayImage hostAddress;
      mac = "02:00:0a:4d:01:02";
      address = guestAddress;
    };
  };

  # Give the routed /30 to the tap once microvm.nix creates it.
  systemd.services."microvm-tap-interfaces@${name}".serviceConfig.ExecStartPost = [
    "${ip} addr replace ${hostAddress}/30 dev ${tap}"
  ];

  # The guest's store is an overlay on a virtiofs share of /nix/store, and
  # overlayfs cannot cope with its lower layer changing underneath it. The
  # scheduled `nix-store --optimise` swaps existing store files for hardlinks,
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

  # No externalInterface: the laptop roams between Wi-Fi and wired links, so
  # masquerade the guest out of whichever one has the route.
  networking.nat = {
    enable = true;
    internalInterfaces = [tap];
  };

  # The NAT module's forwardPorts needs a fixed externalInterface, so DNAT the
  # host port by hand on any link. Locally, reach the guest at
  # ${guestAddress}:${toString port} directly.
  #
  # Internet only: the guest may answer connections (T3 remote access via the
  # DNAT, or over Tailscale) but cannot open new ones to private ranges, the
  # LAN or the host itself.
  networking.nftables.tables = {
    "${name}-nat" = {
      family = "ip";
      content = ''
        chain pre {
          type nat hook prerouting priority dstnat; policy accept;
          iifname != "${tap}" fib daddr type local tcp dport ${toString hostPort} dnat to ${guestAddress}:${toString port}
        }
      '';
    };

    "${name}-filter" = {
      family = "inet";
      content = ''
        chain forward {
          type filter hook forward priority filter; policy accept;
          iifname "${tap}" ct state established,related accept
          iifname "${tap}" meta nfproto ipv6 drop
          iifname "${tap}" ip daddr { ${lib.concatStringsSep ", " privateRanges} } drop
        }

        chain input {
          type filter hook input priority filter; policy accept;
          iifname "${tap}" ct state != { established, related } drop
        }
      '';
    };
  };
}
