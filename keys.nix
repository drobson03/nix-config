let
  # SSH keys that can log in as drobson03. Generate one per machine with
  # `ssh-keygen -t ed25519` and never copy private keys between machines.
  drobson03 = {
    # Legacy key copied between machines. Remove once the per-machine keys and
    # YubiKey below are in place.
    legacy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJiJCC03L2GRX20ceaRfAIQLSyGw8+nWUY0uoMZWwmC7";

    # darcy-pc = "ssh-ed25519 ...";
    # darcy-thinkpad = "ssh-ed25519 ...";

    # FIDO2 resident key. `-sk` keys can't be age recipients, so it only goes
    # in authorized keys, never `admins`.
    # yubikey = "sk-ssh-ed25519@openssh.com ...";
  };

  # Host keys (/etc/ssh/ssh_host_ed25519_key.pub), used to decrypt secrets at boot.
  hosts = {
    darcy-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0Dcg/PinjGItLDui+V7ArmhYhUwFD5KRDNp539jYp4";
    darcy-thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKxWwlA2L8vIKjnObO5AOZ2UfuEA6VRzVTloIFb++o8v";
  };

  # age recipients that can edit secrets with ragenix.
  admins = {
    # Legacy keys. Remove once yubikey and backup are set, then `ragenix --rekey`.
    legacy = drobson03.legacy;
    legacy-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjk5YnMYik0fDpfS2QoNJzKefENiiqTf6IQQw5WW7Of";

    # `age-plugin-yubikey --generate`, then the `age1yubikey1...` recipient.
    # yubikey = "age1yubikey1...";

    # `age-keygen`, private key kept offline in case the YubiKey is lost.
    # backup = "age1...";
  };
in
  hosts
  // {
    drobson03 = builtins.attrValues drobson03;
    admins = builtins.attrValues admins;
    all = builtins.attrValues hosts ++ builtins.attrValues admins;
  }
