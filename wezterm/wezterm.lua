-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Local multiplexer: panes/tabs live in a background `wezterm-mux-server` so
-- closing the GUI detaches rather than kills. Reattach with `wezterm connect
-- unix` or just by launching WezTerm again.
config.unix_domains = {
	{ name = "unix" },
}
config.default_gui_startup_args = { "connect", "unix" }

-- Latte overrides: Latte's defaults are too pastel for dense terminal text
-- (italics/links render as washed-out lavender). Override ansi/brights with
-- saturated Catppuccin values, and force the default foreground to Latte
-- `text` so tools using foreground-default render with full contrast.
local latte_colors = {
	foreground = "#4c4f69", -- text
	background = "#eff1f5", -- base (unchanged)
	cursor_bg = "#dc8a78",
	cursor_fg = "#4c4f69",
	cursor_border = "#dc8a78",
	selection_fg = "#4c4f69",
	selection_bg = "#acb0be",
	ansi = {
		"#5c5f77", -- 0  black    subtext1
		"#d20f39", -- 1  red
		"#40a02b", -- 2  green
		"#df8e1d", -- 3  yellow
		"#1e66f5", -- 4  blue
		"#8839ef", -- 5  magenta  mauve
		"#179299", -- 6  cyan     teal
		"#acb0be", -- 7  white    surface2
	},
	brights = {
		"#6c6f85", -- 8  br black subtext0
		"#d20f39", -- 9  br red
		"#40a02b", -- 10 br green
		"#df8e1d", -- 11 br yellow
		"#1e66f5", -- 12 br blue
		"#8839ef", -- 13 br magenta
		"#179299", -- 14 br cyan
		"#bcc0cc", -- 15 br white  surface1
	},
}

-- Apply appearance per-window via the live window context. This is reliable
-- under macOS Auto appearance, whereas wezterm.gui.get_appearance() at
-- config-load time returns "Light" before the GUI has resolved.
wezterm.on("window-config-reloaded", function(window, _pane)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	if appearance:find("Dark") then
		overrides.color_scheme = "Catppuccin Mocha"
		overrides.colors = nil
	else
		overrides.color_scheme = "Catppuccin Latte"
		overrides.colors = latte_colors
	end
	window:set_config_overrides(overrides)
end)

config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 12

config.enable_tab_bar = true

config.initial_rows = 48
config.initial_cols = 150

config.window_decorations = "RESIZE"

-- Always ask for confirmation before closing
config.window_close_confirmation = "AlwaysPrompt"
-- Don't skip confirmation for any processes (empty list = always prompt)
config.skip_close_confirmation_for_processes_named = {}

-- Disable enhanced keyboard protocol to fix escape sequence issues
config.enable_kitty_keyboard = false

local act = wezterm.action

-- Key bindings
config.keys = {
	-- Shift+Enter sends a newline
	{
		key = "Enter",
		mods = "SHIFT",
		action = act.SendString("\n"),
	},
	-- -- Control+` to toggle (hide) the terminal
	-- {
	-- 	key = "`",
	-- 	mods = "CTRL",
	-- 	action = act.Hide,
	-- },
	-- -- CTRL-w: Close tab with confirmation
	-- {
	-- 	key = "w",
	-- 	mods = "CTRL",
	-- 	action = act.CloseCurrentTab({ confirm = true }),
	-- },
	-- -- CTRL-q: Quit with confirmation
	-- {
	-- 	key = "q",
	-- 	mods = "CTRL",
	-- 	action = act.QuitApplication,
	-- },
	-- -- Disable CMD+W (duplicated by CTRL+W)
	-- {
	-- 	key = "w",
	-- 	mods = "CMD",
	-- 	action = "DisableDefaultAssignment",
	-- },
	-- -- Disable CMD+Q (duplicated by CTRL+Q)
	-- {
	-- 	key = "q",
	-- 	mods = "CMD",
	-- 	action = "DisableDefaultAssignment",
	-- },
}

-- config.window_background_opacity = 0.8
-- config.macos_window_background_blur = 10

-- and finally, return the configuration to wezterm

-- Letta Code: Fix Delete key sending wrong sequence with kitty keyboard protocol
-- See: https://github.com/wez/wezterm/issues/3758
local wezterm = require("wezterm")
local keys = config.keys or {}
table.insert(keys, {
	key = "Delete",
	mods = "NONE",
	action = wezterm.action.SendString("\x1b[3~"),
})
config.keys = keys

return config
