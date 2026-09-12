# Darcy PC: Arch package migration

Audited on 2026-09-13 using `pacman -Qqe` (212 explicitly installed packages),
`pacman -Qq`, `pacman -Qqm`, and enabled system/user units.
The additions are local to this PC in `packages.nix`; the ThinkPad keeps its
existing application selection. No system build or activation was performed
for this package audit.

The full installed inventory also revealed Steam, steam-devices,
steam-native-runtime, Wine, winetricks, protontricks, and CachyOS Proton variants
installed as dependencies. Java 21 (the active default), Clang, CMake, GDB,
Meson, Ninja, Node.js/npm and .NET 8 runtime were also found among dependencies
and are included. Steam's NixOS module supplies its runtime and device
integration. GE-Proton and Nixpkgs Wine replace the CachyOS-specific builds.

## Differences and remaining migration work

- Beekeeper Studio is pending: nixpkgs marks version 6.0.5 insecure because its
  bundled Electron 39 is end-of-life with known CVEs. No insecure-package
  exception was added.
- Ventoy is also pending: the pinned package is marked insecure. No exception
  was added.
- Arch also has Java 26 installed, but the pinned nixpkgs has no `jdk26`.
  Java 26 is pending; the active Arch default, Java 21, is retained along with
  Java 17 and 25.
