{
  flake.homeModules.hyprpaper = {
    services.hyprpaper.enable = true;

    # programs.niri.settings.spawn-at-startup = [
    #   {argv = ["hyprpaper"];}
    # ];
  };
}
