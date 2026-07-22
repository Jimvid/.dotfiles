return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-jest",
        "nvim-neotest/neotest-go",
    },
    config = function()
        local status_ok, neotest = pcall(require, "neotest")
        if not status_ok then
            return
        end

        local jest = require("neotest-jest")
        local go   = require("neotest-go")

        neotest.setup({
            summary = {
                open = "botright vsplit | vertical resize 80",
            },
            adapters = {
                jest({
                    jestCommand = "yarn test --",
                    cwd = function(path)
                        return vim.fn.getcwd()
                    end,
                }),
                go({
                    experimental = {
                        test_table = true,
                    },
                    args = { "-count=1", "-timeout=60s" }
                })
            },
        })
    end,
}
