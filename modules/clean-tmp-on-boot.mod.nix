{
  flake.nixosModules.clean-tmp-on-boot = {
    boot.tmp.cleanOnBoot = true;
  };
}
