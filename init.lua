vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = true

vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "osc52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy "+",
    ["*"] = require("vim.ui.clipboard.osc52").copy "*",
  },
  paste = {
    ["+"] = function() end,
    ["*"] = function() end,
  },
}
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.laststatus = 3 -- one full-width statusline instead of a cramped one per split
-- OLED burn-in: drift the statusline (and bufferline's tabline) 0..6 columns right and back, one step a minute
vim.g.sl_shift = 0
vim.o.statusline = "%{repeat(' ', g:sl_shift)}" .. vim.o.statusline .. "%{repeat(' ', 6 - g:sl_shift)}"
local sl_tick = 0
vim.uv.new_timer():start(60000, 60000, vim.schedule_wrap(function()
  sl_tick = sl_tick + 1
  vim.g.sl_shift = math.abs(sl_tick % 12 - 6)
  vim.cmd.redrawstatus()
  vim.cmd.redrawtabline()
end))
vim.opt.cursorline = false
vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while editing
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Insert indents automatically

vim.g.temp_plugins = true -- learning plugins in lua/temp_plugins; comment out when you no longer need them
require "pkg"

-- Kitty: fullscreen, no tab bar, small side padding, opaque, bg = nvim's while nvim is open (needs allow_remote_control + listen_on in kitty.conf)
-- Kitty can only toggle fullscreen, not report it, so starting nvim from an already-fullscreen kitty
-- un-fullscreens it. vim.env.NVIM skips nvims started inside nvim's :terminal.
-- Runs on UIEnter: resizing kitty before the UI is attached leaves nvim drawn at the old, smaller size.
if vim.env.KITTY_LISTEN_ON and not vim.env.NVIM then
  local fullscreen = { "kitten", "@", "resize-os-window", "--self", "--action=toggle-fullscreen" }
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
      vim.system(fullscreen)
      local bg = string.format("background=#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg or 0x0d0d0d)
      vim.system { "kitten", "@", "load-config", "--ignore-overrides", "--override", "tab_bar_min_tabs=100", "--override", "window_padding_width=0 8", "--override", "background_opacity=1", "--override", bg }
    end,
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      vim.system(fullscreen):wait()
      vim.system({ "kitten", "@", "load-config", "--ignore-overrides" }):wait()
    end,
  })
end
