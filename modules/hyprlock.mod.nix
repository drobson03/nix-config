{
  flake.homeModules.hyprlock = {
    programs.hyprlock.enable = true;
    programs.hyprlock.settings = {
      animations = {
        enabled = false;
      };

      general = {
        no_fade_in = true;
        no_fade_out = true;
        hide_cursor = false;
        grace = 0;
        disable_loading_bar = true;
        # immediate_render = true
      };

      background = {
        monitor = "";

        blur_passes = 0;
        blur_size = 7;
        noise = 0.0117;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      input-field = {
        monitor = "";
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        fade_on_empty = "false";
        rounding = -1;
        placeholder_text = ''<i><span foreground="##cdd6f4"></span></i>'';
        hide_input = "false";
        position = "0, -200";
        halign = "center";
        valign = "center";
      };

      label = {
        monitor = "";
        text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
        font_size = 22;
        position = "0, 300";
        halign = "center";
        valign = "center";
      };
    };

    programs.niri.settings.binds."Super+Alt+L".action.spawn = ["hyprlock"];

    wayland.windowManager.hyprland.settings.bind = [
      "$mainMod, L, exec, hyprlock"
    ];
  };

  flake.nixosModules.hyprlock = {
    security.pam.services.hyprlock = {};
  };
}
