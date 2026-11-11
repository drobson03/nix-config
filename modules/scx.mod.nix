{
  flake.nixosModules.scx = {
    services.scx-loader = {
      enable = true;
      config.default_sched = "scx_rustland";
    };
  };
}
