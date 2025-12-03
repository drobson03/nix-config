{pkgs, ...}: {
  home.packages = [
    pkgs.alejandra
    pkgs.stylua
  ];

  programs.nixvim.keymaps = [
    {
      action.__raw = ''
        function()
          require("conform").format()
        end
      '';
      key = "<leader>f";
      mode = ["n"];
    }
  ];

  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    settings = {
      default_format_opts.lsp_format = "fallback";
      format_on_save.timeout_ms = 1000;
      formatters_by_ft = let
        javascriptFormatters = [
          "biome-check"
          "prettierd"
          "prettier"
        ];
      in {
        astro = javascriptFormatters;
        css = javascriptFormatters;
        javascript = javascriptFormatters;
        javscriptreact = javascriptFormatters;
        json = javascriptFormatters;
        jsonc = javascriptFormatters;
        lua = ["stylua"];
        markdown = javascriptFormatters;
        mdx = javascriptFormatters;
        nix = ["alejandra"];
        typescript = javascriptFormatters;
        typescriptreact = javascriptFormatters;
      };
    };
  };
}
