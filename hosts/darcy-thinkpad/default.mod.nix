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
        niri
        preset-desktop

        user-drobson03
        user-root

        ./hardware.nix
        "${inputs.nixos-hardware}/common/cpu/amd"
        "${inputs.nixos-hardware}/common/cpu/amd/pstate.nix"
        "${inputs.nixos-hardware}/common/gpu/amd"
        "${inputs.nixos-hardware}/common/pc/ssd"
        "${inputs.nixos-hardware}/common/wifi/mediatek/mt7925"

        {
          home-manager.sharedModules = with inputs.self.homeModules; [
            opencode
            vim-mode

            {home.stateVersion = stateVersion;}
          ];

          system.stateVersion = stateVersion;

          networking.hostName = hostname;

          time.timeZone = "Australia/Brisbane";
          i18n.defaultLocale = "en_AU.UTF-8";
        }
      ];
    };
}
