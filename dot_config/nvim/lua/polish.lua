if vim.fn.has "wsl" == 1 then
  vim.g.clipboard = "win32yank"
else
  vim.g.clipboard = "osc52"
end

vim.opt.clipboard:append "unnamedplus"
vim.keymap.set({ "n", "x" }, "d", '"_d', { desc = "Delete without yanking" })
