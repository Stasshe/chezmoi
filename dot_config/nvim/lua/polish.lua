vim.g.clipboard = "win32yank"
vim.opt.clipboard:append "unnamedplus"
vim.keymap.set("n", "dd", '"_dd', { desc = "Delete line without yanking" })
