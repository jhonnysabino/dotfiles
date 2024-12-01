return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("chatgpt").setup()
		vim.keymap.set("n", "<leader>ia", ":ChatGPT<CR>", { desc = "ChatGPT: Open" })
	end,
}
