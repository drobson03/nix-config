{inputs, ...}: let
  hostname = "valinor";
  stateVersion = "25.11";
in {
  flake.nixosModules.host-valinor = {
    imports = with inputs.self.nixosModules; [
      preset-server

      user-drobson03
      user-root

      ./hardware.nix
      ./storage.nix
      ./restic.nix
      ./terraria.nix
      ./tailscale.nix

      (import ./t3code.nix {inherit inputs;})

      {
        networking.hostName = hostname;
        system.stateVersion = stateVersion;
        home-manager.sharedModules = [{home.stateVersion = stateVersion;}];
      }
    ];
  };
}