- Zen beta uses the pinned [Zen browser flake](https://github.com/0xc000022070/zen-browser-flake).
  osu! Tachyon uses the pinned [osu!lazer flake](https://github.com/repinek/osu-lazer-flake).
  Existing flake input revisions were retained.
- Chromium remains the existing preset's ungoogled-chromium. `discord_arch_electron`
  maps to standard Discord; Canary and Vesktop are also installed.
- `vulkan-html-docs` has no identified package equivalent in the pinned nixpkgs;
  the offline HTML documentation is not included. Vulkan headers, validation
  layers and tools are included.
- The full TeX Live suite, CUDA toolkit and KiCad 3D libraries are included to
  match the inventory. This substantially expands the future closure; its size
  has not been measured because builds are disabled.
- Java's default executable comes from `jdk`; `JDK17_HOME` and `JDK25_HOME`
  retain the other versions without competing `bin/java` entries.
- Android command-line tools and platform-tools are included. Additional SDK
  platforms/build-tools should be declared in the SDK composition or a project
  shell. `ANDROID_HOME` points to the immutable SDK in the Nix store.
- System-installed C/CUDA/OpenBLAS development packages do not recreate Arch's
  global `/usr/include` and `/usr/lib`. Projects may need Nix development shells
  with their headers, libraries and compiler environment declared.
- Hyprland is an additional session; Niri remains the configured default. Arch
  dotfiles, browser profiles, databases, game libraries and Android data have
  not been migrated by declaring packages.
- Chrony, resolved and ananicy-cpp reflect enabled Arch services. NetworkManager
  already handles DHCP. PostgreSQL, ClamAV, AnyDesk and RustDesk are installed
  without enabling their daemons. OpenTabletDriver has udev integration with
  daemon autostart disabled; Waydroid's container is started on demand.
- Boot filesystem UUIDs and encrypted account-password recipients still need
  checking before installation. The earlier system build failed in Niri's Rust
  compiler; that build issue was not changed as part of this audit.

## Validation

All added Home Manager and system package derivations evaluated successfully,
and NixOS/Home Manager module assertions passed. Evaluation used
`allow-import-from-derivation = false`, so it could not start a build. An
already installed copy of the same `chinoiserie-midnight` theme was supplied
as a temporary evaluation override to bypass Stylix's theme-package build;
the repository's theme configuration was not changed. Formatting and whitespace
checks passed. Build-time package collisions, upstream tests and runtime behavior
remain untested.

## Explicit package coverage

“Existing” means supplied by the original shared desktop or hardware modules.
“Dependency” means the functionality is provided by application closures or is
an unused integration library, rather than an Arch library copied into a Nix
profile. “Added” describes a declaration, not a completed build.

| Arch package | Status | NixOS coverage |
| --- | --- | --- |
| `adobe-source-han-sans-jp-fonts` | Added | `fonts.packages = [ pkgs.source-han-sans ]` |
| `amd-ucode` | Existing | NixOS hardware, filesystem and kernel modules |
| `android-sdk-cmdline-tools-latest` | Added | Minimal `androidenv.composeAndroidPackages` SDK, ANDROID_HOME, and ADB integration |
| `anki-bin` | Added | `pkgs.anki` in `packages.nix` |
| `anydesk-bin` | Added | `pkgs.anydesk` in `packages.nix` |
| `aria2` | Added | `pkgs.aria2` in `packages.nix` |
| `arm-none-eabi-gcc` | Added | `pkgs.gcc-arm-embedded`, including newlib |
| `arm-none-eabi-newlib` | Added | `pkgs.gcc-arm-embedded`, including newlib |
| `audacity` | Added | `pkgs.audacity` in `packages.nix` |
| `avr-gcc` | Added | `pkgs.pkgsCross.avr.buildPackages.gcc` and `pkgs.pkgsCross.avr.avrlibc`; use the cross toolchain executable names |
| `avr-libc` | Added | `pkgs.pkgsCross.avr.buildPackages.gcc` and `pkgs.pkgsCross.avr.avrlibc`; use the cross toolchain executable names |
| `avrdude` | Added | `pkgs.avrdude` in `packages.nix` |
| `base` | System | NixOS base system, documentation and package dependencies |
| `base-devel` | Equivalent | Nix stdenv plus GCC, make, binutils, pkg-config, Autotools, flex, bison, patch and gettext; Arch packaging tools do not migrate |
| `bat` | Existing | Shared desktop modules and host hardware configuration |
| `beekeeper-studio-bin` | Pending | Pinned Beekeeper Studio 6.0.5 is marked insecure (bundled Electron 39); no security exception added |
| `blender` | Added | `pkgs.blender` in `packages.nix` |
| `btop` | Existing | Shared desktop modules and host hardware configuration |
| `cachyos-gaming-meta` | Equivalent | Steam, GE-Proton, protontricks, Lutris, Wine, winetricks, umu and Vulkan tools; Nix packages supply runtime libraries |
| `cachyos-keyring` | Arch-only | Replaced by Nix/NixOS package and hardware management |
| `cachyos-mirrorlist` | Arch-only | Replaced by Nix/NixOS package and hardware management |
| `cachyos-settings` | Equivalent | NixOS modules; enabled ananicy-cpp is retained with CachyOS rules, rather than copying Arch system settings wholesale |
| `cachyos-v3-mirrorlist` | Arch-only | Replaced by Nix/NixOS package and hardware management |
| `cachyos-v4-mirrorlist` | Arch-only | Replaced by Nix/NixOS package and hardware management |
| `calf` | Added | `pkgs.calf` in `packages.nix` |
| `ccache` | Added | `pkgs.ccache` in `packages.nix` |
| `ccls` | Added | `pkgs.ccls` in `packages.nix` |
| `chatgpt-desktop` | Existing | Host uses llm-agents ChatGPT and NUR Helium |
| `chromium` | Equivalent | Existing Chromium module uses ungoogled-chromium |
| `chrony` | Service | `services.chrony.enable` (enabled on Arch) |
| `chwd` | Arch-only | Replaced by Nix/NixOS package and hardware management |
| `clamav` | Added | `pkgs.clamav` in `packages.nix` |
| `cuda` | Added | `pkgs.cudaPackages.cudatoolkit`; project builds may still need a Nix development shell |
| `cursor-bin` | Added | `pkgs.code-cursor` in `packages.nix` |
| `dhcpcd` | Equivalent | Existing NetworkManager module supplies DHCP; resolved is enabled to match Arch |
| `difftastic` | Existing | Shared desktop modules and host hardware configuration |
| `direnv` | Existing | Shared desktop modules and host hardware configuration |
| `discord-canary` | Added | `pkgs.discord-canary` in `packages.nix` |
| `discord_arch_electron` | Equivalent | `pkgs.discord`: standard Discord distribution, not the AUR system-Electron build |
| `easyeffects` | Added | `pkgs.easyeffects` in `packages.nix` |
| `efibootmgr` | Added | `pkgs.efibootmgr` in `packages.nix` |
| `efitools` | Added | `pkgs.efitools` in `packages.nix` |
| `egl-wayland` | Existing | NixOS hardware, filesystem and kernel modules |
| `eza` | Existing | Shared desktop modules and host hardware configuration |
| `fcitx5-gtk` | Dependency | Only the GTK integration library is installed on Arch, with no Fcitx engine; no input-method service is inferred |
| `fd` | Existing | Shared desktop modules and host hardware configuration |
| `ffmpeg` | Added | `pkgs.ffmpeg` in `packages.nix` |
| `flite` | Added | `pkgs.flite` in `packages.nix` |
| `fuzzel` | Existing | Shared desktop modules and host hardware configuration |
| `fzf` | Existing | Shared desktop modules and host hardware configuration |
| `ghostty` | Existing | Shared desktop modules and host hardware configuration |
| `git` | Existing | Shared desktop modules and host hardware configuration |
| `git-delta` | Added | `pkgs.delta` in `packages.nix` |
| `github-cli` | Added | `pkgs.gh` in `packages.nix` |
| `go` | Added | `pkgs.go` in `packages.nix` |
| `godot` | Added | `pkgs.godot` in `packages.nix` |
| `google-chrome` | Added | `pkgs.google-chrome` in `packages.nix` |
| `grim` | Added | `pkgs.grim` in `packages.nix` |
| `helium-browser-bin` | Existing | Host uses llm-agents ChatGPT and NUR Helium |
| `hexyl` | Added | `pkgs.hexyl` in `packages.nix` |
| `hyperfine` | Existing | Shared desktop modules and host hardware configuration |
| `hyprland` | Integration | NixOS Hyprland/UWSM session enabled alongside Niri; existing Arch Hyprland dotfiles are not imported |
| `hyprlock` | Existing | Shared desktop modules and host hardware configuration |
| `hyprpaper` | Existing | Shared desktop modules and host hardware configuration |
| `hyprpicker` | Existing | Shared desktop modules and host hardware configuration |
| `imagemagick` | Added | `pkgs.imagemagick` in `packages.nix` |
| `inkscape` | Added | `pkgs.inkscape` in `packages.nix` |
| `iperf3` | Added | `pkgs.iperf3` in `packages.nix` |
| `jdk-openjdk` | Pending | Arch Java 26 has no `jdk26` in the pinned nixpkgs; active Java 21 default and Java 17/25 retained |
| `jdk17-openjdk` | Added | `pkgs.jdk17 (JDK17_HOME)` in `packages.nix` |
| `jdk25-openjdk` | Added | `pkgs.jdk25 (JDK25_HOME)` in `packages.nix` |
| `jujutsu` | Existing | Shared desktop modules and host hardware configuration |
| `kalker-bin` | Added | `pkgs.kalker` in `packages.nix` |
| `kicad` | Added | `pkgs.kicad` in `packages.nix` |
| `kicad-library` | Added | Nixpkgs KiCad includes symbols, footprints and 3D models |
| `kitty` | Added | `pkgs.kitty` in `packages.nix` |
| `kubectl` | Added | `pkgs.kubectl` in `packages.nix` |
| `lib32-nvidia-utils` | Integration | NVIDIA module supplies driver libraries, OpenCL ICD and 32-bit drivers; graphics.enable32Bit enabled |
| `lib32-vkd3d` | Dependency | Wine/Proton and application closures supply matching libraries; Arch shared-library replacements are not globally installed |
| `lib32-zlib-ng-compat` | Dependency | Wine/Proton and application closures supply matching libraries; Arch shared-library replacements are not globally installed |
| `libnewt` | System | NixOS base system, documentation and package dependencies |
| `libva-nvidia-driver` | Added | `hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ]` |
| `libva-utils` | Added | `pkgs.libva-utils` in `packages.nix` |
| `linux-cachyos` | Existing | NixOS hardware, filesystem and kernel modules |
| `linux-cachyos-nvidia-open` | Existing | NixOS hardware, filesystem and kernel modules |
| `linux-firmware` | Existing | NixOS hardware, filesystem and kernel modules |
| `logisim-evolution-bin` | Added | `pkgs.logisim-evolution` in `packages.nix` |
| `lshw` | Added | `pkgs.lshw` in `packages.nix` |
| `lsp-plugins-lv2` | Added | `pkgs.lsp-plugins` in `packages.nix` |
| `lutris` | Added | `pkgs.lutris` in `packages.nix` |
| `man-db` | System | NixOS base system, documentation and package dependencies |
| `man-pages` | Added | `pkgs.man-pages` in `packages.nix` |
| `mergiraf` | Existing | Shared desktop modules and host hardware configuration |
| `minicom` | Added | `pkgs.minicom` in `packages.nix` |
| `mold` | Added | `pkgs.mold` in `packages.nix` |
| `mpv` | Added | `pkgs.mpv` in `packages.nix` |
| `ncdu` | Added | `pkgs.ncdu` in `packages.nix` |
| `neovim` | Existing | Nixvim with Tree-sitter; standalone `pkgs.tree-sitter` also added |
| `nfs-utils` | Added | `pkgs.nfs-utils` in `packages.nix` |
| `niri` | Existing | Shared desktop modules and host hardware configuration |
| `nix` | Existing | Shared desktop modules and host hardware configuration |
| `noto-fonts` | Existing | Font and Stylix modules supply Noto, CJK, emoji, JetBrains Mono Nerd Font and Font Awesome |
| `noto-fonts-cjk` | Existing | Font and Stylix modules supply Noto, CJK, emoji, JetBrains Mono Nerd Font and Font Awesome |
| `noto-fonts-emoji` | Existing | Font and Stylix modules supply Noto, CJK, emoji, JetBrains Mono Nerd Font and Font Awesome |
| `nushell` | Added | `pkgs.nushell` in `packages.nix` |
| `nvidia-settings` | Existing | Shared desktop modules and host hardware configuration |
| `nvidia-utils` | Existing | NixOS hardware, filesystem and kernel modules |
| `obs-studio` | Added | `pkgs.obs-studio` in `packages.nix` |
| `obsidian` | Existing | Shared desktop modules and host hardware configuration |
| `opam` | Added | `pkgs.opam` in `packages.nix` |
| `openblas` | Added | `pkgs.openblas` in `packages.nix` |
| `opencl-nvidia` | Integration | NVIDIA module supplies driver libraries, OpenCL ICD and 32-bit drivers; graphics.enable32Bit enabled |
| `openssh` | Existing | Shared desktop modules and host hardware configuration |
| `opentabletdriver` | Integration | NixOS udev rules and application; daemon autostart disabled to match Arch |
| `osu-lazer-tachyon-bin` | Added | Pinned `osu-lazer` input, Tachyon package (same branch as Arch) |
| `pacman-contrib` | Arch-only | Replaced by Nix/NixOS package and hardware management |
| `partclone` | Added | `pkgs.partclone` in `packages.nix` |
| `paru` | Arch-only | Replaced by Nix/NixOS package and hardware management |
| `perl-file-homedir` | Added | `pkgs.perlPackages.FileHomeDir` in `packages.nix` |
| `perl-yaml-tiny` | Added | `pkgs.perlPackages.YAMLTiny` in `packages.nix` |
| `pipewire` | Existing | Shared desktop modules and host hardware configuration |
| `pipewire-alsa` | Existing | Shared desktop modules and host hardware configuration |
| `pipewire-jack` | Integration | PipeWire JACK enabled; Nixpkgs PipeWire includes libcamera support |
| `pipewire-libcamera` | Integration | PipeWire JACK enabled; Nixpkgs PipeWire includes libcamera support |
| `pipewire-pulse` | Existing | Shared desktop modules and host hardware configuration |
| `postgresql` | Added | PostgreSQL tools and libraries, without enabling a database service or migrating databases |
| `postgresql-libs` | Added | PostgreSQL tools and libraries, without enabling a database service or migrating databases |
| `prismlauncher` | Added | `pkgs.prismlauncher` in `packages.nix` |
| `proton-ge-custom-bin` | Integration | `programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ]` |
| `pwvucontrol` | Added | `pkgs.pwvucontrol` in `packages.nix` |
| `python-capstone` | Added | One Python environment containing both modules |
| `python-pyelftools` | Added | One Python environment containing both modules |
| `rar` | Added | `pkgs.rar` in `packages.nix` |
| `ripgrep` | Existing | Shared desktop modules and host hardware configuration |
| `rsync` | Existing | Shared desktop modules and host hardware configuration |
| `rustdesk-bin` | Added | `pkgs.rustdesk-flutter` in `packages.nix` |
| `rustup` | Added | `pkgs.rustup` in `packages.nix` |
| `sbctl` | Added | `pkgs.sbctl` in `packages.nix` |
| `scrcpy` | Added | `pkgs.scrcpy` in `packages.nix` |
| `screen` | Added | `pkgs.screen` in `packages.nix` |
| `scx-scheds` | Existing | Shared desktop modules and host hardware configuration |
| `slurp` | Added | `pkgs.slurp` in `packages.nix` |
| `smartmontools` | Added | `pkgs.smartmontools` in `packages.nix` |
| `spirv-headers` | Added | `pkgs.spirv-headers` in `packages.nix` |
| `starship` | Existing | Shared desktop modules and host hardware configuration |
| `stow` | Added | `pkgs.stow` in `packages.nix` |
| `sudo` | System | NixOS base system, documentation and package dependencies |
| `t3code-bin` | Added | `pkgs.t3code` in `packages.nix` |
| `texinfo` | System | NixOS base system, documentation and package dependencies |
| `texlive-basic` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-bibtexextra` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-binextra` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-context` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-fontsextra` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-fontsrecommended` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-fontutils` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-formatsextra` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-games` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-humanities` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-latex` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-latexextra` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-latexrecommended` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-luatex` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-mathscience` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-metapost` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-music` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-pictures` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-plaingeneric` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-pstricks` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-publishers` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `texlive-xetex` | Added | `pkgs.texliveFull` covers the installed TeX Live collections |
| `tidal-hifi` | Added | `pkgs.tidal-hifi` in `packages.nix` |
| `tmux` | Existing | Shared desktop modules and host hardware configuration |
| `tokei` | Existing | Shared desktop modules and host hardware configuration |
| `traceroute` | Added | `pkgs.traceroute` in `packages.nix` |
| `tree-sitter-cli` | Existing | Nixvim with Tree-sitter; standalone `pkgs.tree-sitter` also added |
| `ttf-jetbrains-mono-nerd` | Existing | Font and Stylix modules supply Noto, CJK, emoji, JetBrains Mono Nerd Font and Font Awesome |
| `umu-launcher` | Added | `pkgs.umu-launcher` in `packages.nix` |
| `uwsm` | Existing | Shared desktop modules and host hardware configuration |
| `vdpauinfo` | Added | `pkgs.vdpauinfo` in `packages.nix` |
| `ventoy-bin` | Pending | Pinned Ventoy is marked insecure; no security exception added |
| `vesktop` | Added | `pkgs.vesktop` in `packages.nix` |
| `vivaldi` | Added | Vivaldi with `proprietaryCodecs = true` |
| `vivaldi-ffmpeg-codecs` | Added | Vivaldi with `proprietaryCodecs = true` |
| `vkd3d` | Dependency | Wine/Proton and application closures supply matching libraries; Arch shared-library replacements are not globally installed |
| `vlc-plugins-all` | Added | `pkgs.vlc` in `packages.nix` |
| `volk` | Added | `pkgs.volk` in `packages.nix` |
| `vulkan-extra-layers` | Added | `pkgs.vulkan-extension-layer` in `packages.nix` |
| `vulkan-extra-tools` | Added | `pkgs.vulkan-tools-lunarg` in `packages.nix` |
| `vulkan-html-docs` | Pending | No matching documentation package found in the pinned nixpkgs; Vulkan headers and tools are included |
| `vulkan-icd-loader` | Added | `pkgs.vulkan-loader` in `packages.nix` |
| `vulkan-utility-libraries` | Added | `pkgs.vulkan-utility-libraries` in `packages.nix` |
| `vulkan-validation-layers` | Added | `pkgs.vulkan-validation-layers` in `packages.nix` |
| `waybar` | Existing | Shared desktop modules and host hardware configuration |
| `waydroid` | Integration | NixOS Waydroid module, container starts on demand; Android image/data initialization is separate |
| `which` | Existing | Shared desktop modules and host hardware configuration |
| `wireplumber` | Existing | Shared desktop modules and host hardware configuration |
| `wl-clipboard` | Existing | Shared desktop modules and host hardware configuration |
| `woff2-font-awesome` | Existing | Font and Stylix modules supply Noto, CJK, emoji, JetBrains Mono Nerd Font and Font Awesome |
| `xdg-desktop-portal-gnome` | Integration | Niri and Hyprland NixOS modules supply portals |
| `xdg-desktop-portal-gtk` | Integration | Niri and Hyprland NixOS modules supply portals |
| `xdg-desktop-portal-hyprland` | Integration | Niri and Hyprland NixOS modules supply portals |
| `xfsprogs` | Existing | NixOS hardware, filesystem and kernel modules |
| `xournalpp` | Added | `pkgs.xournalpp` in `packages.nix` |
| `xwayland-satellite` | Existing | Shared desktop modules and host hardware configuration |
| `yazi` | Existing | Shared desktop modules and host hardware configuration |
| `zathura` | Added | `pkgs.zathura` in `packages.nix` |
| `zathura-pdf-mupdf` | Added | Nixpkgs Zathura includes the MuPDF plugin |
| `zen-browser-bin` | Added | Pinned Zen beta input (`zen-browser`), official binary repackaged for Nix |
| `zip` | Added | `pkgs.zip` in `packages.nix` |
| `zlib-ng-compat` | Dependency | Wine/Proton and application closures supply matching libraries; Arch shared-library replacements are not globally installed |
| `zsh` | Existing | Shared desktop modules and host hardware configuration |
