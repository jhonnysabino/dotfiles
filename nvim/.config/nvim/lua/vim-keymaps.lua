vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!"<CR>')
-- Avisa o WezTerm quando o neovim está ativo
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
    callback = function()
        io.write("\x1b]1337;SetUserVar=IS_NVIM=dHJ1ZQ==\007")
    end,
})
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
    callback = function()
        io.write("\x1b]1337;SetUserVar=IS_NVIM=ZmFsc2U=\007")
    end,
})

-- Navega entre splits do neovim; se estiver na borda, vai pro pane do WezTerm
local function navigate(nvim_dir, wez_dir)
    local current = vim.fn.winnr()
    vim.cmd("wincmd " .. nvim_dir)
    if vim.fn.winnr() == current then
        vim.fn.system("wezterm cli activate-pane-direction " .. wez_dir)
    end
end

vim.keymap.set("n", "<C-h>", function() navigate("h", "Left") end,  { desc = "Move focus left" })
vim.keymap.set("n", "<C-j>", function() navigate("j", "Down") end,  { desc = "Move focus down" })
vim.keymap.set("n", "<C-k>", function() navigate("k", "Up") end,    { desc = "Move focus up" })
vim.keymap.set("n", "<C-l>", function() navigate("l", "Right") end, { desc = "Move focus right" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "j", "jzz")
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>r", function()
	local word = vim.fn.expand("<cword>")
	vim.cmd("call feedkeys(':%s/" .. word .. "/', 'n')")
end, { desc = "Replace word under cursor" })

function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ""
	end
end

vim.keymap.set("v", "<leader>r", function()
	local word = vim.getVisualSelection()
	vim.cmd("call feedkeys(':%s/" .. word .. "/', 'n')")
end, { desc = "Replace word under cursor" })

vim.keymap.set("n", "<leader>lg", function()
	--  get file name with extension
	local file = vim.fn.expand("%:t")
	vim.cmd("LazyGit")

	-- Wait a bit for LazyGit to load
	vim.defer_fn(function()
		-- search for the file, highlight, and exit search mode in lazygit
		vim.api.nvim_feedkeys("/" .. file, "t", true)
		vim.api.nvim_input("<CR>")
		vim.api.nvim_input("<ESC>")
	end, 150) -- (milliseconds)
end, { desc = "[g]it" })
