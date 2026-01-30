{inputs, ...}: {
  flake.nixosModules.linux-kernel-server = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkDefault;
  in {
    imports = [
      inputs.self.nixosModules.nix-cachyos-kernel
    ];

    boot.kernelPackages = mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-server;
  };
}
