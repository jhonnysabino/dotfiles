return {
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		config = function()
			local dap = require("dap")

			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debugging Connect" })
			vim.keymap.set("n", "<leader>dd", dap.disconnect, { desc = "Debugging Disconnect" })
			vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Debugging Next Step" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debugging Step Into" })
			vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debugging Step Out" })
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debugging Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Condição do breakpoint: "))
			end, { desc = "Debugging add conditional breakpoint" })

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
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({
				reset = true,
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
			vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Toggle Debug UI" })
		end,
	},

	-- Instala o debugger do VS Code
	{
		"microsoft/vscode-js-debug",
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
	},
}
