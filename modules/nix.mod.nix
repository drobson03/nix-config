{
  flake.nixosModules.nix = {
    nix.settings.experimental-features = ["cgroups" "flakes" "nix-command" "pipe-operators"];
    nix.settings.trusted-users = ["root" "@wheel"];
    nix.optimise.automatic = true;
  };
}
