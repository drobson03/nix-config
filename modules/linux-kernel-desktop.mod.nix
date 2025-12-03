{inputs, ...}: {
  flake.nixosModules.linux-kernel-desktop = {pkgs, ...}: {
    imports = [
      inputs.self.nixosModules.chaotic-nyx
    ];

    boot.kernelPackages = pkgs.linuxPackages_cachyos;
  };
}
