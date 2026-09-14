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
              lib,
              pkgs,
              ...
            }: {
              home.packages = with pkgs; [
                teams-for-linux
                github-cli

                inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt
                inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
                inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
                inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.t3code
                inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.t3code-desktop
              ];
              programs.chromium.package = lib.mkForce inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.Ev357.helium;
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
