local status, transparent = pcall(require, "transparent")

if not status then
	return
end

transparent.setup({
	extra_groups = {
		"OctoEditable",
	},
})
