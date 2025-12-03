let
  keys = {
    drobson03 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJiJCC03L2GRX20ceaRfAIQLSyGw8+nWUY0uoMZWwmC7";
    drobson03-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjk5YnMYik0fDpfS2QoNJzKefENiiqTf6IQQw5WW7Of";

    darcy-thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKxWwlA2L8vIKjnObO5AOZ2UfuEA6VRzVTloIFb++o8v";
  };
in
  keys
  // {
    admins = [keys.drobson03 keys.drobson03-2];
    all = builtins.attrValues keys;
  }
