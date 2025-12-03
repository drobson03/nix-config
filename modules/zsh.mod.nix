{
  flake.homeModules.zsh = {pkgs, ...}: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      package = pkgs.zsh;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    programs.atuin.enableZshIntegration = true;
    programs.direnv.enableZshIntegration = true;
  };

  flake.nixosModules.zsh = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) getExe;
  in {
    programs.zsh.enable = true;

    users.defaultUserShell = pkgs.zsh;

    environment.sessionVariables.SHELLS = getExe pkgs.zsh;
  };
}
