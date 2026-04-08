return {
	"vim-test/vim-test",
	vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { desc = "Test: Nearest" }),
	vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", { desc = "Test: File" }),
	vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "Test: Last" }),
	vim.cmd("let g:test#javascript#runner = 'vitest'"),
}
