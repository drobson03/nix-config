{
  flake.nixosModules.zram = {
    services.zram-generator.enable = true;
    services.zram-generator.settings.zram0 = {
      compression-algorithm = "zstd lz4 (type=huge)";
      zram-size = "ram";
      swap-priority = 100;
      fs-type = "swap";
    };
  };
}
