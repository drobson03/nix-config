{
  flake.homeModules.starship = {
    programs.starship.enable = true;
    programs.starship.settings.nix_shell.heuristic = true;
  };
}
