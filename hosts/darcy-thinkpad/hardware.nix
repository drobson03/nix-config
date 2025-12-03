{
  config,
  lib,
  modulesPath,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "uas" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;

  home-manager.sharedModules = [
    {
      programs.niri.settings.outputs = {
        "HP Inc. HP P24 G5 CNC3291ZLV" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 74.973;
          };
          position = {
            x = 0;
            y = 0;
          };
        };

        "Lenovo Group Limited MNE007JA1-3 Unknown" = {
          scale = 1.0;
          position = {
            x = 0;
            y = 1080;
          };
        };
      };
    }
  ];
}
