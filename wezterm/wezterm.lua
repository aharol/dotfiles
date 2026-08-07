-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Keep a local mux domain available for attach/resume.
config.unix_domains = {
	{ name = "unix" },
}
-- Always reattach to the persistent mux on launch (tmux-like). Reading the arg
-- from the config file (rather than gating on WEZTERM_CONNECT_MUX_ON_START)
-- means Dock/Spotlight launches reattach too, not just terminal-spawned ones.
-- Use Cmd+N (see config.keys) for a fresh local shell that bypasses the mux.
config.default_gui_startup_args = { "connect", "unix" }

-- Base color defaults so the first mux-attached window isn't black when
-- `window:get_appearance()` hasn't resolved yet at window-create time.
-- Pick the initial scheme from OS appearance at config-load time; the
-- `window-config-reloaded` hook below still flips this live on changes.
local function initial_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

if initial_appearance():find("Dark") then
	config.color_scheme = "Catppuccin Mocha"
else
	config.color_scheme = "Catppuccin Latte"
end

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
-- Apply latte overrides as the base only when starting in Light mode,
-- so the base `config.colors` matches the initial `config.color_scheme`.
if not initial_appearance():find("Dark") then
	config.colors = latte_colors
end

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
config.font_size = 11

-- Force GPU-accelerated renderer (OpenGL → Metal on macOS).
-- WebGpu leaves white artifacts in newly exposed areas on window resize.
config.front_end = "OpenGL"

-- Quote dropped paths conservatively so dragging files into shells/TUIs yields
-- a usable path even when names contain spaces or shell metacharacters.
config.quote_dropped_files = "Posix"

config.enable_tab_bar = false

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
	-- Encode Shift+Enter as kitty-protocol CSI-u (ESC[13;2u). tmux has
	-- extended-keys on with csi-u format, so it parses and forwards this to the
	-- pane; modern TUIs (Kimi, Codex, ...) decode it as Shift+Enter → newline.
	{
		key = "Enter",
		mods = "SHIFT",
		action = act.SendString("\x1b[13;2u"),
	},
	-- Cmd+N: fresh LOCAL shell window, bypassing the persistent mux.
	{
		key = "n",
		mods = "CMD",
		action = act.SpawnCommandInNewWindow({ domain = { DomainName = "local" } }),
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

-- Shift bypasses the application's mouse reporting (bypass_mouse_reporting_modifiers),
-- so a Shift+drag inside tmux is WezTerm's own selection rather than tmux's. The
-- defaults have no `SHIFT Drag` binding, and `SHIFT Up` uses the OrOpenLink variant
-- which treats a dragless press as a click — so the shift path never reliably lands
-- on the clipboard the way a plain tmux-captured drag does (tmux.conf binds
-- MouseDragEnd1Pane to pbcopy). Bind the shift path explicitly so both routes copy.
--
-- Duplicated for mouse_reporting true/false: the bypass case is the one that matters
-- under tmux, the plain case keeps a bare shell consistent. `SHIFT Down` is left on
-- its default (ExtendSelectionToMouseCursor) so Shift+click still extends a selection.
local shift_select_bindings = {}
for _, reporting in ipairs({ false, true }) do
	table.insert(shift_select_bindings, {
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "SHIFT",
		action = act.ExtendSelectionToMouseCursor("Cell"),
		mouse_reporting = reporting,
	})
	table.insert(shift_select_bindings, {
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SHIFT",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
		mouse_reporting = reporting,
	})
end
config.mouse_bindings = shift_select_bindings

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
