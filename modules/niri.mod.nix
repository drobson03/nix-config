{inputs, ...}: {
  flake.homeModules.niri = {pkgs, ...}: {
    home.packages = [
      pkgs.brightnessctl
      pkgs.hyprpicker
      pkgs.nautilus
    ];

    programs.niri.settings = {
      input = {
        keyboard = {
          repeat-delay = 300;
          repeat-rate = 50;
          numlock = true;
        };

        touchpad = {
          tap = true;
          natural-scroll = true;
          accel-speed = 0.05;
        };

        mouse = {
          accel-speed = 0.0;
          accel-profile = "flat";
        };
      };

      layout = {
        gaps = 12;

        center-focused-column = "never";

        preset-column-widths = [
          {proportion = 1. / 3.;}
          {proportion = 1. / 2.;}
          {proportion = 2. / 3.;}
          {proportion = 3. / 4.;}
        ];

        default-column-width = {proportion = 1.0;};

        focus-ring = {
          width = 4;
          active = {color = "#7fc8ff";};
          inactive = {color = "#505050";};
        };

        border.enable = false;

        struts = {
          left = 4;
          right = 4;
          top = 4;
          bottom = 4;
        };
      };

      spawn-at-startup = [
        {argv = ["dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"];}
      ];

      hotkey-overlay.skip-at-startup = true;

      prefer-no-csd = true;

      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 4.0;
            bottom-right = 4.0;
            top-left = 4.0;
            top-right = 4.0;
          };
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
      ];

      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};

        # Audio and brightness controls
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        };

        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn = ["playerctl" "next"];
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn = ["playerctl" "previous"];
        };
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn = ["playerctl" "play-pause"];
        };
        "XF86AudioPause" = {
          allow-when-locked = true;
          action.spawn = ["playerctl" "play-pause"];
        };

        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = ["brightnessctl" "--class=backlight" "set" "+10%"];
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = ["brightnessctl" "--class=backlight" "set" "10%-"];
        };

        # Overview
        "Mod+O" = {
          repeat = false;
          action.toggle-overview = {};
        };

        # Window management
        "Mod+Shift+Q" = {
          repeat = false;
          action.close-window = {};
        };

        # Focus navigation
        "Mod+Left".action.focus-column-left = {};
        "Mod+Down".action.focus-window-down = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+Right".action.focus-column-right = {};
        "Mod+H".action.focus-column-left = {};
        "Mod+J".action.focus-window-down = {};
        "Mod+K".action.focus-window-up = {};
        "Mod+L".action.focus-column-right = {};

        # Move windows/columns
        "Mod+Ctrl+Left".action.move-column-left = {};
        "Mod+Ctrl+Down".action.move-window-down = {};
        "Mod+Ctrl+Up".action.move-window-up = {};
        "Mod+Ctrl+Right".action.move-column-right = {};
        "Mod+Ctrl+H".action.move-column-left = {};
        "Mod+Ctrl+J".action.move-window-down = {};
        "Mod+Ctrl+K".action.move-window-up = {};
        "Mod+Ctrl+L".action.move-column-right = {};

        # Column first/last
        "Mod+Home".action.focus-column-first = {};
        "Mod+End".action.focus-column-last = {};
        "Mod+Ctrl+Home".action.move-column-to-first = {};
        "Mod+Ctrl+End".action.move-column-to-last = {};

        # Monitor navigation
        "Mod+Shift+Left".action.focus-monitor-left = {};
        "Mod+Shift+Down".action.focus-monitor-down = {};
        "Mod+Shift+Up".action.focus-monitor-up = {};
        "Mod+Shift+Right".action.focus-monitor-right = {};
        "Mod+Shift+H".action.focus-monitor-left = {};
        "Mod+Shift+J".action.focus-monitor-down = {};
        "Mod+Shift+K".action.focus-monitor-up = {};
        "Mod+Shift+L".action.focus-monitor-right = {};

        # Move to monitor
        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = {};
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = {};
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = {};
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = {};
        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = {};
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = {};
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = {};
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = {};

        # Workspace navigation
        "Mod+Page_Down".action.focus-workspace-down = {};
        "Mod+Page_Up".action.focus-workspace-up = {};
        "Mod+U".action.focus-workspace-down = {};
        "Mod+I".action.focus-workspace-up = {};
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
        "Mod+Ctrl+U".action.move-column-to-workspace-down = {};
        "Mod+Ctrl+I".action.move-column-to-workspace-up = {};

        "Mod+Shift+Page_Down".action.move-workspace-down = {};
        "Mod+Shift+Page_Up".action.move-workspace-up = {};
        "Mod+Shift+U".action.move-workspace-down = {};
        "Mod+Shift+I".action.move-workspace-up = {};

        # Mouse wheel workspace navigation
        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = {};
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = {};
        };
        "Mod+Ctrl+WheelScrollDown" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-down = {};
        };
        "Mod+Ctrl+WheelScrollUp" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-up = {};
        };

        "Mod+WheelScrollRight".action.focus-column-right = {};
        "Mod+WheelScrollLeft".action.focus-column-left = {};
        "Mod+Ctrl+WheelScrollRight".action.move-column-right = {};
        "Mod+Ctrl+WheelScrollLeft".action.move-column-left = {};

        "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
        "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
        "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = {};
        "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = {};

        # Workspace by number
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        # Consume/expel windows
        "Mod+BracketLeft".action.consume-or-expel-window-left = {};
        "Mod+BracketRight".action.consume-or-expel-window-right = {};
        "Mod+Comma".action.consume-window-into-column = {};
        "Mod+Period".action.expel-window-from-column = {};

        # Column/window resizing and layout
        "Mod+R".action.switch-preset-column-width = {};
        "Mod+Shift+R".action.switch-preset-window-height = {};
        "Mod+Ctrl+R".action.reset-window-height = {};
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+Ctrl+F".action.expand-column-to-available-width = {};
        "Mod+C".action.center-column = {};
        "Mod+Ctrl+C".action.center-visible-columns = {};

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # Floating and tabbed modes
        "Mod+V".action.toggle-window-floating = {};
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = {};
        "Mod+W".action.toggle-column-tabbed-display = {};

        # Screenshots
        "Print".action.screenshot = {};
        "Ctrl+Print".action.screenshot-screen = {};
        "Alt+Print".action.screenshot-window = {};

        # System
        "Mod+Escape" = {
          allow-inhibiting = false;
          action.toggle-keyboard-shortcuts-inhibit = {};
        };
        "Mod+Shift+E".action.quit = {};
        "Ctrl+Alt+Delete".action.quit = {};
        "Mod+Shift+P".action.power-off-monitors = {};

        # Custom shortcuts
        "Mod+Shift+C".action.spawn = ["sh" "-c" "hyprpicker | wl-copy"];
      };
    };

    programs.waybar.settings.primary.modules-left = [
      "niri/workspaces"
    ];
  };

  flake.nixosModules.niri = {pkgs, ...}: {
    imports = [
      inputs.niri.nixosModules.niri
    ];

    nixpkgs.overlays = [
      inputs.niri.overlays.niri
    ];

    programs.niri.enable = true;

    services.greetd.settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
  };
}
