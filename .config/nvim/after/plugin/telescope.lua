local status, telescope = pcall(require, "telescope")

if not status then
	return
end

local builtin = require("telescope.builtin")
-- local fb_actions = require("telescope").extensions.file_browser.actions

telescope.setup({
	extensions = {
		-- 		file_browser = {
		-- 			layout_strategy = "horizontal",
		-- 			preview = true,
		-- 			layout_config = { height = 100, width = 1000 },
		-- 			hijack_netrw = true,
		-- 			hidden = true,
		-- 			mappings = {
		-- 				["n"] = {
		-- 					["<C-a>"] = fb_actions.create,
		-- 					["<C-d>"] = fb_actions.remove,
		-- 				},
		-- 			},
		-- 		},
	},
	defaults = {
		winblend = 10,
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
		},
		file_ignore_patterns = { "node_modules", ".git" },
		layout_strategy = "horizontal",
		layout_config = { height = 0.70, width = 0.70 },
	},
})

-- load extentions
-- telescope.load_extension("file_browser")

-- keymaps
-- vim.api.nvim_set_keymap("n", "<space>fe", ":Telescope file_browser<cr>", { noremap = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files hidden=true <cr>", { noremap = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep hidden=true <cr>", { noremap = true })
vim.keymap.set("n", "<leader>fs", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>FF", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		layout_config = { height = 0.70, width = 0.70 },
		previewer = false,
	}))
end)
