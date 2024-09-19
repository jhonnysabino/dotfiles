return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1001,
		opts = {},
		config = function()
			require("gruvbox").setup({
				transparent_mode = true,
			})
		end,
	},
}
