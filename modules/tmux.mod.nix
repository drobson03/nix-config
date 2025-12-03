{
  flake.homeModules.tmux = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      prefix = "C-a";

      sensibleOnTop = false;
      escapeTime = 0;
      baseIndex = 1;

      terminal = "tmux-256color";
      shell = "${pkgs.zsh}/bin/zsh";

      extraConfig =
        /*
        tmux
        */
        ''
          set -g renumber-windows on
          set-option -g focus-events on

          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'

          bind -r ^ last-window
          bind -r k select-pane -U
          bind -r j select-pane -D
          bind -r h select-pane -L
          bind -r l select-pane -R

          bind -r D neww -c "#{pane_current_path}"
        '';
    };

    programs.ghostty.settings.command = "tmux new -As0";
  };
}
