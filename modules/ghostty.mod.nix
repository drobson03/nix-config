{
  flake.homeModules.ghostty = {
    programs.ghostty = {
      enable = true;
      installBatSyntax = true;

      settings = {
        window-decoration = false;
        confirm-close-surface = false;
      };
    };

    programs.niri.settings.binds."Mod+Return".action.spawn = ["ghostty" "--gtk-single-instance=true"];

    wayland.windowManager.hyprland.settings."$terminal" = "ghostty --gtk-single-instance=true";
  };

  flake.nixosModules.ghostty = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.ghostty.terminfo
    ];
  };
}
