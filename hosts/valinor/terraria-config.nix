{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.terraria;
  worldSizes = {
    small = 1;
    medium = 2;
    large = 3;
  };
  difficulties = {
    normal = 0;
    expert = 1;
    master = 2;
    journey = 3;
  };
  settings =
    {
      world = cfg.worldPath;
      maxplayers = cfg.maxPlayers;
      port = cfg.port;
      password = cfg.password;
      motd = cfg.messageOfTheDay;
      banlist = cfg.banListPath;
      secure =
        if cfg.secure
        then 1
        else 0;
      upnp =
        if cfg.noUPnP
        then 0
        else 1;
    }
    // lib.optionalAttrs cfg.autocreate.enable {
      autocreate = worldSizes.${cfg.autocreate.size};
      difficulty = difficulties.${cfg.autocreate.difficulty};
      seed = cfg.autocreate.seed;
    };
  configFile =
    pkgs.writeText "terraria-serverconfig.txt"
    (lib.generators.toKeyValue {} (lib.filterAttrs (_: value: value != null) settings));
in {
  # Local equivalent of https://github.com/NixOS/nixpkgs/pull/314621.
  # Keep the upstream service's user, firewall, tmux console and graceful stop.
  options.services.terraria.autocreate = {
    enable = lib.mkEnableOption "automatic Terraria world creation";
    size = lib.mkOption {
      type = lib.types.enum (lib.attrNames worldSizes);
      default = cfg.autoCreatedWorldSize;
      description = "Size of a newly created world.";
    };
    difficulty = lib.mkOption {
      type = lib.types.enum (lib.attrNames difficulties);
      default = "normal";
      description = "Difficulty of a newly created world.";
    };
    seed = lib.mkOption {
      type = lib.types.nullOr lib.types.singleLineStr;
      default = null;
      description = "Optional seed for a newly created world.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.terraria.serviceConfig = {
      UMask = lib.mkForce "007";
      ExecStart = lib.mkForce (lib.escapeShellArgs [
        (lib.getExe pkgs.tmux)
        "-S"
        "${cfg.dataDir}/terraria.sock"
        "new"
        "-d"
        (lib.getExe cfg.package)
        "-config"
        configFile
      ]);
    };
  };
}
