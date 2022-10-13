-- vim.cmd("autocmd!")

local set = vim.opt

vim.g.mapleader = " "
vim.api.nvim_set_keymap("i", "jk", "<ESC>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>Ft", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true })
vim.opt.cursorline = true
vim.opt.termguicolors = true
set.relativenumber = true
set.tabstop = 2
