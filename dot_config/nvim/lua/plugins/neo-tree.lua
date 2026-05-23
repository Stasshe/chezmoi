return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      -- AstroNvim default `:Neotree toggle` always uses `default_source` (filesystem), so
      -- toggling from Git/Bufs resets the source selector to File. `source = "last"` matches
      -- the tab you picked (neo-tree updates `last` on next_source / prev_source).
      maps.n["<Leader>e"] = {
        function() require("neo-tree.command").execute { toggle = true, source = "last" } end,
        desc = "Toggle Explorer",
      }
      maps.n["<Leader>o"] = {
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd "p"
          else
            require("neo-tree.command").execute { action = "focus", source = "last" }
          end
        end,
        desc = "Toggle Explorer Focus",
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        width = 40,
        mappings = {
          ["<Tab>"] = "next_source",
          ["<S-Tab>"] = "prev_source",
        },
      },

      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_hidden = true,
          hide_by_pattern = {
            "*.meta",
            "*.unity",
            "*.fls",
            "*.aux",
            "*.dvi",
            "*.pdf",
            "*.gz",
            "*.fdb_latexmk",
          },
        },
      },
    },
  },
}
