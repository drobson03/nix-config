{inputs, ...}: {
  flake.homeModules.bluetooth = {
    programs.bluetuith.enable = true;
  };

  flake.nixosModules.bluetooth = {
    hardware.bluetooth.enable = true;

    home-manager.sharedModules = [inputs.self.homeModules.bluetooth];
  };
}
