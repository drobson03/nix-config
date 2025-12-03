{
  programs.nixvim.plugins = {
    blink-cmp = {
      enable = true;
      settings.keymap = {
        "<C-p>" = ["select_prev"];
        "<C-n>" = ["select_next"];
        "<C-y>" = ["select_and_accept"];
        "<C-Space>" = ["show"];
        "<Tab>" = null;
        "<S-Tab>" = null;
      };
    };
    dressing.enable = true;
    fidget.enable = true;
    indent-blankline.enable = true;
    lspconfig.enable = true;
    lualine = {
      enable = true;
      settings = {
        options = {
          section_separators = "";
          component_separators = "|";
        };
        sections = {
          lualine_a = ["mode"];
          lualine_b = ["branch"];
          lualine_c = [
            "filename"
            "filetype"
            {
              __unkeyed-1 = "diagnostics";
              symbols = {
                error = " ";
                warn = " ";
                info = " ";
                hint = " ";
              };
            }
          ];
          lualine_x = ["diff"];
          lualine_y = ["encoding" "fileformat"];
          lualine_z = ["location"];
        };
      };
    };
    mini-ai.enable = true;
    nvim-autopairs = {
      enable = true;
      settings.disable_filetype = [
        "TelescopePrompt"
      ];
    };
    render-markdown = {
      enable = true;
      settings = {
        file_types = ["markdown" "mdx"];
      };
    };
    sleuth.enable = true;
    trouble.enable = true;
    todo-comments.enable = true;

    treesitter.enable = true;
    treesitter.settings.highlight.enable = true;

    web-devicons.enable = true;
  };
}
