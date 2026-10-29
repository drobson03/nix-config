{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;

  t3code = pkgs: inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.t3code;

  serviceConfig = {
    dataDir,
    pkgs,
  }: {
    Type = "simple";
    EnvironmentFile = "-${dataDir}/service.env";
    # `serve` runs the packaged server directly. `__service-launcher` would
    # instead exec ~/.t3/runtime/versions/<activeVersion>/t3, bypassing Nix.
    ExecStart = "${lib.getExe (t3code pkgs)} serve";
    KillMode = "mixed";
    OOMPolicy = "continue";
    Restart = "always";
    RestartSec = 5;
    CPUWeight = 1000;
    IOWeight = 1000;
    ManagedOOMPreference = "avoid";
  };
in {
  flake.homeModules.t3code = {
    config,
    pkgs,
    ...
  }: let
    t3Home = "${config.home.homeDirectory}/.t3";
  in {
    home.packages = [
      (t3code pkgs)
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.t3code-desktop
    ];

    systemd.user.services.t3code-server = {
      Unit = {
        Description = "T3 Code server";
        StartLimitIntervalSec = 300;
        StartLimitBurst = 5;
      };

      Service =
        serviceConfig {
          inherit pkgs;
          dataDir = t3Home;
        }
        // {
          WorkingDirectory = "%h";
          Environment = [
            "T3CODE_HOME=${t3Home}"
            "T3CODE_HOST=0.0.0.0"
          ];
        };

      Install.WantedBy = ["default.target"];
    };
  };

  flake.nixosModules.t3code = {
    imports = [
      inputs.self.nixosModules.llm-agents-cache
    ];

    home-manager.sharedModules = [
      inputs.self.homeModules.t3code
    ];
  };

  flake.nixosModules.t3code-server = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.services.t3code-server) user;
    home = config.users.users.${user}.home;
    dataDir = "${home}/.t3";
  in {
    imports = [
      inputs.self.nixosModules.llm-agents-cache
    ];

    options.services.t3code-server.user = lib.mkOption {
      type = lib.types.str;
      description = "Existing user to run T3 Code and its agents as.";
    };

    config = {
      environment.systemPackages = [(t3code pkgs)];

      systemd.services.t3code-server = {
        description = "T3 Code server";
        wantedBy = ["multi-user.target"];
        after = ["network-online.target"];
        wants = ["network-online.target"];
        startLimitIntervalSec = 300;
        startLimitBurst = 5;

        # Agents and terminals need the full user environment, not the unit's minimal PATH.
        path = [
          "/run/wrappers"
          "/etc/profiles/per-user/${user}"
          "/run/current-system/sw"
        ];

        environment = {
          T3CODE_HOME = dataDir;
          T3CODE_PORT = "3773";
        };

        serviceConfig =
          serviceConfig {
            inherit pkgs;
            inherit dataDir;
          }
          // {
            User = user;
            Group = config.users.users.${user}.group;
            WorkingDirectory = home;
          };
      };
    };
  };
}
