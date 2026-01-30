{inputs, ...}: {
  flake.nixosModules.linux-kernel-desktop = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkDefault;
  in {
    imports = [
      inputs.self.nixosModules.nix-cachyos-kernel
    ];

    boot.kernelPackages = mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  };
}
