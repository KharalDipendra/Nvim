-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:" .. out)
  end
end
---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)
require("lazy").setup({
  { import = "plugins.whichkey" },
  { import = "plugins.syntax" },
  { import = "plugins.theme" },
  { import = "plugins.dashboard" },
  { import = "plugins.neotree" },
  { import = "plugins.telescope" },
  { import = "plugins.barbar" },
  { import = "plugins.vimbegood" },
  { import = "plugins.statusline" },
  { import = "plugins.hardtime" },
  { import = "plugins.trouble" },
})  -- lazy-lock.json sits next to init.lua and is committed, so every machine gets the same plugin versions
