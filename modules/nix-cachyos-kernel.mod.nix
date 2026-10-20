{inputs, ...}: {
  flake.nixosModules.nix-cachyos-kernel = {
    nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];

    nix.settings.substituters = ["https://cache.lantian.pub/lantian"];
    nix.settings.trusted-public-keys = ["lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="];
  };
}
