{
  flake.nixosModules.greetd = {
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkDefault;
  in {
    services.greetd = {
      enable = mkDefault true;
      settings = {
        default_session = {
          command = mkDefault "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${config.services.greetd.settings.default_session.command or "bash"}";
          user = mkDefault "greeter";
        };
      };
    };
  };
}
