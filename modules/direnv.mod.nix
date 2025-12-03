{
  flake.homeModules.direnv = {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.direnv.silent = true;

    programs.nixvim.plugins.direnv.enable = true;
  };
}
