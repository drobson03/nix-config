{inputs, ...}: {
  flake.homeModules.preset-server = {
    imports = with inputs.self.homeModules; [
      atuin
      bat
      diff
      direnv
      fuzzel
      git
      jujutsu
      nixvim
      packages
      ripgrep
      starship
      tmux
      zsh
    ];
  };

  flake.nixosModules.preset-server = {
    imports = with inputs.self.nixosModules; [
      agenix
      clean-tmp-on-boot
      ghostty
      home-manager
      immutable-users
      linux-kernel-server
      network-manager
      nix-ld
      nix
      openssh
      packages
      scx
      zram
      zsh

      {
        home-manager.sharedModules = with inputs.self.homeModules; [
          preset-server
        ];
      }
    ];
  };
}
