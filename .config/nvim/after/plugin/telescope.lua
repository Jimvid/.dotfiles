local status, telescope = pcall(require, "telescope")
local builtin = require("telescope.builtin")

if not status then
    return
end

telescope.setup({
    extensions = {
        file_browser = {
            layout_strategy = "horizontal",
            preview = true,
            layout_config = { height = 100, width = 1000 },
            hijack_netrw = true,
        },
    },
    defaults = {
        -- winblend = 10,
        file_ignore_patterns = { "node_modules" },
        layout_strategy = "horizontal",
        layout_config = { height = 0.70, width = 0.70 },
    },
})

-- load extentions
telescope.load_extension("file_browser")

-- keymaps
vim.api.nvim_set_keymap("n", "<space>fe", ":Telescope file_browser<cr>", { noremap = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<cr>", { noremap = true })
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>FF", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        layout_config = { height = 0.70, width = 0.70 },
        previewer = false,
    }))
end)
