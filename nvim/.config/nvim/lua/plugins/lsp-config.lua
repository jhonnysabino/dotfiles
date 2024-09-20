return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local util = require("lspconfig.util")

			vim.keymap.set("n", "<leader>gf", function()
				vim.lsp.buf.format({ timeout_ms = 5000 })
			end, { desc = "Format code" })

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.kotlin_language_server.setup({
				capabilities = capabilities,
				cmd = { vim.fn.stdpath("data") .. "/mason/bin/kotlin-language-server" },
				cmd_env = {
					JAVA_HOME = "/home/jhonny/.sdkman/candidates/java/11.0.11-open",
					PATH = vim.fn.stdpath("data")
						.. "/mason/bin:"
						.. "/home/jhonny/.sdkman/candidates/java/11.0.11-open/bin:"
						.. vim.env.PATH,
				},
				root_dir = util.root_pattern("settings.gradle", "build.gradle", ".git"),
			})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
		end,
	},
}
