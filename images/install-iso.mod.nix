{inputs, ...}: {
  flake.nixosConfigurations.nixos-install = let
    system = "x86_64-linux";
    stateVersion = "25.11";
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = with inputs.self.nixosModules; [
        {nixpkgs.hostPlatform = system;}

        preset-desktop

        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"

        ({lib, ...}: let
          inherit (lib) mkForce;
        in {
          home-manager.sharedModules = [
            {home.stateVersion = stateVersion;}
          ];

          system.stateVersion = stateVersion;

          time.timeZone = "Australia/Brisbane";
          i18n.defaultLocale = "en_AU.UTF-8";

          users.mutableUsers = mkForce false;
        })

        {
          environment.etc."nixos" = {
            source = ./.;
            mode = "0644";
          };

          environment.etc."nixos-generate-config.conf".text = ''
            [Defaults]
            Flake=1
          '';
        }
      ];
    };
}
