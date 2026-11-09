{inputs, ...}: {
  # One-off tools agents reach for outside a project dev shell.
  flake.homeModules.agent-toolbox = {pkgs, ...}: {
    home.packages = [
      pkgs.nodejs_24 # node, npm, npx, corepack
      pkgs.pnpm
      pkgs.python3
      pkgs.dig
      pkgs.postgresql # psql, pg_isready (client use only, no service)
    ];
  };

  # Libraries for downloaded Chromium builds: T3's chrome-headless-shell and Playwright.
  flake.nixosModules.agent-toolbox = {pkgs, ...}: {
    imports = [inputs.self.nixosModules.nix-ld];

    programs.nix-ld.libraries = with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      dbus
      expat
      glib
      libgbm
      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxkbcommon
      libxrandr
      nspr
      nss
    ];

    home-manager.sharedModules = [inputs.self.homeModules.agent-toolbox];
  };
}
