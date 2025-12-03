{
  flake.nixosModules.user-root = {config, ...}: {
    age.secrets.root.file = ./root.age;
    users.users.root.hashedPasswordFile = config.age.secrets.root.path;
  };
}
