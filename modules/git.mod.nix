{
  flake.homeModules.git = {
    programs.git.enable = true;

    programs.git.signing = {
      signByDefault = true;
      format = "ssh";
    };

    programs.git.settings = {
      merge.conflictStyle = "diff3";
      init.defaultBranch = "main";
    };
  };
}
