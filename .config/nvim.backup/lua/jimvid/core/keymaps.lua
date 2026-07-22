vim.g.mapleader = " "

vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })

vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("v", "<leader>p", '"_dP')

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true })

vim.keymap.set("n", "<leader>NN", ":NoNeckPain<CR>", { silent = true })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessions.sh<CR>", { silent = true })

-- Neotest
vim.keymap.set("n", "<leader>n", "", { desc = "🧪 Test" })
vim.keymap.set("n", "<leader>nr", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>nf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
    { desc = "Run current file" })
vim.keymap.set("n", "<leader>na", "<cmd>lua require('neotest').run.run({ suite = true })<cr>", { desc = "Run all tests" })
vim.keymap.set("n", "<leader>nd", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
    { desc = "Debug nearest test" })
vim.keymap.set("n", "<leader>ns", "<cmd>lua require('neotest').run.stop()<cr>", { desc = "Stop test" })
vim.keymap.set("n", "<leader>nn", "<cmd>lua require('neotest').run.attach()<cr>", { desc = "Attach to nearest test" })
vim.keymap.set("n", "<leader>no", "<cmd>lua require('neotest').output.open()<cr>", { desc = "Show test output" })
vim.keymap.set("n", "<leader>np", "<cmd>lua require('neotest').output_panel.toggle()<cr>",
    { desc = "Toggle output panel" })
vim.keymap.set("n", "<leader>nv", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "Toggle summary" })
vim.keymap.set("n", "<leader>nc", "<cmd>lua require('neotest').run.run({ suite = true, env = { CI = true } })<cr>",
    { desc = "Run all tests with CI" })
