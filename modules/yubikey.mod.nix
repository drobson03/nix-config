{
  flake.homeModules.yubikey = {pkgs, ...}: {
    home.packages = [
      pkgs.age-plugin-yubikey
      pkgs.yubikey-manager
    ];
  };

  flake.nixosModules.yubikey = {
    # PIV access for age-plugin-yubikey. FIDO2 SSH keys work without it.
    services.pcscd.enable = true;
  };
}
