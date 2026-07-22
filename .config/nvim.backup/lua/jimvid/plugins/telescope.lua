return {

    "nvim-lua/telescope.nvim",
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        telescope.setup({
            defaults = {
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
                path_display = { "smart" },
                prompt_prefix = " ",
                selection_caret = " ",
                sorting_strategy = "ascending",
                prompt_position = "top",
                layout_config = {
                    prompt_position = "top",
                    height = 0.70,
                    width = 0.70,
                },
            },
            pickers = {
                buffers = {
                    prompt_prefix = "﬘ ",
                },
                commands = {
                    prompt_prefix = " ",
                },
                git_files = {
                    prompt_prefix = " ",
                    show_untracked = true,
                },
                find_files = {
                    prompt_prefix = " ",
                    find_command = { "rg", "--files", "--hidden" },
                },
            },
        })

        -- keymaps
        vim.keymap.set("n", "<leader>ff", ":Telescope find_files <cr>", { noremap = true })
        vim.keymap.set("n", "<leader>fb", ":Telescope buffers <cr>", { noremap = true })
        vim.keymap.set("n", "<leader>fg", ":Telescope live_grep <cr>", { noremap = true })
        vim.keymap.set("n", "<leader>fd", ":Telescope diagnostics <cr>", { noremap = true })
        vim.keymap.set("n", "<leader>fs", function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set("n", "<leader>FF", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                layout_config = { height = 0.70, width = 0.70 },
                previewer = false,
            }))
        end)
    end,
}
