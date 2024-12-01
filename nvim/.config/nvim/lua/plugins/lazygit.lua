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
		if vim.fn.executable("nvr") == 1 then
			vim.env.GIT_EDITOR = "nvr --remote-tab-wait +'set bufhidden=delete'"
		end
	end,
}
