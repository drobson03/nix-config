{
  flake.homeModules.packages = {pkgs, ...}: {
    home.packages = [
      pkgs.btop
      pkgs.curl
      pkgs.eza
      pkgs.fastfetch
      pkgs.fd
      pkgs.fzf
      pkgs.hyperfine
      pkgs.lm_sensors
      pkgs.nix-output-monitor
      pkgs.pciutils
      pkgs.rsync
      pkgs.tokei
      pkgs.usbutils
      pkgs.which
      pkgs.yazi
    ];
  };

  flake.nixosModules.packages = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.rsync
    ];
  };
}
