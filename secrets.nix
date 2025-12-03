let
  inherit (import ./keys.nix) admins all darcy-thinkpad;
in {
  "users/drobson03.age".publicKeys = [darcy-thinkpad] ++ admins;
  "users/root.age".publicKeys = all;
}
