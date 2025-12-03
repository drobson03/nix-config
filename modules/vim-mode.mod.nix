{
  flake.homeModules.vim-mode = {
    programs.zsh.defaultKeymap = "viins";
    programs.tmux.keyMode = "vi";
  };
}
