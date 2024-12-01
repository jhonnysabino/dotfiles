return {
	"christoomey/vim-tmux-navigator",
	config = function()
		vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { desc = "Tmux Navigator: Left" })
		vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { desc = "Tmux Navigator: Down" })
		vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { desc = "Tmux Navigator: Up" })
		vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { desc = "Tmux Navigator: Right" })
	end,
}
