return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 500,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
			})
			vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Gitsigns: Preview hunk" })
			vim.keymap.set("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns: Stage hunk" })
			vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns: Reset hunk" })
		end,
	},
}
