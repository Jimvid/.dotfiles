local status, nvim_tree = pcall(require, "nvim-tree")

if not status then
	return
end

nvim_tree.setup({
	sort_by = "case_sensitive",
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})

local opt = { noremap = true }

vim.keymap.set("n", "<leader>", ":NvimTreeToggle", opt)
