vim.g.mapleader = " "
vim.api.nvim_set_keymap("i", "jk", "<ESC>", { noremap = true })

local map = require("jimvid.utils").map

-- General
map("n", "<leader>w", ":w<cr>", { noremap = true })
map("n", "<leader>wq", ":wq<cr>", { noremap = true })
map("n", "<leader>q", ":q<cr>", { noremap = true })
map("n", "<leader>cq", ":cq<cr>", { noremap = true })

-- New tab
map("n", "te", ":tabedit")

-- Split window
map("n", "ss", ":split<Return><C-w>w")
map("n", "sv", ":vsplit<Return><C-w>w")

-- Move window
map("n", "<Space>", "<C-w>w")
map("", "sh", "<C-w>h")
map("", "sk", "<C-w>k")
map("", "sj", "<C-w>j")
map("", "sl", "<C-w>l")

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<cr>", { noremap = true })
map("n", "<leader>fb", ":Telescope buffers<cr>", { noremap = true })
map("n", "<leader>fg", ":Telescope live_grep<cr>", { noremap = true })

-- ToggleTerm
map("n", "<leader>tt", ":ToggleTerm<cr>", { noremap = true })
map("n", "<leader>Tt", ":ToggleTerm dir=~<cr>", { noremap = true })

-- Packer
map("n", "<leader>pc", ":PackerCompile<cr>")
map("n", "<leader>pi", ":PackerInstall<cr>")
map("n", "<leader>ps", ":PackerSync<cr>")
map("n", "<leader>pS", ":PackerStatus<cr>")
map("n", "<leader>pu", ":PackerUpdate<cr>")

-- Nvim-tree
map("n", "<leader>e", ":NvimTreeToggle<cr>")
map("n", "<leader>fe", ":NvimTreeToggle<cr>")
