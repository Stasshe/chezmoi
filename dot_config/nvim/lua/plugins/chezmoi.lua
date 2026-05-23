vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { os.getenv "HOME" .. "/.local/share/chezmoi/*" },
  callback = function(ev)
    local bufnr = ev.buf
    local edit_watch = function() require("chezmoi.commands.__edit").watch(bufnr) end
    vim.schedule(edit_watch)
  end,
})

return {
  "xvzc/chezmoi.nvim",
  opts = {
    edit = {
      watch = true,
      force = false,
    },
    notification = {
      on_open = true,
      on_apply = true,
      on_watch = true,
    },
  },
}
