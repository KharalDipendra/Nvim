vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.o.number = true
vim.o.mouse = "a"
vim.o.showmode = true

vim.opt.clipboard = "unnamedplus"
vim.o.wrap = true
vim.o.linebreak = true -- wrap at word boundaries, not mid-word
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
vim.opt.fillchars = { eob = " " } -- no ~ on empty lines
vim.o.winborder = "single" -- square borders on every float (hover, signature, etc.)
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.opt.cursorline = false
vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while editing
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Insert indents automatically

-- GUI clients (Neovide etc.); in a terminal the terminal sets font/spacing
vim.o.guifont = "CaskaydiaCove Nerd Font:h15"
vim.o.linespace = 4

require "pkg"
