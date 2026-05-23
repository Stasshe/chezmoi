-- =========================================================
-- Simple Neovim config
-- 用途:
-- - 設定ファイル編集
-- - 軽いコード修正
-- - ファイル検索
-- - Git差分確認
-- - ターミナルから素早く編集
-- =========================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
local keymap = vim.keymap.set

-- ---------------------------------------------------------
-- 基本設定
-- ---------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false

opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.splitright = true
opt.splitbelow = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.undofile = true
opt.swapfile = false
opt.backup = false

-- ---------------------------------------------------------
-- 最低限のキー設定
-- ---------------------------------------------------------

-- 検索ハイライトを消す
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- 保存・終了
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- ウィンドウ移動
keymap("n", "<C-h>", "<C-w>h", { desc = "Move left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move right window" })

-- 分割
keymap("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })

-- 選択行を上下に移動
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ---------------------------------------------------------
-- lazy.nvim
-- ---------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

opt.rtp:prepend(lazypath)

-- ---------------------------------------------------------
-- Plugins
-- ---------------------------------------------------------
require("lazy").setup({
  -- カラーテーマ
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- 下のステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          globalstatus = true,
          section_separators = "",
          component_separators = "",
        },
      })
    end,
  },

  -- ファイル操作
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })

      keymap("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
      keymap("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open file explorer" })
    end,
  },

  -- ファイル検索・全文検索
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")

      keymap("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      keymap("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      keymap("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
    end,
  },

  -- 構文ハイライト
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "json",
          "yaml",
          "markdown",
          "markdown_inline",
          "python",
          "cpp",
          "c",
          "bash",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Git差分表示
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()

      keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview git hunk" })
      keymap("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Git blame line" })
      keymap("n", "]g", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next git hunk" })
      keymap("n", "[g", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous git hunk" })
    end,
  },

  -- コメントアウト
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- 括弧の自動補完
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- インデント線
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  -- 下にターミナルを出す
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<C-\>]],
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })

      keymap("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Open terminal" })
      keymap("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
    end,
  },

  -- キー候補を表示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
})

-- ---------------------------------------------------------
-- 保存時に末尾空白を削除
-- ---------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})