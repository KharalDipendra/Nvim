return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false, -- needed so `nvim .` and `:e .` open the tree; neo-tree lazy-loads itself
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup {
      close_if_last_window = true, -- :q on the last file quits nvim instead of leaving the tree open
      popup_border_style = "rounded",
      window = {
        position = "left",
        -- position = "float",
        width = 35,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
      filesystem = {
        use_libuv_file_watcher = true,
        follow_current_file = {
          enabled = true, -- This finds the file in the tree
          leave_dirs_open = true, -- Keeps the path expanded
        },
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          hide_dotfiles = false, -- Explicitly prevents hiding dotfiles
        },
      },
    }
  end,
}
