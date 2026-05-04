{
  flake.nixosModules.nix = {
    config,
    lib,
    ...
  }: {
    options.unfree.allowedNames = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Package names permitted by nixpkgs.config.allowUnfreePredicate.";
    };

    config = {
      nix.settings.experimental-features = ["cgroups" "flakes" "nix-command" "pipe-operators"];
      nix.settings.trusted-users = ["root" "@wheel"];
      nix.optimise.automatic = true;

      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) config.unfree.allowedNames;
    };
  };
}
