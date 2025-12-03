{
  flake.homeModules.fuzzel = {pkgs, ...}: {
    home.packages = [
      pkgs.uwsm
    ];

    programs.fuzzel.enable = true;
    programs.fuzzel.settings = {
      main = {
        prompt = "";

        width = 60;

        inner-pad = 8;
        horizontal-pad = 16;
        vertical-pad = 16;
      };
    };

    programs.niri.settings.binds."Mod+D".action.spawn = [
      "fuzzel"
      "--launch-prefix"
      "uwsm app -- "
    ];

    wayland.windowManager.hyprland.settings."$menu" = ''fuzzel --launch-prefix="uwsm app -- "'';
  };
}
