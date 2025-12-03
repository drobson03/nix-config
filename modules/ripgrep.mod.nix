{
  flake.homeModules.ripgrep = {
    programs.ripgrep.enable = true;
    programs.ripgrep.arguments = ["--line-number" "--smart-case"];
  };
}
