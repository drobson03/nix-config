{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod"];
  boot.kernelModules = ["kvm-amd"];

  # Current Arch partitions. Update these if the NixOS installation reformats them.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e860830b-3dfc-4789-82c5-5a53dd00e1bd";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D214-AD7F";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  # Swap is provided by the desktop preset's zram module.
  swapDevices = [];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  unfree.allowedNames = ["nvidia-x11" "nvidia-settings"];

  hardware.facter.reportPath = ./facter.json;
}
