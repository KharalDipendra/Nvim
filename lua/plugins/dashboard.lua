return {
  "goolord/alpha-nvim",
  lazy = false, -- must be set up before VimEnter or the dashboard never shows
  config = function()
    local dashboard = require "alpha.themes.dashboard"
    dashboard.section.header.val = { "Nvim" }
    dashboard.section.buttons.val = {}
    dashboard.config.opts.keymap = { press = {}, queue_press = {} } -- no buttons, so Enter does nothing
    dashboard.config.layout[1].val = function() -- vertical centering
      return math.floor(vim.o.lines / 2) - 2
    end
    require("alpha").setup(dashboard.config)
  end,
}
