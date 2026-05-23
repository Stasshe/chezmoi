-- https://www.andersevenrud.net/neovim.github.io/lsp/configurations/
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

return {
  { import = "plugins.lang.go" },
  { import = "plugins.lang.html-css" },
  { import = "plugins.lang.json" },
  { import = "plugins.lang.lua" },
  { import = "plugins.lang.python" },
  { import = "plugins.lang.rust" },
  { import = "plugins.lang.svelte" },
  { import = "plugins.lang.toml" },
  { import = "plugins.lang.typescript" },
  { import = "plugins.lang.oxc" },
}
