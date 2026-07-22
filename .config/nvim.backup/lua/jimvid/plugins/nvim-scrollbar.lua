return {
    "petertriho/nvim-scrollbar",
    config = function()
        require("scrollbar").setup()
        require("scrollbar.handlers.diagnostic").setup()
    end,
}
