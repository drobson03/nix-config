{
  flake.homeModules.pipewire = {pkgs, ...}: {
    home.packages = [
      pkgs.playerctl
      pkgs.wireplumber
    ];

    programs.waybar.settings.primary.modules-right = ["wireplumber"];
    programs.waybar.settings.primary.wireplumber = {
      on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
      format = "{volume}% {icon}";
      format-muted = "muted ";
      format-icons = {
        headphone = "";
        default = [
          ""
          ""
        ];
      };
    };
  };

  flake.nixosModules.pipewire = {
    security.rtkit.enable = true;

    services.pipewire.enable = true;
    services.pipewire.alsa.enable = true;
    services.pipewire.alsa.support32Bit = true;
    services.pipewire.pulse.enable = true;
  };
}
