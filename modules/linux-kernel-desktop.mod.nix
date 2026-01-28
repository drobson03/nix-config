{inputs, ...}: {
  flake.nixosModules.linux-kernel-desktop = {pkgs, ...}: {
    imports = [
      inputs.self.nixosModules.nix-cachyos-kernel
    ];

    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  };
}
