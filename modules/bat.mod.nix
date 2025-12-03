{
  flake.homeModules.bat = let
    pager = "bat --plain";
  in {
    programs.bat.enable = true;
    programs.bat.config.pager = "less -FR";

    home.shellAliases.cat = "bat";
    home.shellAliases.less = pager;

    home.sessionVariables.MANPAGER = pager;
    home.sessionVariables.PAGER = pager;
  };
}
