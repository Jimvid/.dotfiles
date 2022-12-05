vim.g.mapleader = " "
vim.api.nvim_set_keymap("i", "jk", "<ESC>", { noremap = true })

-- General

vim.keymap.set("n", "<leader>w", ":w<cr>", { noremap = true })
vim.keymap.set("n", "<leader>wq", ":wq<cr>", { noremap = true })
vim.keymap.set("n", "<leader>q", ":q<cr>", { noremap = true })
vim.keymap.set("n", "<leader>cq", ":cq<cr>", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })

-- New tab
vim.keymap.set("n", "te", ":tabedit")

-- Split window
vim.keymap.set("n", "ss", ":split<Return><C-w>w")
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w")

-- Move window
vim.keymap.set("", "sh", "<C-w>h")
vim.keymap.set("", "sk", "<C-w>k")
vim.keymap.set("", "sj", "<C-w>j")
vim.keymap.set("", "sl", "<C-w>l")

-- Telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<cr>", { noremap = true })

-- ToggleTerm
vim.keymap.set("n", "<leader>tt", ":ToggleTerm<cr>", { noremap = true })
vim.keymap.set("n", "<leader>Tt", ":ToggleTerm dir=~<cr>", { noremap = true })

-- Packer
vim.keymap.set("n", "<leader>pc", ":PackerCompile<cr>")
vim.keymap.set("n", "<leader>pi", ":PackerInstall<cr>")
vim.keymap.set("n", "<leader>ps", ":PackerSync<cr>")
vim.keymap.set("n", "<leader>pS", ":PackerStatus<cr>")
vim.keymap.set("n", "<leader>pu", ":PackerUpdate<cr>")

-- Nvim-tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")
vim.keymap.set("n", "<leader>fe", ":NvimTreeToggle<cr>")
