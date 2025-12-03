{
  flake.nixosModules.user-drobson03 = {config, ...}: let
    username = "drobson03";
    fullName = "Darcy Robson";
    vcsEmail = "17976794+drobson03@users.noreply.github.com";
    signingKey = "~/.ssh/id_ed25519.pub";
  in {
    age.secrets.drobson03.file = ./drobson03.age;
    users.users.${username} = {
      isNormalUser = true;
      description = fullName;
      extraGroups = ["networkmanager" "wheel"];
      hashedPasswordFile = config.age.secrets.drobson03.path;
    };

    home-manager.users.${username} = {
      programs.git = {
        settings.user.name = fullName;
        settings.user.email = vcsEmail;
        signing.key = signingKey;
      };

      programs.jujutsu.settings = {
        user.name = fullName;
        user.email = vcsEmail;
        signing.key = signingKey;
      };

      home.shellAliases.ls = "eza --git --icons -h";
      home.shellAliases.find = "fd";
    };
  };
}
