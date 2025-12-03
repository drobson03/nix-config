{inputs, ...}: {
  flake.homeModules.agenix = {pkgs, ...}: {
    imports = [
      inputs.agenix.homeManagerModules.default
    ];

    home.packages = [
      pkgs.ragenix
    ];
  };

  flake.nixosModules.agenix = {
    imports = [
      inputs.agenix.nixosModules.default
    ];

    home-manager.sharedModules = [
      inputs.self.homeModules.agenix
    ];
  };
}
