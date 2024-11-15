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
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			local util = require("lspconfig.util")
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "goimports", "gofmt" },
					javascript = function()
						if util.root_pattern(".prettierrc")(vim.fn.getcwd()) then
							return { "prettier" }
						else
							return { "biome" }
						end
					end,
					kotlin = { "ktlint" },
					terraform = { "terraform_fmt" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local util = require("lspconfig.util")
			local on_attach = function(_, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }

				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts)
				vim.keymap.set("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", opts)
				vim.keymap.set("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

				vim.keymap.set("n", "<leader>gf", function()
					require("conform").format()
				end, opts)
			end

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.jdtls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd_env = {
					JAVA_HOME = "/home/jhonny/.sdkman/candidates/java/17.0.0-tem",
				},
			})
			lspconfig.terraformls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.kotlin_language_server.setup({
				capabilities = capabilities,
				on_attach = on_attach,
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
		end,
	},
}
