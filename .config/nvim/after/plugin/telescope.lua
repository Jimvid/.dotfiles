local status, telescope = pcall(require, "telescope")
local builtin = require("telescope.builtin")

if not status then
	return
end

telescope.setup({ defaults = { file_ignore_patterns = { "node_modules" } } })

vim.keymap.set("n", "<leader>ff", ":Telescope find_files<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fs", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>/", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end)
