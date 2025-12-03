{inputs, ...}: {
  flake.nixosModules.stylix = {pkgs, ...}: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];

    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/chinoiserie-midnight.yaml";

    stylix.fonts = {
      sansSerif.name = "InterVariable";
      sansSerif.package = pkgs.inter;

      serif.name = "Noto Serif";
      serif.package = pkgs.noto-fonts;

      monospace.name = "JetBrainsMono Nerd Font";
      monospace.package = pkgs.nerd-fonts.jetbrains-mono;

      emoji.name = "Noto Color Emoji";
      emoji.package = pkgs.noto-fonts-color-emoji;
    };
  };
}
