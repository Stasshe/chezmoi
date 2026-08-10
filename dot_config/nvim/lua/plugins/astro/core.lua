local function diagnostic_contains_position(diagnostic, line, column)
  local end_line = diagnostic.end_lnum or diagnostic.lnum
  local end_column = diagnostic.end_col or diagnostic.col

  if line < diagnostic.lnum or end_line < line then
    return false
  end

  if diagnostic.lnum == end_line then
    return diagnostic.col <= column and column <= end_column
  end

  if line == diagnostic.lnum then
    return diagnostic.col <= column
  end

  if line == end_line then
    return column <= end_column
  end

  return true
end

local function diagnostic_overlaps_line(diagnostic, line)
  local end_line = diagnostic.end_lnum or diagnostic.lnum
  return diagnostic.lnum <= line and line <= end_line
end

local function diagnostics_to_messages(diagnostics, predicate)
  local messages = {}

  for _, diagnostic in ipairs(diagnostics) do
    if predicate(diagnostic) then
      table.insert(messages, diagnostic.message)
    end
  end

  return messages
end

local function copy_cursor_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1] - 1
  local column = cursor[2]
  local diagnostics = vim.diagnostic.get(bufnr)
  local messages = diagnostics_to_messages(diagnostics, function(diagnostic)
    return diagnostic_contains_position(diagnostic, line, column)
  end)

  if #messages == 0 then
    messages = diagnostics_to_messages(diagnostics, function(diagnostic)
      return diagnostic_overlaps_line(diagnostic, line)
    end)
  end

  if #messages == 0 then
    vim.notify("No diagnostics at cursor", vim.log.levels.INFO)
    return
  end

  local text = table.concat(messages, "\n")
  vim.fn.setreg("+", text)
  vim.notify("Copied diagnostics", vim.log.levels.INFO)
end

local function count_enter()
  if vim.v.count > 0 then return "G" end
  return "<CR>"
end

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
        showcmd = true,
        showcmdloc = "statusline",
        signcolumn = "yes",
        wrap = false,
      },
      g = {},
    },
    mappings = {
      n = {
        ["q"] = { "<cmd>quit<cr>", desc = "Quit window" },
        ["<F2>"] = { "q", desc = "Record macro" },
        ["<F8>"] = { copy_cursor_diagnostics, desc = "Copy cursor diagnostics" },
        ["<CR>"] = { count_enter, desc = "Go to counted line", expr = true },
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
      x = {
        ["<F8>"] = { copy_cursor_diagnostics, desc = "Copy cursor diagnostics" },
      },
    },
  },
}
