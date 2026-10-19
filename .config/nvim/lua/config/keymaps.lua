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

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessions.sh<CR>", { silent = true })

-- Neotest Keymaps
vim.keymap.set("n", "<leader>n", "", { desc = "🧪 Test" })
vim.keymap.set("n", "<leader>nr", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Run nearest test" })
vim.keymap.set(
  "n",
  "<leader>nf",
  "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
  { desc = "Run current file" }
)
vim.keymap.set(
  "n",
  "<leader>na",
  "<cmd>lua require('neotest').run.run({ suite = true })<cr>",
  { desc = "Run all tests" }
)
vim.keymap.set(
  "n",
  "<leader>nd",
  "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
  { desc = "Debug nearest test" }
)
vim.keymap.set("n", "<leader>ns", "<cmd>lua require('neotest').run.stop()<cr>", { desc = "Stop test" })
vim.keymap.set("n", "<leader>nn", "<cmd>lua require('neotest').run.attach()<cr>", { desc = "Attach to nearest test" })
vim.keymap.set("n", "<leader>no", "<cmd>lua require('neotest').output.open()<cr>", { desc = "Show test output" })
vim.keymap.set(
  "n",
  "<leader>np",
  "<cmd>lua require('neotest').output_panel.toggle()<cr>",
  { desc = "Toggle output panel" }
)
vim.keymap.set("n", "<leader>nv", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "Toggle summary" })
vim.keymap.set(
  "n",
  "<leader>nc",
  "<cmd>lua require('neotest').run.run({ suite = true, env = { CI = true } })<cr>",
  { desc = "Run all tests with CI" }
)

-- LSP Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.keymap.set("n", "vd", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.keymap.set("n", "vim", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.keymap.set("n", "vtd", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    vim.keymap.set("n", "vrr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    vim.keymap.set("n", "vrn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set("n", "vca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  end,
})
