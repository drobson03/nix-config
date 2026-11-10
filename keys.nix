let
  drobson03 = {
    darcy-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDYPSTNhFndq+ZSIctjl/2nuN/oDb4Vls9zIkxU8Zghj";
    # darcy-thinkpad = "ssh-ed25519 ...";

    yubikey = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIP1Ao3GJJt7x9jUpSReV9ANnvr3CH+HuyQu9ZJy0iOb0AAAADXNzaDpkcm9ic29uMDM=";
  };

  hosts = {
    darcy-pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0Dcg/PinjGItLDui+V7ArmhYhUwFD5KRDNp539jYp4";
    darcy-thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKxWwlA2L8vIKjnObO5AOZ2UfuEA6VRzVTloIFb++o8v";
  };

  admins = {
    yubikey = "age1yubikey1qfvrqlm0clsxnvapes9mxjpjrema8rjg38zcmug03suv5r750ruvycpwxmk";

    backup = "age1f7p7spf40s8muu7vwee6jyekrhgwuy8gyemsauc38jw5hnuews2qugrywm";
  };
in
  hosts
  // {
    drobson03 = builtins.attrValues drobson03;
    admins = builtins.attrValues admins;
    all = builtins.attrValues hosts ++ builtins.attrValues admins;
  }
