local enable_formatting = true

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        config = function(_, opts)
          require("mason").setup(opts)

          local tools = {
            "ansible-lint",
            "black",
            "gofumpt",
            "goimports",
            "gomodifytags",
            "impl",
            "markdownlint",
            "marksman",
            "prettier",
            "shfmt",
            "stylua",
          }

          local mason_registry = require "mason-registry"

          local function ensure_installed()
            for _, tool in ipairs(tools) do
              local pack = mason_registry.get_package(tool)
              if not pack:is_installed() then
                pack:install()
              end
            end
          end

          if mason_registry.refresh() then
            mason_registry.refresh(ensure_installed)
          else
            ensure_installed()
          end
        end,
        build = ":MasonUpdate",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "[M]ason" } },
      },
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/neodev.nvim",
        opts = {},
      },
    },
    opts = {
      servers = {
        ansiblels = {},
        astro = {},
        bashls = {},
        clangd = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern(
              "compile_commands.json",
              "compile_flags.txt"
            )(fname) or require("lspconfig.util").find_git_ancestor(
              fname
            )
          end,
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        cssls = {},
        eslint = {
          settings = {
            workingDirectory = { mode = "auto" },
          },
        },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = {
                "-.git",
                "-node_modules",
              },
              semanticTokens = true,
            },
          },
        },
        html = {},
        jsonls = {
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        marksman = {},
        phpactor = {},
        pyright = {},
        ruff_lsp = {},
        stylelint_lsp = {},
        tailwindcss = {},
        terraformls = {},
        tsserver = {},
        vimls = {},
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
            },
          },
        },
      },
    },
    config = function(_, opts)
      local mason = require "mason"
      local mason_lspconfig = require "mason-lspconfig"

      mason.setup()
      mason_lspconfig.setup()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(opts.servers),
      }

      ---@param client lsp.Client
      local on_attach = function(client, bufnr)
        if client.name == "copilot" then
          local copilot_cmp = require "copilot_cmp"
          copilot_cmp._on_insert_enter {}
        end
        if client.name == "gopls" then
          if not client.server_capabilities.semanticTokensProvider then
            local semantic =
              client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end
        end

        if client.name == "ruff_lsp" then
          client.server_capabilities.hoverProvider = false
        end

        if vim.fn.has "nvim-0.10" == 0 then
          if client.name == "yamlls" then
            client.server_capabilities.documentFormattingProvider = true
          end
        end

        local nmap = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("<leader>cr", vim.lsp.buf.rename, "[R]ename")
        nmap("<leader>ca", vim.lsp.buf.code_action, "Code [a]ction")

        nmap("gD", vim.lsp.buf.declaration, "Goto [d]eclaration")

        nmap(
          "gd",
          require("telescope.builtin").lsp_definitions,
          "Goto [d]efinition"
        )
        nmap(
          "gr",
          require("telescope.builtin").lsp_references,
          "Goto [r]eferences"
        )
        nmap(
          "gI",
          require("telescope.builtin").lsp_implementations,
          "Goto [i]mplementation"
        )
        nmap(
          "gT",
          require("telescope.builtin").lsp_type_definitions,
          "Goto [t]ype definition"
        )
        -- TODO: Find a maching keymap for this.
        -- nmap(
        --   "<leader>ds",
        --   require("telescope.builtin").lsp_document_symbols,
        --   "[D]ocument [S]ymbols"
        -- )
        -- TODO: Find a maching keymap for this.
        -- nmap(
        --   "<leader>ws",
        --   require("telescope.builtin").lsp_dynamic_workspace_symbols,
        --   "[W]orkspace [S]ymbols"
        -- )

        nmap("K", vim.lsp.buf.hover, "Hover documentation")
        -- TODO: Enable this later when it doesn't conflict with Harpoon.
        -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature documentation")

        -- TODO: Find a maching keymap for this.
        -- nmap(
        --   "<leader>wa",
        --   vim.lsp.buf.add_workspace_folder,
        --   "[W]orkspace [A]dd Folder"
        -- )
        -- TODO: Find a maching keymap for this.
        -- nmap(
        --   "<leader>wr",
        --   vim.lsp.buf.remove_workspace_folder,
        --   "[W]orkspace [R]emove Folder"
        -- )
        -- TODO: Find a maching keymap for this.
        -- nmap("<leader>wl", function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, "[W]orkspace [L]ist Folders")

        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
      end

      mason_lspconfig.setup_handlers {
        function(server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = opts.servers[server_name],
            filetypes = (opts.servers[server_name] or {}).filetypes,
          }
        end,
      }

      vim.api.nvim_create_user_command("AnttiKiviFormatToggle", function()
        enable_formatting = not enable_formatting
        vim.notify(
          "Setting autoformatting to " .. tostring(enable_formatting),
          vim.log.levels.INFO
        )
      end, {})

      local _augroups = {}
      local get_augroup = function(client)
        if not _augroups[client.id] then
          local group_name = "anttikivi-lsp-format-" .. client.name
          local id = vim.api.nvim_create_augroup(group_name, { clear = true })
          _augroups[client.id] = id
        end

        return _augroups[client.id]
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup(
          "anttikivi-lsp-attach-format",
          { clear = true }
        ),
        callback = function(args)
          local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)
          local bufnr = args.buf

          if not client.server_capabilities.documentFormattingProvider then
            return
          end

          if client.name == "tsserver" then
            return
          end

          vim.api.nvim_create_autocmd("BufWritePre", {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function()
              if not enable_formatting then
                return
              end

              vim.lsp.buf.format {
                async = false,
                filter = function(c)
                  return c.id == client.id
                end,
              }
            end,
          })
        end,
      })
    end,
  },
}
