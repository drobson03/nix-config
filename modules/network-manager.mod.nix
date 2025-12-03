{
  flake.nixosModules.network-manager = {
    networking.networkmanager.enable = true;
  };
}
