require("bufferline").setup({
  options = {
    mode = "tabs",
    -- separator_style = 'slant',
    -- always_show_bufferline = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = true
  },
})

vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
vim.keymap.set('n', '<leader>cl', '<Cmd>BufferLineCloseLeft<CR>', {})
vim.keymap.set('n', '<leader>cr', '<Cmd>BufferLineCloseRight<CR>', {})
vim.keymap.set('n', '<leader>1', '<Cmd>BufferlineGoToBuffer 1<CR>', {})
vim.keymap.set('n', '<leader>2', '<Cmd>BufferlineGoToBuffer 2<CR>', {})
vim.keymap.set('n', '<leader>3', '<Cmd>BufferlineGoToBuffer 3<CR>', {})
vim.keymap.set('n', '<leader>4', '<Cmd>BufferlineGoToBuffer 4<CR>', {})
vim.keymap.set('n', '<leader>5', '<Cmd>BufferlineGoToBuffer 5<CR>', {})
vim.keymap.set('n', '<leader>6', '<Cmd>BufferlineGoToBuffer 6<CR>', {})
