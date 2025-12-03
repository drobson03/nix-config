{
  flake.homeModules.opencode = {
    programs.opencode.enable = true;
    programs.opencode.settings.autoshare = false;
    programs.opencode.settings.autoupdate = false;
  };
}
