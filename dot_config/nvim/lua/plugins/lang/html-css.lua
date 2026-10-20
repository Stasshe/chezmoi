return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      filetypes = { extension = {
        pcss = "postcss",
        postcss = "postcss",
      } },
      treesitter = { ensure_installed = { "html", "css", "scss", "styled" } },
      autocmds = {
        html_browser = {
          {
            event = "FileType",
            pattern = "html",
            callback = function(event)
              vim.keymap.set("n", "<Leader>fB", function()
                local path = vim.api.nvim_buf_get_name(0)
                if vim.fn.filereadable(path) == 0 then
                  vim.notify("Save the HTML file before opening it in a browser", vim.log.levels.WARN)
                  return
                end
                local _, err = vim.ui.open(path)
                if err then vim.notify(err, vim.log.levels.ERROR) end
              end, { buffer = event.buf, desc = "Open HTML in browser" })
            end,
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function() vim.treesitter.language.register("scss", { "less", "postcss" }) end,
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      servers = {
        "html",
        "cssls",
        "emmet-ls",
      },
      config = {
        html = {
          filetypes = { "html" },
          cmd = { "vscode-html-language-server", "--stdio" },
          init_options = { provideFormatter = false },
        },
        cssls = { cmd = { "vscode-css-language-server", "--stdio" }, init_options = { provideFormatter = false } },
      },
    },
  },
  {
    "nvim-mini/mini.icons",
    optional = true,
    opts = {
      filetype = {
        postcss = { glyph = "󰌜", hl = "MiniIconsOrange" },
      },
    },
  },
}
