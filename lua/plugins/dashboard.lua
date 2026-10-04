-- Start screen: recent projects, open any folder, git repos, files

local name = "dk"
local projects_file = vim.fn.stdpath "data" .. "/projects"

local function read_projects()
  local ok, lines = pcall(vim.fn.readfile, projects_file)
  return ok and vim.tbl_filter(function(d)
    return vim.fn.isdirectory(d) == 1
  end, lines) or {}
end

local function add_project(dir)
  if dir == vim.env.HOME or dir == "/" then
    return
  end
  local list = { dir }
  for _, d in ipairs(read_projects()) do
    if d ~= dir and #list < 10 then
      list[#list + 1] = d
    end
  end
  vim.fn.writefile(list, projects_file)
end

-- remember the cwd as a project if a real file was open in it
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[b].buflisted and vim.bo[b].buftype == "" and vim.api.nvim_buf_get_name(b) ~= "" then
        return add_project(vim.fn.getcwd())
      end
    end
  end,
})

-- cd into dir, reopen the last file edited there, show the tree
local function open_project(dir)
  dir = vim.fs.normalize(dir)
  vim.cmd.cd(vim.fn.fnameescape(dir))
  add_project(dir)
  for _, f in ipairs(vim.v.oldfiles) do
    if vim.startswith(f, dir .. "/") and vim.fn.filereadable(f) == 1 then
      vim.cmd.edit(vim.fn.fnameescape(f))
      vim.cmd "Neotree show"
      return
    end
  end
  vim.cmd "enew | Neotree" -- enew closes the dashboard; the empty buffer goes away once a file opens
end

-- Telescope picker over directories printed by an fd command
local function pick_dir(title, cmd, strip)
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local conf = require("telescope.config").values
  require("telescope.pickers")
    .new({}, {
      prompt_title = title,
      finder = require("telescope.finders").new_oneshot_job(cmd, {
        entry_maker = function(line)
          local dir = line:gsub("/$", ""):gsub(strip or "$^", "")
          return { value = dir, display = vim.fn.fnamemodify(dir, ":~"), ordinal = dir }
        end,
      }),
      sorter = conf.file_sorter {},
      attach_mappings = function(bufnr)
        actions.select_default:replace(function()
          local sel = action_state.get_selected_entry()
          actions.close(bufnr)
          if sel then
            open_project(sel.value)
          end
        end)
        return true
      end,
    })
    :find()
end

local function open_folder()
  pick_dir("Open Folder", { "fd", "-t", "d", "--max-depth", "5", "-E", "node_modules", ".", vim.env.HOME })
end

local function open_git_repo()
  pick_dir("Git Repositories", { "fd", "-t", "d", "-H", "-I", "-g", ".git", vim.env.HOME, "--prune" }, "/%.git$")
end
vim.api.nvim_create_user_command("OpenGitRepos", open_git_repo, {})
vim.api.nvim_create_user_command("OpenFolder", open_folder, {})

return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
      local alpha = require "alpha"
      local dashboard = require "alpha.themes.dashboard"
      local width = 50
      local line = { type = "text", val = string.rep("─", width), opts = { position = "center", hl = "WinSeparator" } }

      local function btn(sc, text, fn, hl)
        local b = dashboard.button(sc, text)
        b.on_press = fn
        b.opts.keymap = { "n", sc, fn, { nowait = true, silent = true } }
        b.opts.width = width
        b.opts.cursor = 0
        b.opts.hl = hl
        b.opts.hl_shortcut = "Special"
        return b
      end

      -- rows with a divider under each one
      local function list(name, buttons)
        local out = { { type = "text", val = string.format("%-" .. width .. "s", name), opts = { position = "center", hl = "Title" } }, line }
        for _, b in ipairs(buttons) do
          vim.list_extend(out, { b, line })
        end
        return out
      end

      local function greeting()
        local h = tonumber(os.date "%H")
        local part = h < 12 and "morning" or h < 18 and "afternoon" or "evening"
        return "good " .. part .. ", " .. name .. "  ·  " .. os.date "%A %d %B"
      end

      local projects = {}
      for i, dir in ipairs(read_projects()) do
        if i > 5 then
          break
        end
        local label = string.format("%-20s", vim.fn.fnamemodify(dir, ":t"))
        local text = label .. vim.fn.fnamemodify(dir, ":~:h")
        if #text > width - 6 then
          text = text:sub(1, width - 7) .. "…"
        end
        projects[#projects + 1] = btn(tostring(i), text, function()
          open_project(dir)
        end, { { "Comment", #label, -1 } })
      end

      local actions = {
        btn("o", "Open folder", open_folder),
        btn("g", "Git repositories", open_git_repo),
        btn("f", "Find file", function()
          vim.cmd "Telescope find_files"
        end),
        btn("r", "Recent files", function()
          vim.cmd "Telescope oldfiles"
        end),
        btn("w", "Grep text", function()
          vim.cmd "Telescope live_grep"
        end),
        btn("n", "New file", function()
          vim.cmd "enew | startinsert"
        end),
        btn("c", "Config", function()
          open_project(vim.fn.stdpath "config")
        end),
        btn("p", "Plugins", function()
          vim.cmd "Lazy"
        end),
        btn("q", "Quit", function()
          vim.cmd "qa"
        end),
      }

      local logo = {
        "                ▀▀            ",
        "██▀▀█▄  ██  ██  ██  ██▀▀██▀▀█▄",
        "██  ██  ▀█▄▄█▀  ██  ██  ██  ██",
        "██  ██   ▀██▀   ██  ██  ██  ██",
      }

      local body = {
        { type = "text", val = logo, opts = { position = "center", hl = "Special" } },
        { type = "padding", val = 1 },
        { type = "text", val = greeting, opts = { position = "center", hl = "Comment" } },
        { type = "padding", val = 2 },
      }
      if #projects > 0 then
        vim.list_extend(body, list("Recent projects", projects))
        body[#body + 1] = { type = "padding", val = 2 }
      end
      vim.list_extend(body, list("Actions", actions))
      vim.list_extend(body, {
        { type = "padding", val = 2 },
        {
          type = "text",
          val = function()
            local s = require("lazy").stats()
            return string.format("%d plugins in %.0fms", s.count, s.startuptime)
          end,
          opts = { position = "center", hl = "Comment" },
        },
      })

      local height = 0
      for _, el in ipairs(body) do
        height = height + (el.type == "padding" and el.val or el.type == "group" and #el.val or type(el.val) == "table" and #el.val or 1)
      end

      local layout = {
        {
          type = "padding",
          val = function()
            return math.max(1, math.floor((vim.fn.winheight(0) - height) / 2))
          end,
        },
      }
      vim.list_extend(layout, body)

      alpha.setup { layout = layout, opts = { margin = 0 } }

      -- clean screen: no ~ on empty lines, no statusline/tab bar while the dashboard is up
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt_local.fillchars = "eob: "
          vim.o.laststatus, vim.o.showtabline = 0, 0
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaClosed",
        callback = function()
          vim.o.laststatus, vim.o.showtabline = 3, 2
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          pcall(alpha.redraw)
        end,
      })
    end,
  },
}
