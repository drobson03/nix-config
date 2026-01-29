{
  flake.homeModules.hyprland = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkDefault;
    inherit (lib.lists) flatten range;
  in {
    home.packages = [
      pkgs.brightnessctl
      pkgs.grim
      pkgs.slurp
      pkgs.swappy
    ];

    services.mako.enable = true;

    programs.waybar.settings.primary.modules-left = [
      "hyprland/workspaces"
    ];

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.package = null;
    wayland.windowManager.hyprland.portalPackage = null;

    wayland.windowManager.hyprland.settings = {
      "$mainMod" = mkDefault "SUPER";
      "$screenshot" = "slurp | grim -g - - | swappy -f - -o - | wl-copy --type image/png && wl-paste > $HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png";

      monitor = [
        ",preferred,auto,auto,vrr,0"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 12;

        border_size = 2;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = true;

        layout = "dwindle";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 4;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 0.5;

        shadow = {
          enabled = false;
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        animation = [
          "windows, 1, 7, default"
          "windowsOut, 1, 7, default"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 0, 7, default"
          "workspaces, 0, 6, default"
        ];
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      master.new_status = "master";

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
        vfr = 0;
      };

      opengl.nvidia_anti_flicker = 0;
      debug.damage_tracking = 0;

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "us";

        follow_mouse = 1;

        repeat_delay = 300;
        repeat_rate = 50;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat";

        touchpad.natural_scroll = true;
      };

      gestures.workspace_swipe = true;

      bind = flatten [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod SHIFT, E, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, D, exec, $menu"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        (range 1 9
          |> map toString
          |> map (n: [
            "$mainMod, ${n}, workspace, ${n}"
            "$mainMod SHIFT, ${n}, movetoworkspace, ${n}"
          ]))
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        # "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        "$mainMod SHIFT, L, dpms, toggle"
        "$mainMod, F, fullscreen"
        "$mainMod SHIFT, S, exec, $screenshot"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "$mainMod, Control_L, movewindow"
        "$mainMod, ALT_L, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      cursor = {
        no_hardware_cursors = true;
      };

      windowrulev2 = [
        "opacity 1.0 override 1.0 override, floating:1"
        "opacity 1.0 override 1.0 override, class:^(org.pwmt.zathura)$"
        "opacity 1.0 override 0.8 override, class:^(chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default)$"
      ];
    };
  };

  flake.nixosModules.hyprland = {pkgs, ...}: {
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = true;

    services.greetd.settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start Hyprland'";
  };
}
