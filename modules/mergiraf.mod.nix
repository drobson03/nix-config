{
  flake.homeModules.mergiraf = {
    programs.mergiraf = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
    };

    programs.jujutsu.settings.aliases.resolve-ast = ["resolve" "--tool" "mergiraf"];
  };
}
