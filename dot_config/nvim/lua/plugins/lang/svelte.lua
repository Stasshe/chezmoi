return {
  {
    "AstroNvim/astrocore",
    optional = true,
    ---@type AstroCoreOpts
    opts = {
      treesitter = { ensure_installed = { "svelte" } },
    },
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      servers = {
        "svelte",
      },
      config = {
        svelte = {
          cmd = { "svelteserver", "--stdio" },
          filetypes = { "svelte" },
        },
      },
    },
  },
}
