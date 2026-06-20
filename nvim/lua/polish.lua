-- Work around a Neovim 0.12 core treesitter crash on markdown files with
-- fenced code blocks: nvim-treesitter (archived master) ships a markdown
-- `injections` query using the custom `#set-lang-from-info-string!` directive,
-- which is incompatible with nvim 0.12's injection range handling and throws
-- "attempt to call method 'range' (a nil value)". We replace it with the modern
-- query (standard `@injection.language` capture), which keeps code-block /
-- frontmatter / inline highlighting and does not crash. See neovim#39032.
local function fix_markdown_injections()
  pcall(
    vim.treesitter.query.set,
    "markdown",
    "injections",
    [[
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
]]
  )
end
fix_markdown_injections()

local function detect_macos_appearance()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if not handle then return "dark" end
  local result = handle:read("*a")
  handle:close()
  return result:match("Dark") and "dark" or "light"
end

local function sync_background()
  local new_bg = detect_macos_appearance()
  if vim.o.background ~= new_bg then vim.o.background = new_bg end
end

sync_background()

vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
  callback = sync_background,
})

local uv = vim.uv or vim.loop
local appearance_timer = uv.new_timer()
if appearance_timer then
  appearance_timer:start(2000, 2000, vim.schedule_wrap(sync_background))
end

vim.opt.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.bo.buftype == "" and vim.bo.modifiable then vim.cmd.checktime() end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("File reloaded because it changed externally.", vim.log.levels.WARN)
  end,
})
