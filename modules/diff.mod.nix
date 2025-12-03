{
  flake.homeModules.diff = {
    programs = {
      difftastic = {
        enable = true;
        git.enable = true;
        options.background = "dark";
      };

      git.settings.diff.algorithm = "histogram";
    };
  };
}
