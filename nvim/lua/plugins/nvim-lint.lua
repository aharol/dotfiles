return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require "lint"

    -- Use xmllint as a linter (well-formedness check)
    lint.linters.xmllint = {
      cmd = "xmllint",
      stdin = false,
      args = { "--noout", "--recover" }, -- recover helps it continue; remove if you prefer strict
      stream = "stderr",
      ignore_exitcode = true, -- xmllint returns non-zero on errors (we still want diagnostics)
      parser = require("lint.parser").from_errorformat("%f:%l:%c: %t%*[^:]: %m", {
        source = "xmllint",
      }),
    }

    lint.linters_by_ft = {
      xml = { "xmllint" },
      svg = { "xmllint" }, -- SVG is XML; keep if you want it
    }

    -- Lint on save + on leaving insert mode
    local lintable_patterns = { "*.xml", "*.svg" }
    local grp = vim.api.nvim_create_augroup("LintOnSave", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      group = grp,
      pattern = lintable_patterns,
      callback = function()
        -- avoid linting special buffers
        if vim.bo.buftype ~= "" then return end
        lint.try_lint("xmllint")
      end,
    })
  end,
}
