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
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
		},
	},
	{ "catppuccin/nvim", as = "catppuccin" },
	"nvim-telescope/telescope-file-browser.nvim",
	"jose-elias-alvarez/null-ls.nvim",
	"christoomey/vim-tmux-navigator",
	"nvim-lua/telescope.nvim",
	"theprimeagen/harpoon",
	"tpope/vim-surround",
	"nvim-tree/nvim-web-devicons",
	{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons", opt = true } },
	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
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

local opts = {}

lazy.setup(plugins, opts)
