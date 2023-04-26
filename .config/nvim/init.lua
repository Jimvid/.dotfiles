require("jimvid.base")
require("jimvid.plugins")
require("jimvid.colors")
require("jimvid.maps")

local has = vim.fn.has
local is_mac = has("macunix")
local is_win = has("win32")

-- sync vim clipboard with os clipboard
if is_mac then
	vim.opt.clipboard:append({ "unnamedplus" })
end
if is_win then
	vim.opt.clipboard:prepend({ "unnamed", "unnamedplus" })
end
