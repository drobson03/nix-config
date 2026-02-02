{
  flake.homeModules.wayland = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkIf;
  in {
    home.packages = [
      pkgs.wl-clipboard
      pkgs.xdg-utils
    ];

    programs.niri.settings.environment = mkIf config.programs.niri.enable {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland,x11";
    };

    wayland.windowManager.hyprland.settings.env = [
      "ELECTRON_OZONE_PLATFORM_HINT,auto"
      "MOZ_ENABLE_WAYLAND,1"
      "SDL_VIDEODRIVER,wayland,x11"
      "XDG_SESSION_TYPE,wayland"
    ];
  };

  flake.nixosModules.wayland = {
    hardware.graphics.enable = true;

    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
    services.logind.settings.Login.HandlePowerKey = "ignore";
  };
}
