return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        zen = { enabled = true },
        words = { enabled = true },

        styles = {
            lazygit = {
                position = "float",
                backdrop = true,
                height = 0.99,
                width = 0.99,
            }
        }
    },
    keys = {
        { "<leader>z",  function() Snacks.zen() end,              desc = "Toggle Zen Mode" },
        { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit current file log history" },
        { "<leader>gg", function() Snacks.lazygit() end,          desc = "Lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log() end,      desc = "Lazygit log" },
        {
            "]]",
            function() Snacks.words.jump(vim.v.count1) end,
            desc = "Next Reference",
            mode = { "n", "t" }
        },
        {
            "[[",
            function() Snacks.words.jump(-vim.v.count1) end,
            desc = "Prev Reference",
            mode = { "n", "t" }
        },
    }
}
