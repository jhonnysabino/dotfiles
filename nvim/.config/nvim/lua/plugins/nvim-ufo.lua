return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},

	config = function()
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		vim.keymap.set("n", "zO", require("ufo").openAllFolds, { desc = "Open all folds" })
		vim.keymap.set("n", "zC", require("ufo").closeAllFolds, { desc = "Close all folds" })
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})
	end,
}
