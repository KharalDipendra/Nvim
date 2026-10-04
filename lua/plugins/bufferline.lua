-- Tab bar of open files along the top
return {
  "akinsho/bufferline.nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    -- `nvim .` leaves an empty [No Name] buffer behind; drop it once a real file opens
    vim.api.nvim_create_autocmd("BufReadPost", {
      callback = function(ev)
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          if b ~= ev.buf and vim.bo[b].buflisted and vim.bo[b].buftype == "" and not vim.bo[b].modified
            and vim.api.nvim_buf_get_name(b) == "" and vim.api.nvim_buf_line_count(b) == 1
            and vim.api.nvim_buf_get_lines(b, 0, 1, false)[1] == "" then
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(b) then
                pcall(vim.api.nvim_buf_delete, b, {})
              end
            end)
          end
        end
      end,
    })
  end,
  opts = {
    options = {
      offsets = {
        {
          filetype = "neo-tree",
          -- OLED burn-in: the label drifts with the statusline (g:sl_shift, set in init.lua)
          text = function()
            return string.rep(" ", 2 * (vim.g.sl_shift or 0)) .. "Files"
          end,
          highlight = "Directory",
          separator = true,
        },
      },
    },
  },
  keys = {
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next tab" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous tab" },
  },
}
