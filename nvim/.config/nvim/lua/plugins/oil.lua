return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilEnter",
			callback = vim.schedule_wrap(function(args)
				local oil = require("oil")
				if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
					oil.open_preview()
				end
			end),
		})
		require("oil").setup({
			keymaps = {
				["<C-h>"] = false,
			},
			view_options = {
				show_hidden = true,
			},
			delete_to_trash = false,
		})
	end,
}
