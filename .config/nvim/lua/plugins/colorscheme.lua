return {
  -- 保留 tokyonight 但不使用它（避免报错）
  {
    "folke/tokyonight.nvim",
    lazy = true, -- 延迟加载，不主动使用
  },

  -- 启用 catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
