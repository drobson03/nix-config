{
  flake.homeModules.hyprpicker = {pkgs, ...}: {
    home.packages = [
      pkgs.hyprpicker
      pkgs.wl-clipboard
    ];

    wayland.windowManager.hyprland.settings."$pickColor" = "hyprpicker | wl-copy";
    wayland.windowManager.hyprland.bind = [
      "$mainMod SHIFT, C, exec, $pickColor"
    ];
  };
}
