{
  flake.nixosModules.openssh = {
    services.openssh.enable = true;
    services.openssh.settings.AcceptEnv = ["SHELLS" "COLORTERM"];
  };
}
