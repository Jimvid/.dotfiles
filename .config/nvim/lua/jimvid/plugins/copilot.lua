return {
	"zbirenbaum/copilot.lua",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local copilot = require("copilot")

		copilot.setup({
			suggestions = {
				auto_trigger = true,
				keymap = {
					accept = "<M-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
		})
	end,
}
