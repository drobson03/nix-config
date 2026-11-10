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
      jujutsu
      mako
      mergiraf
      niri
      nixvim
      packages
      pipewire
      qt
      ripgrep
      starship
      swaybg
      tmux
      waybar
      wayland
      yubikey
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
      gvfs
      home-manager
      hyprlock
      immutable-users
      linux-kernel-desktop
      network-manager
      niri
      nix-ld
      nix
      nixvim
      openssh
      packages
      pipewire
      scx
      stylix
      udisks2
      wayland
      yubikey
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
