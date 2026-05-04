{
  flake.homeModules.gtk = {config, ...}: {
    gtk.enable = true;
    gtk.gtk4.theme = config.gtk.theme;
  };

  flake.nixosModules.gtk = {
    programs.dconf.enable = true;
  };
}
