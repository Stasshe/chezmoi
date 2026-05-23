return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        ["<leader>fi"] = { function() require("snacks").picker.highlights() end, desc = "Find highlights" },
      },
    },
  },
}
