return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, config = function()
      require("catppuccin").setup({ flavor = "mocha" })
      vim.cmd.colorscheme("catppuccin")
  end },
  { "nvim-treesitter/nvim-treesitter", opts = {
      ensure_installed = { "typescript", "javascript", "php", "markdown", "yaml" },
  }},
  { "folke/snacks.nvim", opts = {
      picker = { enabled = true },
      explorer = { enabled = true },
      terminal = { enabled = true },
  }},
}
