{
  flake.homeModules.atuin = {
    programs.atuin.enable = true;
    programs.atuin.settings.workspaces = true;
    programs.atuin.settings.enter_accept = false;
  };
}
