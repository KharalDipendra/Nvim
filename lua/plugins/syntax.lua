vim.opt.updatetime = 100
vim.diagnostic.config {
  virtual_text = {
    prefix = "", -- Could be '', '●', '◆'
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
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
-- Floating error message
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})
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
    "infraflakes/kiru-tree-sitter",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- Must use the 'main' branch for 0.12+
    build = ":TSUpdate",
    config = function()
      local ts = require "nvim-treesitter"
      ts.setup {
        indent = { enable = true }, -- Indentation
      }
    end,
  },

  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = { "rafamadriz/friendly-snippets" }, -- VS Code-style snippets for most languages
    opts = {
      keymap = { preset = "default", ["<C-k>"] = false }, -- <C-n>/<C-p> select, <C-y> accept, <C-e> cancel; <C-k> left to Vim (digraphs)
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 }, -- docs popup beside the menu
        ghost_text = { enabled = true }, -- preview the selected item inline
        menu = { draw = { columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } } } },
      },
      signature = { enabled = true }, -- function parameters while typing inside ( )
      sources = {
        default = { "lsp", "path", "buffer" },
        providers = {
          buffer = {
            min_keyword_length = 3,
          },
        },
      },
      snippets = { preset = "default" },
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
        rs = { "cargo fmt" },
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
