let
  inherit (import ./keys.nix) admins all darcy-pc darcy-thinkpad;
in {
  "users/drobson03.age".publicKeys = [darcy-pc darcy-thinkpad] ++ admins;
  "users/root.age".publicKeys = all;
}
