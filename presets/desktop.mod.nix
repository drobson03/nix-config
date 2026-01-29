{inputs, ...}: {
  flake.homeModules.preset-desktop = {
    imports = with inputs.self.homeModules; [
      atuin
      bat
      chromium
      diff
      direnv
      fuzzel
      ghostty
      git
      gtk
      hyprlock
      hyprpaper
      jujutsu
      mako
      niri
      nixvim
      packages
      pipewire
      qt
      ripgrep
      starship
      tmux
      waybar
      wayland
      zsh
    ];
  };

  flake.nixosModules.preset-desktop = {
    imports = with inputs.self.nixosModules; [
      agenix
      clean-tmp-on-boot
      extra-fonts
      ghostty
      greetd
      gtk
      home-manager
      hyprlock
      immutable-users
      linux-kernel-desktop
      network-manager
      niri
      nix-ld
      nix
      openssh
      packages
      pipewire
      scx
      stylix
      wayland
      zram
      zsh

      {
        home-manager.sharedModules = with inputs.self.homeModules; [
          preset-desktop
        ];
      }
    ];
  };
}
