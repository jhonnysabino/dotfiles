return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Workaround for Neovim 0.12.1 treesitter bug:
      -- get_range sometimes receives nil node, causing "attempt to call method 'range' (a nil value)"
      -- https://github.com/neovim/neovim/issues (0.12.1 regression with #offset! directive)
      local orig_get_range = vim.treesitter.get_range
      vim.treesitter.get_range = function(node, source, metadata)
        if node == nil then
          return { 0, 0, 0, 0, 0, 0 }
        end
        local ok, result = pcall(orig_get_range, node, source, metadata)
        if ok then
          return result
        end
        -- Fallback: return a safe zero range
        return { 0, 0, 0, 0, 0, 0 }
      end

      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,
        ensure_installed = { "lua", "go", "templ", "html", "css", "javascript", "typescript", "markdown", "markdown_inline" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
}
