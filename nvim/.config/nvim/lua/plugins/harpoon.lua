return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()

		-- Mapear teclas personalizadas
		vim.keymap.set("n", "<leader>m", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Adicionar arquivo" })
		vim.keymap.set("n", "<leader>h", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Abrir menu" })

		-- Navegar para as marcas
		vim.keymap.set("n", "<M-h>", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: Ir para marca 1" })
		vim.keymap.set("n", "<M-j>", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: Ir para marca 2" })
		vim.keymap.set("n", "<M-k>", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: Ir para marca 3" })
		vim.keymap.set("n", "<M-l>", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: Ir para marca 4" })

	end,
}
