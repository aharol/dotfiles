---@type LazySpec
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      background = { light = "latte", dark = "mocha" },
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        mason = true,
        native_lsp = { enabled = true },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
  },
}
