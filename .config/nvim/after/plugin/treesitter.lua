local status, ts = pcall(require, "nvim-treesitter.configs")

if not status then
	return
end

ts.setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		disable = {},
	},
	ensure_installed = {
		"javascript",
		"typescript",
		"tsx",
		"toml",
		"rust",
		"json",
		"yaml",
		"css",
		"html",
		"lua",
	},
	autotag = {
		enable = true,
	},
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
