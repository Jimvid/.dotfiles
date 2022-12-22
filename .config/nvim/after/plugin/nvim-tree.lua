local status, nvim_tree = pcall(require, "nvim-tree")

if not status then
	return
end

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

nvim_tree.setup({
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

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")
vim.keymap.set("n", "<leader>fe", ":NvimTreeToggle<cr>")
