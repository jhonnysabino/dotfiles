return {
	"vim-test/vim-test",
	dependencies = {
		"preservim/vimux",
	},
	vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", { desc = "Test: Nearest" }),
	vim.keymap.set("n", "<leader>T", ":TestFile<CR>", { desc = "Test: File" }),
	-- vim.keymap.set("n", "<leader>a", ":TestSuite<CR>"),
	vim.keymap.set("n", "<leader>l", ":TestLast<CR>", { desc = "Test: Last" }),
	-- vim.keymap.set("n", "<leader>g", ":TestVisit<CR>"),
	vim.cmd("let test#strategy = 'vimux'"),
	vim.cmd("let g:test#javascript#runner = 'vitest'"),
}
