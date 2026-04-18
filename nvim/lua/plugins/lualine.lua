return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require "lualine"
    local lazy_status = require "lazy.status" -- to configure lazy pending updates count

    local function is_light()
      local handle = io.popen "defaults read -g AppleInterfaceStyle 2>/dev/null"
      if not handle then return false end
      local out = handle:read "*a"
      handle:close()
      return not out:match "Dark"
    end

    local function build_theme()
      local t = require "lualine.themes.catppuccin"
      t.normal.c.bg = is_light() and "#ccd0da" or "#313244"
      return t
    end

    -- configure lualine with modified theme
    lualine.setup {
      options = {
        theme = build_theme(),
      },
      sections = {
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    }

    vim.api.nvim_create_autocmd({ "OptionSet", "FocusGained", "VimResume" }, {
      pattern = "*",
      callback = function(args)
        if args.event == "OptionSet" and vim.fn.expand "<amatch>" ~= "background" then return end
        lualine.setup { options = { theme = build_theme() } }
      end,
    })
  end,
}
