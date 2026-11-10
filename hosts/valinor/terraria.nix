{config, ...}: {
  imports = [./terraria-config.nix];

  unfree.allowedNames = ["terraria-server"];

  users.users.drobson03.extraGroups = ["terraria"];

  services.terraria = {
    enable = true;
    openFirewall = true;
    noUPnP = true;
    maxPlayers = 8;
    worldPath = "${config.services.terraria.dataDir}/valinor.wld";
    autocreate = {
      enable = true;
      size = "large";
      difficulty = "master";
    };
  };
}
