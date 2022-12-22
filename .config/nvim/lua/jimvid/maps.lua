vim.g.mapleader = " "
vim.api.nvim_set_keymap("i", "jk", "<ESC>", { noremap = true })

vim.keymap.set("n", "<leader>w", ":w<cr>", { noremap = true })
vim.keymap.set("n", "<leader>wq", ":wq<cr>", { noremap = true })
vim.keymap.set("n", "<leader>q", ":q<cr>", { noremap = true })
vim.keymap.set("n", "<leader>cq", ":cq<cr>", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })

vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "te", ":tabedit")

vim.keymap.set("n", "ss", ":split<Return><C-w>w")
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w")

vim.keymap.set("", "sh", "<C-w>h")
vim.keymap.set("", "sk", "<C-w>k")
vim.keymap.set("", "sj", "<C-w>j")
vim.keymap.set("", "sl", "<C-w>l")
