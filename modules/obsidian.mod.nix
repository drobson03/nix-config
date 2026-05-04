{inputs, ...}: {
  flake.homeModules.obsidian = {
    programs.obsidian.enable = true;
  };

  flake.nixosModules.obsidian = {
    home-manager.sharedModules = [
      inputs.self.homeModules.obsidian
    ];

    unfree.allowedNames = ["obsidian"];
  };
}
