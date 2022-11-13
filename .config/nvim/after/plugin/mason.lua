local mason = require("mason")
local lspconfig = require("mason-lspconfig")

mason.setup({})

lspconfig.setup({
	automatic_installation = true,
})
