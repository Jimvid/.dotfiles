local null_ls = require("null-ls")

-- format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- lsp formatting
local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

null_ls.setup({
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.alex,
		null_ls.builtins.diagnostics.ltrs,
		null_ls.builtins.completion.spell,
		null_ls.builtins.completion.luasnip,
		null_ls.builtins.code_actions.eslint,
		null_ls.builtins.code_actions.ltrs,
		null_ls.builtins.hover.dictionary,
	},
})
