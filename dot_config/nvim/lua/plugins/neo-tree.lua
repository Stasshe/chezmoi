local default_tree_width = 40
local tree_width_path = vim.fn.stdpath "state" .. "/neo-tree/sidebar-width"

local function is_tree_width(width)
  if not width then return false end

  return width > 0
end

local function read_tree_width()
  if vim.fn.filereadable(tree_width_path) == 0 then return default_tree_width end

  local lines = vim.fn.readfile(tree_width_path)
  local width = tonumber(lines[1])

  if is_tree_width(width) then return width end

  return default_tree_width
end

local function save_tree_width(width)
  if not is_tree_width(width) then return end

  vim.fn.mkdir(vim.fn.fnamemodify(tree_width_path, ":h"), "p")
  vim.fn.writefile({ tostring(width) }, tree_width_path)
end

local function save_current_tree_widths()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)

    if vim.bo[buf].filetype == "neo-tree" then save_tree_width(vim.api.nvim_win_get_width(win)) end
  end
end

local function save_resized_tree_widths()
  vim.defer_fn(save_current_tree_widths, 120)
end

local function save_event_tree_width(args)
  if args.position ~= "left" then return end
  if not args.winid or not vim.api.nvim_win_is_valid(args.winid) then return end

  save_tree_width(vim.api.nvim_win_get_width(args.winid))
end

local function restore_event_tree_width(args)
  if args.position ~= "left" then return end
  if not args.winid or not vim.api.nvim_win_is_valid(args.winid) then return end

  local width = read_tree_width()

  if vim.api.nvim_win_get_width(args.winid) ~= width then vim.api.nvim_win_set_width(args.winid, width) end

  -- Without this, vim's `equalalways` resizes neo-tree along with other
  -- windows whenever splits open/close (e.g. during crash-recovery), and
  -- neo-tree.nvim itself never sets winfixwidth to guard against it.
  vim.wo[args.winid].winfixwidth = true
end

local function tree_config()
  return {
    window = {
      width = read_tree_width(),
    },
  }
end

local function execute_tree(args)
  if args.toggle then save_current_tree_widths() end

  args.position = args.position or "left"
  require("neo-tree.command").execute(args, tree_config())
end

local function show_tree(source)
  vim.schedule(function()
    execute_tree {
      action = "focus",
      source = source,
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
        function() execute_tree { toggle = true, source = "last" } end,
        desc = "Toggle Explorer",
      }
      maps.n["<Leader>o"] = {
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd "p"
          else
            execute_tree { action = "focus", source = "last" }
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
          callback = save_resized_tree_widths,
          desc = "Save stable Neo-tree width after resize",
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
      event_handlers = {
        {
          event = "neo_tree_window_before_close",
          handler = save_event_tree_width,
        },
        {
          event = "neo_tree_window_after_open",
          handler = restore_event_tree_width,
        },
      },
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
