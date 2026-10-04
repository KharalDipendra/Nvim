return {
  "romgrk/barbar.nvim",
  dependencies = { "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.g.barbar_auto_setup = false
    -- :q on a file also closes its tab (otherwise the buffer stays listed and its tab lingers)
    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function(ev)
        if vim.bo[ev.buf].buftype ~= "" then
          return
        end
        vim.schedule(function() -- after the window closed; skipped if :q failed or file is still shown
          if vim.api.nvim_buf_is_valid(ev.buf) and vim.fn.bufwinid(ev.buf) == -1 then
            vim.cmd.bdelete(ev.buf)
          end
        end)
      end,
    })
    -- Vim's empty [No Name] placeholder (left after closing the last file) gets no tab;
    -- it gets one back as soon as you type in it or give it a name
    local function is_placeholder(b)
      return vim.api.nvim_buf_get_name(b) == "" and vim.bo[b].buftype == "" and not vim.bo[b].modified
    end
    vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "BufWinEnter" }, {
      callback = function(ev)
        if is_placeholder(ev.buf) then
          vim.bo[ev.buf].buflisted = false
          vim.b[ev.buf].placeholder = true
        end
      end,
    })
    vim.api.nvim_create_autocmd("BufHidden", { -- out of view and still empty: drop it
      callback = function(ev)
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ev.buf) and is_placeholder(ev.buf) and vim.fn.bufwinid(ev.buf) == -1 then
            pcall(vim.api.nvim_buf_delete, ev.buf, {})
          end
        end)
      end,
    })
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufFilePost" }, {
      callback = function(ev)
        if vim.b[ev.buf].placeholder and not is_placeholder(ev.buf) then
          vim.bo[ev.buf].buflisted = true
          vim.b[ev.buf].placeholder = nil
        end
      end,
    })
  end,
  lazy = false,
  opts = {
    exclude_ft = { "alpha" }, -- no tab for the dashboard
    -- same glyph as the tree/editor split (│ is centered; the default ▎ hugs the cell's left edge),
    -- so the separator runs as one straight line from the tab bar down
    icons = {
      separator = { left = "│", right = "" },
      inactive = { separator = { left = "│", right = "" } },
    },
  },
  config = function(_, opts)
    require("barbar").setup(opts)
    -- ...and the same color as the split, under any theme
    local function match_split()
      local fg = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false }).fg
      for _, state in ipairs { "Current", "Visible", "Inactive", "Alternate" } do
        local g = "Buffer" .. state .. "Sign"
        vim.api.nvim_set_hl(0, g, { fg = fg, bg = vim.api.nvim_get_hl(0, { name = g, link = false }).bg })
      end
    end
    match_split()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = match_split })

    -- Tabs start after the file tree. Measured from the tree's real window on every layout change
    -- (barbar's own sidebar tracking loses it when the tree briefly swaps buffers, e.g. `:e` typed in it)
    local function sync_offset()
      local width = 0
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local w = vim.api.nvim_win_get_width(win)
        if
          vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree"
          and vim.api.nvim_win_get_config(win).relative == "" -- not a floating tree
          and vim.api.nvim_win_get_position(win)[2] == 0 -- docked on the left
          and w < vim.o.columns -- a sidebar, not the full-screen tree from `nvim .`
        then
          width = w
        end
      end
      require("barbar.api").set_offset(width)
    end
    vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "WinEnter", "WinClosed", "WinResized", "VimResized" }, {
      callback = function()
        vim.schedule(sync_offset)
      end,
    })
  end,
}
