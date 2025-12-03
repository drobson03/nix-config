{
  programs.nixvim.diagnostic.settings.virtual_text = true;

  programs.nixvim.lsp = {
    servers = {
      biome.enable = true;
      lua_ls = {
        enable = true;
        settings.telemetry.enable = false;
      };
      nixd.enable = true;
      vtsls = {
        enable = true;
        settings = {
          complete_function_calls = true;
          vtsls = {
            enableMoveToFileCodeAction = true;
            autoUseWorkspaceTsdk = true;
            experimental = {
              maxInlayHintLength = 30;
              completion.enableServerSideFuzzyMatch = true;
            };
          };
          typescript = {
            updateImportsOnFileMove.enabled = "always";
            suggest = {
              completeFunctionCalls = true;
            };
            inlayHints = {
              enumMemberValues.enabled = true;
              functionLikeReturnTypes.enabled = true;
              parameterNames.enabled = "literals";
              parameterTypes.enabled = true;
              propertyDeclarationTypes.enabled = true;
              variableTypes.enabled = false;
            };
          };
        };
      };
      tailwindcss.enable = true;
    };

    keymaps = [
      {
        key = "gd";
        lspBufAction = "definition";
      }
      {
        key = "K";
        lspBufAction = "hover";
      }
      {
        key = "<leader>vws";
        lspBufAction = "workspace_symbol";
      }
      {
        key = "[d";
        action.__raw = ''
          function()
            vim.diagnostic.jump({
              count = 1,
              float = true,
            })
          end
        '';
      }
      {
        key = "]d";
        action.__raw = ''
          function()
            vim.diagnostic.jump({
              count = -1,
              float = true,
            })
          end
        '';
      }
      {
        key = "<leader>vca";
        lspBufAction = "code_action";
      }
      {
        key = "<leader>vrr";
        lspBufAction = "references";
      }
      {
        key = "<leader>vrn";
        lspBufAction = "rename";
      }
      {
        key = "<C-h>";
        lspBufAction = "signature_help";
      }
    ];
  };
}
