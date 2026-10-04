-- Breaks bad habits while learning: blocks arrow keys and repeated h/j/k/l,
-- and suggests the better motion. :Hardtime toggle turns it off for a while.
return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    disable_mouse = false, -- keep clicking in the file tree and resizing splits
  },
}
