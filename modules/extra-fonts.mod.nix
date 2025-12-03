{
  flake.nixosModules.extra-fonts = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      font-awesome
      liberation_ttf

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji

      nerd-fonts.symbols-only
    ];
  };
}
