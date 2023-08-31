local fn = vim.fn

-- Bootstrap lazy

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

local plugins = {
	"wbthomason/packer.nvim",
	"nvim-lua/plenary.nvim",
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ "williamboman/mason.nvim" }, -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "L3MON4D3/LuaSnip" }, -- Required
		},
	},
	{ "catppuccin/nvim", as = "catppuccin" },
	{ "jose-elias-alvarez/null-ls.nvim" },
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{ "christoomey/vim-tmux-navigator", lazy = false },
	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
	"nvim-lua/telescope.nvim",
	"theprimeagen/harpoon",
	"tpope/vim-surround",
	"nvim-tree/nvim-web-devicons",
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
}
-- Plugins

lazy.setup(plugins, opts)
