{inputs}: {pkgs, ...}: {
  unfree.allowedNames = [
    "steam"
    "steam-unwrapped"
    "castlabs-electron"
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

      pwvucontrol
      tidal-hifi

      prismlauncher
      (inputs.osu-lazer.packages.${stdenv.hostPlatform.system}.osu-lazer-bin.override {
        channel = "tachyon";
      })
    ];

    xdg.configFile."mimeapps.list".force = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/discord" = "vesktop.desktop";
        "x-scheme-handler/t3code" = "com.t3tools.T3Code.desktop";
        "x-scheme-handler/tidal" = "tidal-hifi.desktop";
      };
    };
  };
}
