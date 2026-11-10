{config, ...}: {
  services.restic.backups = let
    repository = "/tank/backups/restic";
    passwordFile = config.age.secrets.restic-repository-password.path;
    pruneOpts = [
      "--keep-last unlimited"
    ];
  in {
    homes = {
      inherit repository passwordFile pruneOpts;
      paths = ["/home/drobson03"];
    };

    terraria = {
      inherit repository passwordFile pruneOpts;
      paths = [config.services.terraria.dataDir];
    };
  };
}
