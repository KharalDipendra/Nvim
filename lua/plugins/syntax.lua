vim.opt.updatetime = 100
vim.diagnostic.config {
  virtual_text = {
    prefix = "", -- Could be '', '●', '◆'
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "single",
    source = "always",
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
}
return {
  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown.nvim",
    ft = "markdown",
    config = function()
      require("render-markdown").setup {
        headings = { "Headline1", "Headline2", "Headline3" },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- Must use the 'main' branch for 0.12+
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install {
        "bash", "c", "cpp", "go", "javascript", "json", "lua", "markdown",
        "markdown_inline", "python", "rust", "toml", "typescript", "tsx", "yaml",
      }
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  { -- Language servers: :Mason to add more, installed ones auto-enable
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "ts_ls", "clangd", "gopls", "bashls", "jsonls" },
    },
  },

  { "folke/lazydev.nvim", ft = "lua", opts = {} },

  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { preset = "default" }, -- Vim's own completion keys: Ctrl-n/Ctrl-p pick, Ctrl-y accept, Ctrl-e close
      -- : command line suggests as you type (Tab / Ctrl-n / Ctrl-p to pick); / search stays quiet
      cmdline = {
        keymap = { preset = "cmdline" },
        completion = {
          menu = {
            auto_show = function()
              return vim.fn.getcmdtype() == ":"
            end,
          },
        },
      },
      -- VSCode look: codicon kind icons, label, kind name on the right, borderless panel
      appearance = {
        nerd_font_variant = "mono",
        kind_icons = {
          Text = "\u{eb8d}", Method = "\u{ea8c}", Function = "\u{ea8c}", Constructor = "\u{ea8c}",
          Field = "\u{eb5f}", Variable = "\u{ea88}", Property = "\u{eb65}", Class = "\u{eb5b}",
          Interface = "\u{eb61}", Struct = "\u{ea91}", Module = "\u{ea8b}", Unit = "\u{ea96}",
          Value = "\u{ea90}", Enum = "\u{ea95}", EnumMember = "\u{eb5e}", Keyword = "\u{eb62}",
          Constant = "\u{eb5d}", Snippet = "\u{eb66}", Color = "\u{eb5c}", File = "\u{eb60}",
          Reference = "\u{eb36}", Folder = "\u{ea83}", Event = "\u{ea86}", Operator = "\u{eb64}",
          TypeParameter = "\u{ea92}",
        },
      },
      completion = {
        menu = {
          border = "none",
          max_height = 8,
          draw = {
            padding = 1,
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
          },
        },
        documentation = {
          auto_show = false, -- Ctrl-Space shows it for the selected item
          window = { border = "none", max_width = 50, max_height = 8 }, -- compact VSCode-sized docs box
        },
        ghost_text = { enabled = false },
      },
      signature = { enabled = true, window = { border = "none" } },
      sources = {
        -- language server only (+ file paths, + Neovim's Lua API in config files); no snippet library, no buffer words
        default = { "lazydev", "lsp", "path" },
        min_keyword_length = 2, -- menu waits for 2 typed characters
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },

  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
        go = { "gofmt" },
        cpp = { "clang-format" },
        c = { "clang-format" },
      },
    },
  },

  "NMAC427/guess-indent.nvim",

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}
