{inputs, ...}: {
  flake.nixosModules.linux-kernel-server = {pkgs, ...}: {
    imports = [
      inputs.self.nixosModules.chaotic-nyx
    ];

    boot.kernelPackages = pkgs.linuxPackages_cachyos-server;
  };
}
