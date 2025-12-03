{
  flake.homeModules.gtk = {
    gtk.enable = true;
  };

  flake.nixosModules.gtk = {
    programs.dconf.enable = true;
  };
}
