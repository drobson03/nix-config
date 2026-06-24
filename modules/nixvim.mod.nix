{inputs, ...}: let
  unfreeNames = [
    "intelephense"
    "nvim-vtsls"
    "telescope-sg"
  ];
in {
  flake.homeModules.nixvim = {lib, ...}: let
    inherit (lib.filesystem) listFilesRecursive;
  in {
    imports =
      [
        inputs.nixvim.homeModules.nixvim
      ]
      ++ (listFilesRecursive ./nixvim);

    programs.nixvim.enable = true;
    programs.nixvim.defaultEditor = true;
    programs.nixvim.viAlias = true;
    programs.nixvim.vimAlias = true;
    programs.nixvim.vimdiffAlias = true;
    programs.nixvim.withNodeJs = true;
    programs.nixvim.nixpkgs.source = inputs.nixpkgs;
    programs.nixvim.nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) unfreeNames;
  };

  flake.nixosModules.nixvim = {
    unfree.allowedNames = unfreeNames;
  };
}
