let
  inherit (import ./keys.nix) admins all darcy-pc darcy-thinkpad valinor;
in {
  "users/drobson03.age".publicKeys = [darcy-pc darcy-thinkpad valinor] ++ admins;
  "users/root.age".publicKeys = all;
}
