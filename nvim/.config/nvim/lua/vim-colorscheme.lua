local colorscheme = "gruvbox"

local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found, falling back to default colorscheme", vim.log.levels.WARN)
  vim.cmd.colorscheme("default")
end
