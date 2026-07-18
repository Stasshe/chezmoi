return {
  {
    dir = vim.fn.expand("~/dev/github/nvim-office"),
    name = "nvim-office",
    lazy = false,
    dependencies = { "folke/snacks.nvim" },
    build = "npm install --omit=dev",
    opts = {},
  },
}
