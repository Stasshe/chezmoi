local default_tree_width = 40
local tree_width_path = vim.fn.stdpath "state" .. "/neo-tree/window-width"

local function read_tree_width()
  if vim.fn.filereadable(tree_width_path) == 0 then return default_tree_width end

  local lines = vim.fn.readfile(tree_width_path)
  local width = tonumber(lines[1])

  if width and width > 0 then return width end

  return default_tree_width
end

local function save_tree_width(width)
  if not width or width <= 0 then return end

  vim.fn.mkdir(vim.fn.fnamemodify(tree_width_path, ":h"), "p")
  vim.fn.writefile({ tostring(width) }, tree_width_path)
end

local function save_current_tree_widths()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)

    if vim.bo[buf].filetype == "neo-tree" then save_tree_width(vim.api.nvim_win_get_width(win)) end
  end
end

local function save_closed_tree_width(event)
  local win = tonumber(event.match)

  if not win or not vim.api.nvim_win_is_valid(win) then return end

  local buf = vim.api.nvim_win_get_buf(win)

  if vim.bo[buf].filetype == "neo-tree" then save_tree_width(vim.api.nvim_win_get_width(win)) end
end

local function show_tree(source)
  vim.schedule(function()
    require("neo-tree.command").execute {
      action = "focus",
      source = source,
      position = "left",
    }
  end)
end

return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      local autocmds = opts.autocmds
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

      autocmds.neo_tree_default = {
        {
          event = "User",
          pattern = "VeryLazy",
          once = true,
          callback = function() show_tree "filesystem" end,
          desc = "Open and focus Neo-tree on startup",
        },
      }

      autocmds.neo_tree_width = {
        {
          event = "WinResized",
          callback = save_current_tree_widths,
          desc = "Save resized Neo-tree width",
        },
        {
          event = "WinClosed",
          callback = save_closed_tree_width,
          desc = "Save closed Neo-tree width",
        },
        {
          event = "VimLeavePre",
          callback = save_current_tree_widths,
          desc = "Save Neo-tree width before exit",
        },
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        width = read_tree_width(),
        mappings = {
          ["<space>"] = "none",
          ["<Tab>"] = "next_source",
          ["<S-Tab>"] = "prev_source",
        },
      },

      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_hidden = false,
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
