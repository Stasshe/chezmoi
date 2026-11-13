vim.g.clipboard = "win32yank"
vim.opt.clipboard:append "unnamedplus"
vim.keymap.set({ "n", "x" }, "d", '"_d', { desc = "Delete without yanking" })
