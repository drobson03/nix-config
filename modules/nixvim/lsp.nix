{pkgs, ...}: {
  programs.nixvim.diagnostic.settings.virtual_text = true;

  # Shared by tsc's root_dir and cmd callbacks, as in nvim-lspconfig/lsp/tsc.lua.
  programs.nixvim.extraConfigLuaPre = ''
    local tsc_bin_cache = {}

    local function tsc_supports_lsp(bin)
      if vim.fn.executable(bin) ~= 1 then
        return false
      end

      local out = vim.system({ bin, '--version' }, { text = true }):wait()
      local version = vim.version.parse(out.stdout or "")

      return out.code == 0 and version ~= nil and version.major >= 7
    end
  '';

  programs.nixvim.lsp = {
    servers = {
      biome.enable = true;
      gopls.enable = true;
      intelephense.enable = true;
      lua_ls = {
        enable = true;
        config.telemetry.enable = false;
      };
      nixd.enable = true;
      vtsls = {
        enable = false;
        config.settings = {
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
      tsc = {
        enable = true;
        package = pkgs.typescript;
        config = {
          cmd.__raw = ''
            function(dispatchers, config)
              local cmd = tsc_bin_cache[(config or {}).root_dir] or 'tsc'
              return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
            end
          '';
          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];
          root_dir.__raw = ''
            function(bufnr, on_dir)
              -- Use the workspace lockfile root so monorepos share one server.
              local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
              root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
                or vim.list_extend(root_markers, { '.git' })

              local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
              local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
              local project_root = vim.fs.root(bufnr, root_markers)
              if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
                return
              end
              if deno_root and (not project_root or #deno_root >= #project_root) then
                return
              end

              local root = project_root or vim.fn.getcwd()
              if tsc_bin_cache[root] then
                return on_dir(root)
              end

              local bins = {}
              for _, bin in ipairs({ 'tsc', 'tsgo' }) do
                bins[#bins + 1] = vim.fs.joinpath(root, 'node_modules/.bin', bin)
                bins[#bins + 1] = bin
              end

              for _, bin in ipairs(bins) do
                if tsc_supports_lsp(bin) then
                  tsc_bin_cache[root] = bin
                  return on_dir(root)
                end
              end

              vim.notify('tsc: no binary supporting `--lsp` found (requires TypeScript 7.0+)', vim.log.levels.WARN)
            end
          '';
          settings."js/ts" = {
            updateImportsOnFileMove.enabled = "always";
            suggest.completeFunctionCalls = true;
            inlayHints = {
              enumMemberValues.enabled = true;
              functionLikeReturnTypes.enabled = true;
              parameterNames = {
                enabled = "literals";
                suppressWhenArgumentMatchesName = true;
              };
              parameterTypes.enabled = true;
              propertyDeclarationTypes.enabled = true;
              variableTypes.enabled = false;
            };
            referencesCodeLens = {
              enabled = true;
              showOnAllFunctions = true;
            };
            implementationsCodeLens = {
              enabled = true;
              showOnInterfaceMethods = true;
              showOnAllClassMethods = true;
            };
          };
        };
      };
      tailwindcss.enable = true;
      oxlint.enable = true;
      oxfmt.enable = true;
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
