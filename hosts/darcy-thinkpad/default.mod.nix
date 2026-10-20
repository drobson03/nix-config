{inputs, ...}: let
  hostname = "darcy-thinkpad";
in {
  flake.nixosConfigurations.${hostname} = let
    system = "x86_64-linux";
    stateVersion = "25.11";
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = with inputs.self.nixosModules; [
        {nixpkgs.hostPlatform = system;}

        bluetooth
        displaylink
        docker
        obsidian
        nixvim
        preset-desktop

        user-drobson03
        user-root

        {
          home-manager.sharedModules = [inputs.self.homeModules.pi];

          nix.settings = {
            extra-substituters = ["https://cache.numtide.com"];
            extra-trusted-public-keys = [
              "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            ];
          };
        }

        ./hardware.nix
        "${inputs.nixos-hardware}/lenovo/thinkpad/p14s/amd/gen6"
        "${inputs.nixos-hardware}/common/wifi/mediatek/mt7925"

        {
          home-manager.sharedModules = with inputs.self.homeModules; [
            vim-mode

            ({
              config,
              lib,
              pkgs,
              ...
            }: let
              t3code = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.t3code;
              t3Home = "${config.home.homeDirectory}/.t3";
            in {
              home.packages = with pkgs; [
                teams-for-linux
                github-cli

                inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt
                inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
                inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
                inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.t3code-desktop
                t3code
              ];
              programs.chromium.package = lib.mkForce inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.Ev357.helium;

              systemd.user.services.t3code-server = {
                Unit = {
                  Description = "T3 Code server";
                  StartLimitIntervalSec = 300;
                  StartLimitBurst = 5;
                };

                Service = {
                  Type = "simple";
                  WorkingDirectory = "%h";
                  Environment = [
                    "T3CODE_HOME=${t3Home}"
                    "T3CODE_HOST=0.0.0.0"
                  ];
                  EnvironmentFile = "-${t3Home}/service.env";
                  # `serve` runs the packaged server directly. `__service-launcher` would
                  # instead exec ~/.t3/runtime/versions/<activeVersion>/t3, bypassing Nix.
                  ExecStart = "${lib.getExe t3code} serve";
                  KillMode = "mixed";
                  OOMPolicy = "continue";
                  Restart = "always";
                  RestartSec = 5;
                  CPUWeight = 1000;
                  IOWeight = 1000;
                  ManagedOOMPreference = "avoid";
                };

                Install.WantedBy = ["default.target"];
              };
            })
            {home.stateVersion = stateVersion;}
          ];

          services.gvfs.enable = true;
          services.udisks2.enable = true;
          services.upower.enable = true;

          hardware.keyboard.qmk.enable = true;

          services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

          system.stateVersion = stateVersion;

          networking.hostName = hostname;
          networking.nftables.enable = true;

          time.timeZone = "Australia/Brisbane";
          i18n.defaultLocale = "en_AU.UTF-8";
        }
      ];
    };
}
