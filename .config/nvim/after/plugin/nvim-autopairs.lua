local status, nvim_autopairs = pcall(require, "nvim-autopairs")

if not status then
	return
end

nvim_autopairs.setup({
	check_ts = true,
})

require("nvim-ts-autotag").setup()
