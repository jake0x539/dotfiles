-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- shorten wezterm.action
local act = wezterm.action

-- check if running on windows; if yes, launch into pwsh by default
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "pwsh.exe" }
	config.max_fps = 180
end

-- set font
config.font = wezterm.font("Cascadia Mono")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" } -- disable ligatures
config.font_size = 14
-- set color scheme (nightly required)
config.color_scheme = "Everforest Dark Hard (Gogh)"
config.window_background_opacity = 0.97

-- blinking bar cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- window padding (usually I keep it very low)
local padding_amt = 4
config.window_padding = { left = padding_amt, right = padding_amt, top = padding_amt, bottom = padding_amt }

-- configure tab bar
config.hide_tab_bar_if_only_one_tab = true -- I don't want to see it unless I need to
config.use_fancy_tab_bar = false -- vastly prefer retro tab bar
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false -- I don't like it
config.show_close_tab_button_in_tabs = true

-- my WSL tab names are often mildly long - I want to see them fully
config.tab_max_width = 24

-- tab bar colors (apologies in advance for tabs being so long)
-- also based on kanagawa dragon colors
config.colors = {
	tab_bar = {
		background = "#191717",
		active_tab = {
			bg_color = "#c5c9c5",
			fg_color = "#181616",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#181616",
			fg_color = "#c5c9c5",
			intensity = "Half",
		},
	},
}

-- keybinds time!
config.disable_default_key_bindings = true
-- set leader to control space
config.leader = { mods = "CTRL", key = " ", timeout_milliseconds = 1000 }
config.keys = {
	{ action = act.CopyTo("Clipboard"), mods = "CTRL|SHIFT", key = "C" },
	{ action = act.PasteFrom("Clipboard"), mods = "CTRL|SHIFT", key = "V" },
	{ action = act.DecreaseFontSize, mods = "CTRL", key = "-" },
	{ action = act.IncreaseFontSize, mods = "CTRL", key = "=" },
	{ action = act.ResetFontSize, mods = "CTRL", key = "0" },
	{ action = act.Nop, mods = "ALT", key = "Enter" },
	{ action = act.SendKey({ key = ".", mods = "CTRL" }), mods = "CTRL", key = "." },
	{ action = act.SendKey({ key = "/", mods = "CTRL" }), mods = "CTRL", key = "/" },
	{ action = act.ToggleFullScreen, key = "F11" },
	-- Launcher and tab navigation
	-- I mostly use the launcher to access my WSL instances (I have several)
	-- Maybe one day I'll have keys to access particular instances
	-- I also don't use splits in my terminal at the moment, I'll have to think about that later

	-- ShowLauncher also acts as command palette
	{ action = act.ShowLauncher, mods = "LEADER", key = "n" },
	{ action = act.ShowLauncher, mods = "CTRL|SHIFT", key = "P" },
	{ action = act.ActivateTabRelative(-1), mods = "LEADER", key = "q" },
	{ action = act.ActivateTabRelative(1), mods = "LEADER", key = "w" },
	{ action = act.ShowTabNavigator, mods = "LEADER", key = "e" },
	-- Also acts as close tab
	{ action = act.CloseCurrentPane({ confirm = false }), mods = "LEADER", key = "x" },
}

for i = 1, 9 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i),
	})
end

return config
