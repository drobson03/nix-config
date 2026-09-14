{
  flake.nixosModules.displaylink = {config, ...}: {
    services.xserver.videoDrivers = ["displaylink" "modesetting"];

    unfree.allowedNames = ["displaylink"];

    boot = {
      extraModulePackages = [config.boot.kernelPackages.evdi];

      initrd.kernelModules = [
        "evdi"
      ];
    };
  };
}
