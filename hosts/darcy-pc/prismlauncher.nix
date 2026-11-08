{inputs}: {
  home-manager.sharedModules = [
    ({pkgs, ...}: let
      # GTNH 2.9 requires Java 26; nixpkgs has no OpenJDK 26, so use Temurin
      jdk26 = pkgs.javaPackages.compiler.temurin-bin.jdk-26;
    in {
      imports = [inputs.prismix.homeModules.default];

      programs.prismlauncher = {
        enable = true;

        # nixpkgs defaults (jdk25, jdk21, jdk17, jdk8) plus Temurin 26
        package = pkgs.prismlauncher.override {
          jdks = with pkgs; [jdk26 jdk25 jdk21 jdk17 jdk8];
        };

        # prismix's unmanaged default (null) breaks eval; {} writes no instance files
        instances = {};

        config.java.path = "${jdk26}/bin/java";
      };
    })
  ];
}
