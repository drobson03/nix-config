{inputs, ...}: {
  flake.homeModules.obsidian = {
    programs.obsidian.enable = true;
  };

  flake.nixosModules.obsidian = {lib, ...}: let
    inherit (lib) getName;
  in {
    home-manager.sharedModules = [
      inputs.self.homeModules.obsidian
    ];

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (getName pkg) [
        "obsidian"
      ];
  };
}
