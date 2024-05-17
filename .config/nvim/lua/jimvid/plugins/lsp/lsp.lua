return {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
        { "lukas-reineke/lsp-format.nvim", config = true },
    },
    config = function()
        local lsp = require("lsp-zero")

        lsp.preset("recommended")

        lsp.set_sign_icons({
            error = "✘",
            warn = "▲",
            hint = "⚑",
            info = "»",
        })

        lsp.on_attach(function(_, bufnr)
            local opts = { buffer = bufnr, remap = false }

            vim.keymap.set("n", "gd", function()
                vim.lsp.buf.definition()
            end, opts)
            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover()
            end, opts)
            vim.keymap.set("n", "<leader>vws", function()
                vim.lsp.buf.workspace_symbol()
            end, opts)
            vim.keymap.set("n", "<leader>vd", function()
                vim.diagnostic.open_float()
            end, opts)
            vim.keymap.set("n", "[d", function()
                vim.diagnostic.goto_next()
            end, opts)
            vim.keymap.set("n", "]d", function()
                vim.diagnostic.goto_prev()
            end, opts)
            vim.keymap.set("n", "<leader>vca", function()
                vim.lsp.buf.code_action()
            end, opts)
            vim.keymap.set("n", "<leader>vrr", function()
                vim.lsp.buf.references()
            end, opts)
            vim.keymap.set("n", "<leader>vrn", function()
                vim.lsp.buf.rename()
            end, opts)
            vim.keymap.set("i", "<C-h>", function()
                vim.lsp.buf.signature_help()
            end, opts)
        end)

        require('mason').setup({
            ui = {
                border = "rounded",
            }
        })
        require('mason-lspconfig').setup({
            ensure_installed = { 'tsserver', 'rust_analyzer', "lua_ls" },
            handlers = {
                lsp.default_setup,
            },
        })

        -- Made LSP very slow for some reason, this aims to fix this. At least temporarily
        local lspconfig = require('lspconfig')
        lspconfig.tsserver.setup({
            root_dir = require('lspconfig.util').root_pattern('.git')
        })

        lsp.setup()

        -- setup cmp
        local cmp = require("cmp")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_action = require("lsp-zero").cmp_action()
        require("luasnip.loaders.from_vscode").lazy_load()
        local lspkind = require('lspkind')

        cmp.setup({
            formatting = {
                fields = { 'abbr', 'kind', 'menu' },
                format = lspkind.cmp_format({
                    mode = 'symbol',
                    maxwidth = 50,
                    ellipsis_char = '...',
                    show_labelDetails = true,
                    symbol_map = {
                        Copilot = "",
                    }
                })
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            sources = {
                { name = "copilot" },
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            },
            mapping = {
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<C-f>"] = cmp_action.luasnip_jump_forward(),
                ["<C-b>"] = cmp_action.luasnip_jump_backward(),
            },
        })

        vim.diagnostic.config({
            virtual_text = true,
        })
    end,
}
