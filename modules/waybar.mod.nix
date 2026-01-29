{
  flake.homeModules.waybar = {
    programs.waybar.enable = true;
    programs.waybar.systemd.enable = true;
    programs.waybar.settings.primary = {
      modules-center = [
        "clock"
        "battery"
      ];
      modules-right = [
        "backlight"
        "network"
        "memory"
        "tray"
      ];
      tray = {
        spacing = 10;
      };
      backlight = {
        format = "{percent}% {icon}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };
      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
      memory = {
        interval = 30;
        format = "{}% ";
      };
      battery = {
        states = {
          warning = 20;
          critical = 10;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
    };
    programs.waybar.style = ''
      * {
        /* `otf-font-awesome` is required to be installed for icons */
        font-family: FontAwesome, Roboto, Helvetica, Arial,
          sans-serif;
        font-size: 1rem;
      }

      window#waybar {
        background-color: rgba(31, 41, 55, 0);
        border-bottom: 1px solid #374151;
        color: #ffffff;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
      }

      button:hover {
        background: inherit;
        box-shadow: inset 0 -3px #ffffff;
      }

      #workspaces button {
        margin: 0;
        padding: 0.25rem 0.25rem;
        color: #d1d5db;
      }

      #workspaces button.focused,
      #workspaces button.active {
        color: #ffffff;
        background-color: #374151;
        box-shadow: inset 0 -1px #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #power-profiles-daemon,
      #mpd {
        padding: 0 1rem;
        color: #ffffff;
      }

      #clock,
      #battery {
        background-color: transparent;
        border-left: 1px solid #374151;
      }

      #battery,
      #clock:only-child {
        border-right: 1px solid #374151;
      }

      #window,
      #workspaces {
        margin: 0;
      }

      .modules-right > :not(:first-child) {
        margin-left: 0.5rem;
      }
    '';

    programs.niri.settings.binds."Mod+Shift+W".action.spawn = ["sh" "-c" "pkill waybar && waybar"];

    wayland.windowManager.hyprland.settings.exec-once = [
      "waybar"
    ];

    wayland.windowManager.hyprland.settings.bind = [
      "SUPER SHIFT, W, exec, pkill waybar && waybar"
    ];
  };
}
