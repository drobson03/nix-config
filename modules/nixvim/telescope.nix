{pkgs, ...}: {
  # structural grep
  home.packages = [
    pkgs.ast-grep
  ];

  programs.nixvim.extraPlugins = [
    pkgs.vimPlugins.telescope-sg
  ];

  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions.undo.enable = true;
    extensions.frecency.enable = true;
    settings = {
      extensions = {
        ast_grep = {
          command = [
            "ast-grep"
            "--json=stream"
          ];
          lang = null;
        };
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      action = "<cmd>Telescope find_files<CR>";
      key = "<leader>pf";
      mode = ["n"];
    }
    {
      action = "<cmd>Telescope frecency<CR>";
      key = "<leader>ff";
      mode = ["n"];
    }
    {
      action = "<cmd>Telescope git_files<CR>";
      key = "<C-p>";
      mode = ["n"];
    }
    {
      action.__raw = ''
        function()
          require("telescope.builtin").live_grep({
            additional_args = { "--hidden" },
          })
        end
      '';
      key = "<leader>ps";
      mode = ["n"];
    }
    {
      action = "<cmd>Telescope help_tags<CR>";
      key = "<leader>vh";
      mode = ["n"];
    }
    {
      action = "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<CR>";
      key = "<leader>vd";
      mode = ["n"];
    }
  ];
}
