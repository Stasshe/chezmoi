local plugin_dir = vim.fn.expand("~/dev/github/nvim-office")

if vim.fn.isdirectory(plugin_dir) == 0 then return {} end

return {
  {
    dir = plugin_dir,
    name = "nvim-office",
    lazy = false,
    dependencies = { "folke/snacks.nvim" },
    build = "npm install --omit=dev",
    opts = {},
  },
}
