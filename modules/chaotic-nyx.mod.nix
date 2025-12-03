{inputs, ...}: {
  flake.nixosModules.chaotic-nyx = {
    imports = [
      inputs.chaotic.nixosModules.default
    ];
  };
}
