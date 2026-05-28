return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		-- User command to close the lazygit float (main + border window) from a remote-send call.
		-- WinLeave doesn't fire when closing programmatically from outside, so we close
		-- all floating windows to catch both the terminal buffer and the border window.
		vim.api.nvim_create_user_command("LazygitClose", function()
			for _, w in ipairs(vim.api.nvim_list_wins()) do
				local ok, cfg = pcall(vim.api.nvim_win_get_config, w)
				if ok and cfg.relative ~= "" then
					pcall(vim.api.nvim_win_close, w, true)
				end
			end
		end, {})
	end,
}
