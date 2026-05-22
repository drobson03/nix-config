{
  flake.homeModules.gtk = {
    config,
    lib,
    ...
  }: let
    inherit (lib) mkForce;
  in {
    gtk.enable = true;
    gtk.gtk4.theme = mkForce config.gtk.theme;
  };

  flake.nixosModules.gtk = {
    programs.dconf.enable = true;
  };
}
