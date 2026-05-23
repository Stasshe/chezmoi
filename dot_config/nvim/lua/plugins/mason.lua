---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    enabled = false,
    opts = {
      ensure_installed = {
        "lua-language-server-",
        "stylua",
        "debugpy",
        "tree-sitter-cli",
      },
    },
  },
}
