vim.g.mapleader = " "

-- Make it quicker to save/quit etc
vim.keymap.set("n", "<leader>w", ":w<cr>", { noremap = true })
vim.keymap.set("n", "<leader>wq", ":wq<cr>", { noremap = true })
vim.keymap.set("n", "<leader>q", ":q<cr>", { noremap = true })
vim.keymap.set("n", "<leader>cq", ":cq<cr>", { noremap = true })

-- Center when jumping half a page
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })

vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })
vim.keymap.set("n", "<leader>tt", ":term<cr>i", { noremap = true })
vim.keymap.set("n", "<leader>R", ":% s/", { noremap = true })

-- Move lines up & down in visual mode
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

-- Do not replace clipboard when pasting
vim.keymap.set("x", "<leader>p", '"_dP')

-- Opt out of Q
vim.keymap.set("n", "Q", "<nop>")

-- Split panes
vim.keymap.set("n", "ss", ":split<Return><C-w>w")
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w")

-- Navigate tmux panes
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true })
