return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup {
      popup_border_style = "single",
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
        hijack_netrw_behavior = "open_current", -- `nvim dir` shows the tree in the window itself, no empty extra buffer
        filtered_items = {
          hide_dotfiles = false, -- Explicitly prevents hiding dotfiles
        },
      },
    }
  end,
}
