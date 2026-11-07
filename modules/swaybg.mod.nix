{
  flake.homeModules.swaybg = {
    config,
    lib,
    pkgs,
    ...
  }: let
    background =
      if config.stylix.image != null
      then ["-i" config.stylix.image "-m" "fill"]
      else ["-c" config.lib.stylix.colors.withHashtag.base00];
  in {
    systemd.user.services.swaybg = {
      Unit = {
        Description = "Wayland wallpaper daemon";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} ${lib.escapeShellArgs background}";
        Restart = "always";
        RestartSec = 10;
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
