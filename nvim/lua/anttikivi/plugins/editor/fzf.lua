-- This module is based on LazyVim/LazyVim, licensed under Apache-2.0.

---@class FzfLuaOpts: anttikivi.util.pick.Opts
---@field cmd string?

---@type AKPicker
local picker = {
  name = "fzf",
  commands = {
    files = "files",
  },

  ---@param command string
  ---@param opts? FzfLuaOpts
  open = function(command, opts)
    opts = opts or {}
    if opts.cmd == nil and command == "git_files" and opts.show_untracked then
      opts.cmd = "git ls-files --exclude-standard --cached --others"
    end
    return require("fzf-lua")[command](opts)
  end,
}
if not AK.pick.register(picker) then
  return {}
end

return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = function()
      local config = require("fzf-lua.config")
      local actions = require("fzf-lua.actions")

      -- Toggle root dir / cwd
      config.defaults.actions.files["ctrl-r"] = function(_, ctx)
        local o = vim.deepcopy(ctx.__call_opts)
        o.root = o.root == false
        o.cwd = nil
        o.buf = ctx.__CTX.bufnr
        AK.pick.open(ctx.__INFO.cmd, o)
      end
      config.defaults.actions.files["alt-c"] =
        config.defaults.actions.files["ctrl-r"]
      config.set_action_helpstr(
        config.defaults.actions.files["ctrl-r"],
        "toggle-root-dir"
      )

      local img_previewer ---@type string[]?
      for _, v in ipairs({
        { cmd = "ueberzug", args = {} },
        { cmd = "chafa", args = { "{file}", "--format=symbols" } },
        { cmd = "viu", args = { "-b" } },
      }) do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      return {
        "default-title",
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        defaults = {
          -- formatter = "path.filename_first",
          formatter = "path.dirname_first",
        },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
          },
        },
        -- Custom AK option to configure vim.ui.select
        ui_select = function(fzf_opts, items)
          return vim.tbl_deep_extend("force", fzf_opts, {
            prompt = " ",
            winopts = {
              title = " "
                .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", ""))
                .. " ",
              title_pos = "center",
            },
          }, fzf_opts.kind == "codeaction" and {
            winopts = {
              layout = "vertical",
              -- Height is number of items minus 15 lines for the preview, with
              -- a max of 80% screen height.
              height = math.floor(
                math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5
              ) + 16,
              width = 0.5,
              preview = not vim.tbl_isempty(
                    AK.lsp.get_clients({ bufnr = 0, name = "vtsls" })
                  )
                  and {
                    layout = "vertical",
                    vertical = "down:15,border-top",
                    hidden = "hidden",
                  }
                or {
                  layout = "vertical",
                  vertical = "down:15,border-top",
                },
            },
          } or {
            winopts = {
              width = 0.5,
              -- Height is number of items, with a max of 80% screen height.
              height = math.floor(
                math.min(vim.o.lines * 0.8, #items + 2) + 0.5
              ),
            },
          })
        end,
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
          },
        },
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
          },
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native"
              or nil,
          },
        },
      }
    end,
    config = function(_, opts)
      if opts[1] == "default-title" then
        -- Use the same prompt for all pickers for profile `default-title` and
        -- profiles that use `default-title` as base profile.
        local function fix(t)
          t.prompt = t.prompt ~= nil and " " or nil
          for _, v in pairs(t) do
            if type(v) == "table" then
              fix(v)
            end
          end
          return t
        end
        opts = vim.tbl_deep_extend(
          "force",
          fix(require("fzf-lua.profiles.default-title")),
          opts
        )
        opts[1] = nil
      end
      require("fzf-lua").setup(opts)
    end,
    init = function()
      AK.on_very_lazy(function()
        vim.ui.select = function(...)
          require("lazy").load({ plugins = { "fzf-lua" } })
          local opts = AK.opts("fzf-lua") or {}
          require("fzf-lua").register_ui_select(opts.ui_select or nil)
          return vim.ui.select(...)
        end
      end)
    end,
    keys = {
      { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
      { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
      { "<leader>/", AK.pick("live_grep"), desc = "Grep (root dir)" },
      {
        "<leader>:",
        "<cmd>FzfLua command_history<cr>",
        desc = "Command History",
      },
      {
        "<leader><space>",
        AK.pick("files"),
        desc = "Find files (root dir)",
      },
      -- Find
      { "<leader>fc", AK.pick.config_files(), desc = "Find config file" },
      { "<leader>ff", AK.pick("files"), desc = "Find files (root dir)" },
      {
        "<leader>fF",
        AK.pick("files", { root = false }),
        desc = "Find files (cwd)",
      },
      {
        "<leader>fg",
        "<cmd>FzfLua git_files<cr>",
        desc = "Find files (git-files)",
      },
      -- Search
      { "<leader>sg", AK.pick("live_grep"), desc = "Grep (root dir)" },
      {
        "<leader>sG",
        AK.pick("live_grep", { root = false }),
        desc = "Grep (cwd)",
      },
      { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help pages" },
      -- TODO: LSP searches at least.
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local Keys = require("anttikivi.plugins.lsp.keymaps").get()
      -- stylua: ignore
      vim.list_extend(Keys, {
        { "gd", "<cmd>FzfLua lsp_definitions     jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto definition", has = "definition" },
        { "gr", "<cmd>FzfLua lsp_references      jump_to_single_result=true ignore_current_line=true<cr>", desc = "References", nowait = true },
        { "gI", "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto implementation" },
        { "gy", "<cmd>FzfLua lsp_typedefs        jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
      })
    end,
  },
}