if vim.fn.has "wsl" == 1 and vim.fn.executable "win32yank.exe" == 1 then
  vim.g.clipboard = "win32yank"
  vim.opt.clipboard:append "unnamedplus"
end
