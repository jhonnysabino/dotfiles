-- lua/plugins/debug.lua

return {
	-- Plugin principal de debugging
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		config = function()
			local dap = require("dap")

			-- Configurando atalhos
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Iniciar/Continuar debugging" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Pular linha" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Entrar na função" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Sair da função" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Alternar breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Condição do breakpoint: "))
			end, { desc = "Adicionar breakpoint condicional" })

			-- Ícones para breakpoints
			vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "👉", texthl = "", linehl = "", numhl = "" })
		end,
	},

	-- Adaptador JavaScript/TypeScript
	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = { "mfussenegger/nvim-dap" },
		event = "VeryLazy",
		config = function()
			require("dap-vscode-js").setup({
				debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
				adapters = { "chrome", "pwa-node", "pwa-chrome", "node", "node-terminal" },
			})

			-- Configurações para linguagens JavaScript
			local linguagens_js = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

			for _, linguagem in ipairs(linguagens_js) do
				require("dap").configurations[linguagem] = {
					-- Debug de arquivo Node.js
					{
						type = "pwa-node",
						request = "launch",
						name = "Debugar Arquivo Atual",
						program = "${file}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						protocol = "inspector",
						console = "integratedTerminal",
					},
					-- Anexar a processo Node.js
					{
						type = "pwa-node",
						request = "attach",
						name = "Anexar ao Processo",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					-- Debug web com Chrome
					{
						type = "pwa-chrome",
						request = "launch",
						name = "Iniciar Chrome com localhost",
						url = "http://localhost:3000",
						webRoot = "${workspaceFolder}",
						userDataDir = "${workspaceFolder}/.vscode/chrome-debug-data",
						sourceMaps = true,
						protocol = "inspector",
						port = 9222,
						skipFiles = { "<node_internals>/**" },
					},
					-- Debug do Vitest
					{
						type = "pwa-node",
						request = "launch",
						name = "Debugar Vitest",
						program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
						args = { "run", "${file}" },
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						sourceMaps = true,
						protocol = "inspector",
						skipFiles = { "<node_internals>/**" },
						env = {
							CI = "true",
							NODE_ENV = "test",
							VITEST = "true",
						},
					},
					-- Debug do Vitest Current Test
					{
						type = "pwa-node",
						request = "launch",
						name = "Debugar Teste Atual (Vitest)",
						program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
						args = { "run", "${file}", "-t", "${selectedText}" },
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						sourceMaps = true,
						protocol = "inspector",
						skipFiles = { "<node_internals>/**" },
						env = {
							CI = "true",
							NODE_ENV = "test",
							VITEST = "true",
						},
					},
					-- Debug do Vitest em modo Watch
					{
						type = "pwa-node",
						request = "launch",
						name = "Debugar Vitest (Watch Mode)",
						program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
						args = { "watch", "${file}" },
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						sourceMaps = true,
						protocol = "inspector",
						skipFiles = { "<node_internals>/**" },
						env = {
							CI = "true",
							NODE_ENV = "test",
							VITEST = "true",
						},
					},
				}
			end
		end,
	},

	-- Dependência necessária para nvim-dap-ui
	{
		"nvim-neotest/nvim-nio",
	},

	-- Interface visual do debugger
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		event = "VeryLazy",
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							"scopes",
							"breakpoints",
							"stacks",
							"watches",
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							"repl",
							"console",
						},
						size = 10,
						position = "bottom",
					},
				},
				floating = {
					max_height = nil,
					max_width = nil,
					border = "single",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
			})

			-- Auto abrir/fechar UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Atalho para toggle da UI
			vim.keymap.set("n", "<leader>ui", dapui.toggle, { desc = "Toggle Debug UI" })
		end,
	},

	-- Instala o debugger do VS Code
	{
		"microsoft/vscode-js-debug",
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
	},
}
