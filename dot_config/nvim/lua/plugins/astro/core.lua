---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    filetypes = {
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    options = {
      opt = {
        guicursor = "c-i:hor20",
        relativenumber = false,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
      },
      g = {},
    },
    autocmds = {
      insert_short_mapping_timeout = {
        {
          event = "InsertEnter",
          desc = "Short timeoutlen only while Insert (Space prefix / mapping wait)",
          callback = function()
            vim.g._astro_timeoutlen_before_insert = vim.o.timeoutlen
            vim.o.timeoutlen = math.min(vim.o.timeoutlen, 20)
          end,
        },
        {
          event = "InsertLeave",
          desc = "Restore timeoutlen after Insert",
          callback = function()
            local prev = vim.g._astro_timeoutlen_before_insert
            if type(prev) == "number" then vim.o.timeoutlen = prev end
            vim.g._astro_timeoutlen_before_insert = nil
          end,
        },
      },
    },
    mappings = {
      n = {
        ["<Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<S-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
      },
    },
  },
}
