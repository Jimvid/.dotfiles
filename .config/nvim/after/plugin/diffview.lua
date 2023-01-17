local status, diffview = pcall(require, "diffview")

if not status then
	return
end

diffview.setup({
	use_icons = false,
})

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", opts)
vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", opts)
vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory<CR>", opts)
