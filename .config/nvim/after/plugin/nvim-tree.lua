vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
	sort_by = "case_sensitive",
	remove_keymaps = {
		"s", -- disable "open shell"
		"f", -- disable filter
	},
	view = {
		adaptive_size = true,
		width = 20,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})
