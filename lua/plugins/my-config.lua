return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, config = function()
      require("catppuccin").setup({ flavor = "mocha" })
      vim.cmd.colorscheme("catppuccin")
  end },
  { "nvim-treesitter/nvim-treesitter", opts = {
      ensure_installed = { "typescript", "javascript", "docker", "php", "markdown", "yaml" },
  }},
  { "mason.nvim", opts = {
      ensure_installed = {
        "typescript-language-server",
        "docker-language-server",
      },
  }},
  { "folke/snacks.nvim", opts = {
      picker = {
        enabled = true,
        sources = {
          explorer = {
            hidden  = true,
            ignored = true,
            exclude = { ".git" },
          },
        },
      },
      explorer = { enabled = true },
      terminal = { enabled = true },
  }},
}
