{
  admins,
  domain,
  guestAddress,
  guestAddress6,
  hostAddress,
  hostAddress6,
  port,
  storeOverlayImage,
  tap,
}: {
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  user = "drobson03";
  fullName = "Darcy Robson";
  vcsEmail = "17976794+drobson03@users.noreply.github.com";
  signingKey = "~/.ssh/id_ed25519.pub";
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = with inputs.self.nixosModules; [
    ghostty
    home-manager
    t3code-server
  ];

  microvm = {
    hypervisor = "cloud-hypervisor";
    vcpu = 4;
    mem = 12 * 1024;
    vsock.cid = 3;

    shares = [
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        proto = "virtiofs";
      }
    ];

    writableStoreOverlay = "/nix/.rw-store";

    # Sizes are in MiB; images are sparse.
    volumes = [
      {
        image = storeOverlayImage;
        mountPoint = config.microvm.writableStoreOverlay;
        size = 64 * 1024;
      }
      {
        image = "var.img";
        mountPoint = "/var";
        size = 8 * 1024;
      }
      {
        image = "home.img";
        mountPoint = "/home";
        fsType = "btrfs";
        size = 256 * 1024;
      }
    ];

    interfaces = [
      {
        type = "tap";
        id = tap;
        mac = "02:00:0a:4d:00:02";
      }
    ];
  };

  fileSystems."/home" = {
    neededForBoot = true;
    options = ["compress=zstd" "noatime"];
  };
  fileSystems."/var".neededForBoot = true;

  services.snapper.configs.home = {
    SUBVOLUME = "/home";
    TIMELINE_CREATE = true;
    TIMELINE_CLEANUP = true;
    TIMELINE_LIMIT_HOURLY = 24;
    TIMELINE_LIMIT_DAILY = 7;
    TIMELINE_LIMIT_WEEKLY = 4;
    TIMELINE_LIMIT_MONTHLY = 0;
    TIMELINE_LIMIT_QUARTERLY = 0;
    TIMELINE_LIMIT_YEARLY = 0;
  };

  networking.hostName = "moria";
  networking.domain = domain;
  networking.useNetworkd = true;
  systemd.network.networks."10-uplink" = {
    matchConfig.Type = "ether";
    networkConfig = {
      # A /128: valinor routes only this address, and the rest of the LAN's
      # /64 must go through it too.
      Address = ["${guestAddress}/30" "${guestAddress6}/128"];
      Gateway = [hostAddress hostAddress6];
      # Public resolvers: the LAN router is unreachable from the guest.
      DNS = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
      DHCP = "no";
      IPv6AcceptRA = false;
    };
  };
  networking.firewall.allowedTCPPorts = [port];

  # Log in once with `sudo tailscale up`; state persists on the /var volume.
  # Leave --accept-routes off: subnet routes would let the guest reach the LAN
  # around valinor's internet-only filtering.
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    # /etc is ephemeral; keep host keys on the persistent /var volume.
    hostKeys = [
      {
        type = "ed25519";
        path = "/var/lib/ssh/ssh_host_ed25519_key";
      }
    ];
  };

  users.mutableUsers = false;
  users.users.root.openssh.authorizedKeys.keys = admins;
  # SSH keys only: nix-config's user-drobson03 needs an agenix password the
  # guest cannot decrypt.
  users.users.${user} = {
    isNormalUser = true;
    description = fullName;
    openssh.authorizedKeys.keys = admins;
  };

  home-manager.sharedModules = with inputs.self.homeModules; [
    preset-server
    pi
    {
      home.packages = [
        llmAgents.claude-code
        llmAgents.codex
      ];
      home.stateVersion = "25.11";
    }
  ];

  home-manager.users.${user} = {
    # Commits need ~/.ssh/id_ed25519 generated inside the guest.
    programs.git = {
      settings.user.name = fullName;
      settings.user.email = vcsEmail;
      signing.key = signingKey;
    };

    programs.jujutsu.settings = {
      user.name = fullName;
      user.email = vcsEmail;
      signing.key = signingKey;
    };

    # Share one pnpm virtual store across every checkout and worktree.
    xdg.configFile."pnpm/config.yaml".text = ''
      virtualStoreType: global
    '';

    # The server preset assumes zsh; use bash here so starship, atuin and
    # direnv hook into it instead.
    programs.bash.enable = true;
    programs.zsh.enable = lib.mkForce false;
    programs.tmux.shell = lib.mkForce "${pkgs.bashInteractive}/bin/bash";

    # Drop the preset's cat/less -> bat aliases.
    home.shellAliases = lib.mkForce {};
  };

  nix.settings = {
    experimental-features = ["flakes" "nix-command"];
    # Root is a tmpfs; build on the overlay volume instead of in RAM.
    build-dir = "/nix/.rw-store/build";
  };
  systemd.tmpfiles.rules = [
    "d /nix/.rw-store/build 0755 root root -"
    "v /home/.snapshots 0750 root root -"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  programs.git.enable = true;
  environment.systemPackages = with pkgs; [
    gh
    jq
  ];

  services.t3code-server.user = user;
  # The module keeps T3 Code's default bind addresses; listen on every guest
  # address so the forwarded port works regardless of how T3 classifies 10.77.0.2.
  # "::" is dual-stack, covering both forwards.
  systemd.services.t3code-server.environment.T3CODE_HOST = "::";

  system.stateVersion = "25.11";
}
