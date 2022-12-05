local status, mason = pcall(require, "mason")
local status2, lspconfig = pcall(require, "mason-lspconfig")

if not status and not status2 then
	return
end

mason.setup({})

lspconfig.setup({
	automatic_installation = true,
})
