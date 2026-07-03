return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        ["<C-p>"] = { function() require("snacks").picker.files() end, desc = "Find files" },
        ["<leader>fi"] = { function() require("snacks").picker.highlights() end, desc = "Find highlights" },
      },
    },
  },
}
