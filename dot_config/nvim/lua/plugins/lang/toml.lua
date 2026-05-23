return {
  {
    {
      "AstroNvim/astrocore",
      optional = true,
      ---@type AstroCoreOpts
      opts = {
        treesitter = { ensure_installed = { "toml" } },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      servers = {
        "tombi",
      },
      config = {
        tombi = {
          filetypes = { "toml" },
        },
      },
    },
  },
}
