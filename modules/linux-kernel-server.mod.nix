{inputs, ...}: {
  flake.nixosModules.linux-kernel-server = {pkgs, ...}: {
    imports = [
      inputs.self.nixosModules.nix-cachyos-kernel
    ];

    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-server;
  };
}
