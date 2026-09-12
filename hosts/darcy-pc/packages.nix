# Applications and system integrations from this PC's pacman inventory.
{inputs}: {
  lib,
  pkgs,
  ...
}: let
  androidSdk =
    (pkgs.androidenv.composeAndroidPackages {
      toolsVersion = null; # Exclude the obsolete Android SDK tools.
      platformVersions = [];
      buildToolsVersions = [];
      includeCmake = false;
      includeEmulator = false;
      includeSystemImages = false;
      includeNDK = false;
    }).androidsdk;
in {
  unfree.allowedNames = [
    "androidsdk"
    "cmdline-tools"
    "android-sdk-cmdline-tools"
    "android-sdk-platform-tools"
    "platform-tools"
    "anydesk"
    "cuda-merged"
    "castlabs-electron"
    "cursor"
    "discord"
    "discord-unwrapped"
    "discord-canary"
    "discord-canary-unwrapped"
    "google-chrome"
    "rar"
    "steam"
    "steam-unwrapped"
    "vivaldi"

    # CUDA compiler and libraries.
    "cuda_cuobjdump"
    "cuda_gdb"
    "cuda_nvcc"
    "cuda_nvdisasm"
    "cuda_nvprune"
    "cuda_cccl"
    "cuda_cudart"
    "cuda_cupti"
    "cuda_cuxxfilt"
    "cuda_nvml_dev"
    "cuda_nvrtc"
    "cuda_nvtx"
    "cuda_profiler_api"
    "cuda_sanitizer_api"
    "libcublas"
    "libcufft"
    "libcurand"
    "libcusolver"
    "libcusparse"
    "libnpp"
    "libnvjitlink"
  ];
  nixpkgs.config.android_sdk.accept_license = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
    protontricks.enable = true;
  };
  hardware.graphics = {
    enable32Bit = true;
    extraPackages = [pkgs.nvidia-vaapi-driver];
  };

  # Keep Niri as the default login session; Hyprland is also available.
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;

  services.pipewire.jack.enable = true;
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = false;
  users.users.drobson03.extraGroups = ["dialout"];

  virtualisation.waydroid.enable = true;
  # Like Arch, start the container on demand rather than on every boot.
  systemd.services.waydroid-container.wantedBy = lib.mkForce [];

  # These services were enabled on Arch.
  services.chrony.enable = true;
  services.timesyncd.enable = false;
  services.resolved.enable = true;
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  environment.systemPackages = with pkgs; [
    android-tools
    clamav
    efibootmgr
    efitools
    lshw
    minicom
    nfs-utils
    partclone
    sbctl
    smartmontools
    # Ventoy is pending: the pinned package is marked insecure.
  ];

  fonts.packages = [pkgs.source-han-sans];

  home-manager.users.drobson03 = {
    # Multiple JDKs cannot share bin/java in the same profile.
    home.sessionVariables = {
      JAVA_HOME = "${pkgs.jdk}";
      JDK17_HOME = "${pkgs.jdk17}";
      JDK25_HOME = "${pkgs.jdk25}";
      ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    };

    home.packages = with pkgs; [
      # Browsers, communications, study and remote-access clients.
      anki
      anydesk
      discord
      discord-canary
      google-chrome
      rustdesk-flutter
      vesktop
      (vivaldi.override {proprietaryCodecs = true;})
      inputs.zen-browser.packages.${stdenv.hostPlatform.system}.beta

      # Graphics, engineering, video and audio.
      audacity
      blender
      calf
      easyeffects
      ffmpeg
      flite
      godot
      imagemagick
      inkscape
      kicad
      logisim-evolution
      lsp-plugins
      mpv
      obs-studio
      pwvucontrol
      tidal-hifi
      vlc
      xournalpp
      zathura

      # Games and compatibility tools (Steam is configured above).
      lutris
      prismlauncher
      umu-launcher
      wineWow64Packages.stable
      winetricks
      inputs.osu-lazer.packages.${stdenv.hostPlatform.system}.osu-lazer-tachyon-bin

      # Development tools, including embedded and Android development.
      androidSdk
      autoconf
      automake
      avrdude
      pkgsCross.avr.avrlibc
      # Beekeeper Studio is pending: the pinned package is marked insecure.
      binutils
      bison
      ccache
      ccls
      (lib.lowPrio clang)
      cmake
      code-cursor
      cudaPackages.cudatoolkit
      delta
      dotnetCorePackages.runtime_8_0
      flex
      gcc
      gettext
      gcc-arm-embedded
      gdb
      gh
      gnumake
      go
      jdk
      kubectl
      libtool
      m4
      meson
      mold
      ninja
      nodejs
      opam
      openblas
      patch
      perlPackages.FileHomeDir
      perlPackages.YAMLTiny
      pkg-config
      pkgsCross.avr.buildPackages.gcc
      postgresql
      (python3.withPackages (p: [p.capstone p.pyelftools]))
      rustup
      scrcpy
      spirv-headers
      t3code
      tree-sitter
      volk
      vulkan-extension-layer
      vulkan-headers
      vulkan-loader
      vulkan-tools
      vulkan-tools-lunarg
      vulkan-utility-libraries
      vulkan-validation-layers

      # CLI utilities and the full TeX Live collection installed on Arch.
      aria2
      grim
      hexyl
      iperf3
      kalker
      kitty
      libva-utils
      man-pages
      ncdu
      nushell
      rar
      screen
      slurp
      stow
      texliveFull
      traceroute
      vdpauinfo
      zip
    ];
  };
}
