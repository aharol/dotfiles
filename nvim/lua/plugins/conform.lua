return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- Format XML/SVG using xmllint
    opts.formatters = opts.formatters or {}
    opts.formatters.xmllint = {
      command = "xmllint",
      args = { "--format", "-" },
      stdin = true,
    }

    opts.formatters_by_ft.xml = { "xmllint" }
    opts.formatters_by_ft.svg = { "xmllint" }

    -- Only auto-format XML/SVG on save, let LSP handle others
    opts.format_on_save = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      if ft == "xml" or ft == "svg" then
        return { timeout_ms = 1000, lsp_fallback = true }
      end
    end

    return opts
  end,
}
