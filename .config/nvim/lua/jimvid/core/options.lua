vim.g.mapleader = " "

vim.opt.clipboard = 'unnamedplus' -- sync cliboard with system clipboard
vim.opt.titlestring = "%t%( %M%)"

vim.opt.guicursor = ""
vim.opt.termguicolors = true

vim.opt.cursorline = true
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

-- vim.opt.colorcolumn = "80"

-- Add custom filetypes
vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
        border = "rounded", -- or "single", "double", "shadow", etc.
    }
)
