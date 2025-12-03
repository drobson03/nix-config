{inputs, ...}: {
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
  };
}
