return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules",
					},
					theme = "center",
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.3,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
					grep_string = {
						additional_args = { "--hidden" },
					},
					live_grep = {
						additional_args = { "--hidden" },
					},
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Telescope: Find Git Files" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find Files" })
			vim.keymap.set("n", "<leader>fl", builtin.live_grep, { desc = "Telescope: Live Grep" })
		end,
	},
}
