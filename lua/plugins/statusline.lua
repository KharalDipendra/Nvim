return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "auto", -- follows whatever colorscheme is active
      globalstatus = true, -- one bar across the whole screen, none per split/tree
      disabled_filetypes = { statusline = { "alpha" } },
    },
    sections = {
      lualine_a = { { "mode", padding = { left = 2, right = 1 } } },
      lualine_c = { { "filename", path = 1 } },
      lualine_z = { { "location", padding = { left = 1, right = 2 } } },
    },
  },
}
