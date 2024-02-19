require("jimvid.core")
require("jimvid.lazy")

local is_mac = vim.fn.has("macunix")
local is_win = vim.fn.has("win32")

-- sync vim clipboard with os clipboard
if is_mac then
    vim.opt.clipboard:append({ "unnamedplus" })
end

if is_win then
    vim.opt.clipboard:prepend({ "unnamed", "unnamedplus" })
end
