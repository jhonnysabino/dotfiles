return {
	"supermaven-inc/supermaven-nvim",

	config = function()
		vim.keymap.set("n", "<leader>ct", ":SupermavenToggle<CR>", { desc = "Supermaven: Toggle" })
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-j>",
			},
			ignore_filetypes = { "cpp" },
			log_level = "info",
			disable_inline_completion = false,
			disable_keymaps = false,
			condition = function()
				return false
			end,
		})
	end,
}
