# A microvm.nix guest running T3 Code as a service. Hosts declare it with
# `microvm.vms.<name>`, import this module into its config and set its
# hostname, resources and addressing; see hosts/*/t3code.nix.
{inputs, ...}: {
  flake.nixosModules.t3code-guest = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.t3code-guest;
    inherit (lib) mkOption types;

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

    options.t3code-guest = {
      admins = mkOption {
        type = types.listOf types.singleLineStr;
        description = "SSH public keys allowed to log in as root and the T3 user.";
      };
      tap = mkOption {
        type = types.singleLineStr;
        description = "Name of the host's tap interface for the guest.";
      };
      mac = mkOption {
        type = types.singleLineStr;
        description = "MAC address of the guest's interface.";
      };
      address = mkOption {
        type = types.singleLineStr;
        description = "The guest's IPv4 address, in a /30 shared with the host.";
      };
      hostAddress = mkOption {
        type = types.singleLineStr;
        description = "The host's IPv4 address on the tap, and the guest's gateway.";
      };
      address6 = mkOption {
        type = types.nullOr types.singleLineStr;
        default = null;
        description = "Optional IPv6 address routed to the guest as a /128.";
      };
      hostAddress6 = mkOption {
        type = types.nullOr types.singleLineStr;
        default = null;
        description = "The guest's IPv6 gateway, when it has an IPv6 address.";
      };
      port = mkOption {
        type = types.port;
        default = 3773;
        readOnly = true;
        description = "Port T3 Code listens on (fixed by the t3code-server module).";
      };
      storeOverlayImage = mkOption {
        type = types.singleLineStr;
        default = "nix-store-overlay.img";
        description = "Image backing the writable store overlay; hosts recreate it every start.";
      };
    };

    config = {
      microvm = {
        hypervisor = "cloud-hypervisor";
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
            image = cfg.storeOverlayImage;
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
            id = cfg.tap;
            inherit (cfg) mac;
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

      networking.useNetworkd = true;
      systemd.network.networks."10-uplink" = {
        matchConfig.Type = "ether";
        networkConfig = {
          # The IPv6 address is a /128: the host routes only this address, and the
          # rest of the LAN's /64 must go through it too.
          Address = ["${cfg.address}/30"] ++ lib.optional (cfg.address6 != null) "${cfg.address6}/128";
          Gateway = [cfg.hostAddress] ++ lib.optional (cfg.hostAddress6 != null) cfg.hostAddress6;
          # Public resolvers: the LAN router is unreachable from the guest.
          DNS = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
          DHCP = "no";
          IPv6AcceptRA = false;
        };
      };
      networking.firewall.allowedTCPPorts = [cfg.port];

      # Log in once with `sudo tailscale up`; state persists on the /var volume.
      # Leave --accept-routes off: subnet routes would let the guest reach the LAN
      # around the host's internet-only filtering.
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
      users.users.root.openssh.authorizedKeys.keys = cfg.admins;
      # SSH keys only: nix-config's user-drobson03 needs an agenix password the
      # guest cannot decrypt.
      users.users.${user} = {
        isNormalUser = true;
        description = fullName;
        openssh.authorizedKeys.keys = cfg.admins;
      };

      home-manager.sharedModules = with inputs.self.homeModules; [
        preset-server
        pi
        {
          home.packages = [
            # Interactive `agy`. T3 Code's ACP driver finds it through the
            # `agy_acp_server.par` shim that nix-config's t3code-server module adds.
            llmAgents.antigravity-cli
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
      # address so the forwarded port works regardless of how T3 classifies the
      # guest's private address. "::" is dual-stack, covering IPv4 and IPv6.
      systemd.services.t3code-server.environment.T3CODE_HOST = "::";

      system.stateVersion = "25.11";
    };
  };
}
