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
