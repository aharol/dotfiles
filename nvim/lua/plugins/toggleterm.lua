---@type LazySpec
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      {
        "<C-/>",
        "<Cmd>ToggleTerm<CR>",
        mode = { "n", "t" },
        desc = "Toggle floating terminal",
      },
    },
    opts = {
      -- 'size' can be a number (lines for horizontal, columns for vertical)
      -- or a function which is passed the current terminal object
      size = function(term)
        if term.direction == "horizontal" then
          return 15 -- height in lines
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4 -- width (40% of total columns)
        end
        return 20 -- fallback size
      end,
      direction = "float", -- default direction
      -- Configuration specific to floating terminals
      float_opts = {
        border = "curved",
        -- width and height can be a number or a function
        width = function() return math.ceil(vim.o.columns * 0.8) end, -- 80% of screen width
        height = function() return math.ceil(vim.o.lines * 0.8) end, -- 80% of screen height
        winblend = 3,
        -- other options like 'row', 'col', 'zindex' are also available
      },
    },
  },
}
