vim.g.mapleader = " "

vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.backup = false
vim.opt.wrap = false

vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.wildoptions = "pum"
vim.opt.pumblend = 0

-- Add custom filetypes
vim.filetype.add({
    extension = {
        templ = "templ",
    },
})
