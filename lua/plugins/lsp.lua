-- LSP: mason installs servers, mason-lspconfig auto-enables every installed one.
-- Add more with :Mason (press i) — they get enabled automatically, no config needed.
-- Completion capabilities come from blink.cmp (syntax.lua) automatically.

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    -- Keys are Neovim's built-in LSP defaults (:h lsp-defaults): K, <C-]>, grn, gra, grr, gri, grt, gO, [d ]d
    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
  end,
})

vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

-- pyright: use the Linux virtualenv in the project root (.venv, .venv-linux, ...) unless one is activated
-- Takes the first venv found; set VIRTUAL_ENV or :LspPyrightSetPythonPath if a project has several
vim.lsp.config("pyright", {
  before_init = function(_, config)
    if vim.env.VIRTUAL_ENV or not config.root_dir then
      return
    end
    for name, type in vim.fs.dir(config.root_dir) do
      local venv = vim.fs.joinpath(config.root_dir, name)
      if type == "directory" and vim.uv.fs_stat(venv .. "/pyvenv.cfg") and vim.uv.fs_stat(venv .. "/bin/python") then
        config.settings.python.pythonPath = venv .. "/bin/python"
        return
      end
    end
  end,
})

-- Godot: the GDScript server lives inside the Godot editor (port 6005), so keep the editor open on the project
vim.lsp.enable "gdscript"

return {
  { "mason-org/mason.nvim", opts = {} },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "eslint",
        "html",
        "cssls",
        "tailwindcss",
        "emmet_language_server",
        "jsonls",
        "yamlls",
        "taplo",
        "bashls",
        "clangd",
        "rust_analyzer",
        "gopls",
        "jdtls",
        "omnisharp",
        "marksman",
        "dockerls",
        "docker_compose_language_service",
        "sqlls",
        "neocmake",
      },
    },
  },
}
