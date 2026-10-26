{inputs}: {
  lib,
  pkgs,
  ...
}: {
  unfree.allowedNames = [
    "steam"
    "steam-unwrapped"
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
    protontricks.enable = true;
  };
  hardware.graphics = {
    enable32Bit = true;
    extraPackages = [pkgs.nvidia-vaapi-driver];
  };

  services.timesyncd.enable = false;
  services.resolved.enable = true;
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  home-manager.users.drobson03 = {
    home.packages = with pkgs; [
      anki
      vesktop
      inputs.zen-browser.packages.${stdenv.hostPlatform.system}.beta

      easyeffects
      pwvucontrol
      tidal-hifi

      prismlauncher
      inputs.osu-lazer.packages.${stdenv.hostPlatform.system}.osu-lazer-tachyon-bin
    ];
  };
}
