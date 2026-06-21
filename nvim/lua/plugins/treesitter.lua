-- nvim-treesitter: migrate AstroNvim from the archived `master` branch to the
-- rewritten `main` branch.
--
-- Why: on Neovim 0.12 the `master` branch's injection queries are incompatible
-- with core's reworked injection->range handling, so the treesitter highlighter
-- crashes with "attempt to call method 'range' (a nil value)" (neovim#39032).
-- `main` is the maintained rewrite and fixes the whole class of crashes.
--
-- What changes on `main`: there are no plugin "modules" any more. Highlighting is
-- core Neovim (`vim.treesitter.start`), parsers install via
-- `require("nvim-treesitter").install(...)`, and textobjects use a new
-- select/move/swap API. This spec overrides AstroNvim's master integration
-- (which calls `nvim-treesitter.configs`) so none of the master API runs.

local ensure_installed = {
  "bash", "c", "lua", "luadoc", "luap", "markdown", "markdown_inline",
  "python", "query", "vim", "vimdoc",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main does NOT support lazy-loading
    main = "nvim-treesitter", -- override AstroNvim's `main = "nvim-treesitter.configs"` (gone on main)
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup { install_dir = vim.fn.stdpath "data" .. "/site" }

      -- install / keep parsers (async; already-installed are skipped)
      pcall(function() require("nvim-treesitter").install(ensure_installed) end)

      -- main does not enable highlighting; core Neovim does, per buffer.
      -- pcall so a not-yet-installed parser is skipped instead of crashing.
      local function start(buf)
        if not vim.api.nvim_buf_is_valid(buf) then return end
        local ft = vim.bo[buf].filetype
        if ft == "" then return end
        local lang = vim.treesitter.language.get_lang(ft) or ft
        pcall(vim.treesitter.start, buf, lang)
      end

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Start treesitter highlighting (nvim-treesitter main)",
        callback = function(ev) start(ev.buf) end,
      })

      -- cover buffers already open before this config ran
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then start(buf) end
      end
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local select = require("nvim-treesitter-textobjects.select").select_textobject
      local move = require "nvim-treesitter-textobjects.move"
      local swap = require "nvim-treesitter-textobjects.swap"

      -- select (visual / operator-pending) — preserves AstroNvim's default maps
      local sel = {
        ak = "@block.outer", ik = "@block.inner",
        ac = "@class.outer", ic = "@class.inner",
        ["a?"] = "@conditional.outer", ["i?"] = "@conditional.inner",
        af = "@function.outer", ["if"] = "@function.inner",
        ao = "@loop.outer", io = "@loop.inner",
        aa = "@parameter.outer", ia = "@parameter.inner",
      }
      for lhs, q in pairs(sel) do
        vim.keymap.set({ "x", "o" }, lhs, function() select(q, "textobjects") end,
          { desc = "textobject " .. q })
      end

      -- move (normal / visual / operator-pending)
      local moves = {
        goto_next_start = { ["]k"] = "@block.outer", ["]f"] = "@function.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]K"] = "@block.outer", ["]F"] = "@function.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[k"] = "@block.outer", ["[f"] = "@function.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[K"] = "@block.outer", ["[F"] = "@function.outer", ["[A"] = "@parameter.inner" },
      }
      for fn, maps in pairs(moves) do
        for lhs, q in pairs(maps) do
          vim.keymap.set({ "n", "x", "o" }, lhs, function() move[fn](q, "textobjects") end,
            { desc = (fn:gsub("_", " ")) .. " " .. q })
        end
      end

      -- swap (normal)
      vim.keymap.set("n", ">K", function() swap.swap_next "@block.outer" end, { desc = "swap next block" })
      vim.keymap.set("n", ">F", function() swap.swap_next "@function.outer" end, { desc = "swap next function" })
      vim.keymap.set("n", ">A", function() swap.swap_next "@parameter.inner" end, { desc = "swap next argument" })
      vim.keymap.set("n", "<K", function() swap.swap_previous "@block.outer" end, { desc = "swap previous block" })
      vim.keymap.set("n", "<F", function() swap.swap_previous "@function.outer" end, { desc = "swap previous function" })
      vim.keymap.set("n", "<A", function() swap.swap_previous "@parameter.inner" end, { desc = "swap previous argument" })
    end,
  },
}
