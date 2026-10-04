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
local spec = {
  { import = "plugins.keybinds" },
  { import = "plugins.syntax" },
  { import = "plugins.lsp" },
  { import = "plugins.theme" },
  { import = "plugins.dashboard" },
  { import = "plugins.neotree" },
  { import = "plugins.bufferline" },
  { import = "plugins.telescope" },
}
if vim.g.temp_plugins then
  table.insert(spec, { import = "temp_plugins" })
end
require("lazy").setup(spec, {
  lockfile = vim.fn.stdpath "cache" .. "/lazy-lock.json",
})
