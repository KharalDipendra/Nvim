-- Active theme. Both are installed: set this to "tokyonight-storm" to switch back,
-- or try one live with :colorscheme gruvbox / :colorscheme tokyonight-storm
local theme = "gruvbox"

-- Paint the terminal's padding/leftover rows with the theme bg so nvim fills the window edge to edge
local function sync_term_bg()
  local bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
  if bg then
    vim.api.nvim_ui_send(("\027]11;#%06x\007"):format(bg))
  end
end
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, { callback = sync_term_bg })
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.api.nvim_ui_send "\027]111\007" -- restore terminal's own bg
  end,
})

-- In kitty: fullscreen and no padding while nvim runs, all undone on exit
if vim.env.KITTY_LISTEN_ON and not vim.env.NVIM then
  local function kitty(args)
    return vim.system(vim.list_extend({ "kitty", "@" }, args))
  end
  -- ponytail: kitty can't report fullscreen state, so starting nvim from an
  -- already-fullscreen kitty (or a 2nd nvim in the same window) flips it back out
  vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
      kitty { "action", "toggle_fullscreen" }
      kitty { "set-spacing", "padding=0" }
    end,
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      kitty({ "action", "toggle_fullscreen" }):wait()
      kitty({ "set-spacing", "padding=default" }):wait()
    end,
  })
end

return {
  -- {
  --   "terminal-theme",
  --   dir = vim.fn.stdpath "config",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- Disable TrueColor so Neovim uses your terminal's ANSI palette~
  --     vim.opt.termguicolors = false
  --
  --     local transparent_groups = {
  --       "Normal",
  --       "NormalNC",
  --       "NormalFloat",
  --       "FloatBorder",
  --       "TelescopeNormal",
  --       "TelescopeBorder",
  --       "VertSplit",
  --       "WinSeparator",
  --       "StatusLine",
  --       "StatusLineNC",
  --       "NeoTreeNormal",
  --       "NeoTreeNormalNC",
  --       "NeoTreeEndOfBuffer",
  --       "LineNr",
  --       "SignColumn",
  --     }
  --
  --     -- Keep backgrounds transparent across scheme reloads
  --     vim.api.nvim_create_autocmd("ColorScheme", {
  --       pattern = "*",
  --       callback = function()
  --         for _, group in ipairs(transparent_groups) do
  --           vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
  --         end
  --       end,
  --     })
  --
  --     vim.cmd.colorscheme "default"
  --   end,
  -- },

  -- {
  --   "arcticicestudio/nord-vim",
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     vim.cmd.colorscheme "nord"
  --   end,
  -- },

  { "folke/tokyonight.nvim", lazy = true },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Give gruvbox the same layout tokyonight has: current tab blends into the editor,
      -- tab strip + file tree a shade darker, gutter flush with the code (no light-gray strips)
      local bg, dark, fg, gray = "#282828", "#1d2021", "#ebdbb2", "#928374"
      local overrides = {
        SignColumn = { bg = bg },
        TabLineSel = { fg = fg, bg = bg },
        TabLine = { fg = gray, bg = dark },
        TabLineFill = { bg = dark },
        BufferVisible = { fg = fg, bg = dark },
        BufferOffset = { fg = gray, bg = dark },
        NeoTreeNormal = { bg = dark },
        NeoTreeNormalNC = { bg = dark },
        NeoTreeEndOfBuffer = { fg = dark, bg = dark },
      }
      for _, c in ipairs { "Red", "Green", "Yellow", "Blue", "Purple", "Aqua", "Orange" } do
        overrides["Gruvbox" .. c .. "Sign"] = { bg = bg }
      end
      require("gruvbox").setup { overrides = overrides }
      vim.cmd.colorscheme(theme)
    end,
  },

  -- {
  --   "catppuccin/nvim",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "catppuccin-mocha"
  --     vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
  --   end,
  -- },
  -- {
  --   "ful1e5/onedark.nvim",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "onedark"
  --     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
  --   end,
  -- },
  -- {
  --   "vague-theme/vague.nvim",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "vague"
  --     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })
  --   end,
  -- },
  -- {
  --   "shaunsingh/solarized.nvim",
  --   priority = 1000,
  --   lazy = false, -- ensures it loads immediately on startup
  --   config = function()
  --     -- Solarized requires setting the global background option to 'light'
  --     vim.o.background = "light"
  --     vim.g.solarized_disable_background = true
  --
  --     -- Load and apply the colorscheme
  --     vim.cmd.colorscheme "solarized"
  --   end,
  -- },
  --
  -- {
  --   "cpplain/flexoki.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.o.background = "light"
  --     vim.cmd.colorscheme "flexoki"
  --     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })
  --   end,
  -- },
}
