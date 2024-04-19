local wezterm = require("wezterm")
local act = wezterm.action

local config = {
	default_workspace = "main",
	color_scheme = "Catppuccin Mocha",
	-- color_scheme = "Google Light (base16)",
	-- color_scheme = "Dark+",
	-- color_scheme = "Catppuccin Latte (Gogh)",
	-- color_scheme = "Monokai Pro (Gogh)",
	-- color_scheme = "OneDark (base16)",
	-- color_scheme = "Monokai (dark) (terminal.sexy)",
	-- color_scheme = "Dark+",
	-- color_scheme = "Atelier Sulphurpool (base16)", -- good
	-- color_scheme = "rebecca",
	-- color_scheme = "nightfox",
	color_scheme = "Nightfly (Gogh)",
	color_scheme = "Neon Night (Gogh)",
	color_scheme = "BlulocoDark",
	-- color_scheme = "Dracula+",
	-- color_scheme = "Sonokai (Gogh)",
	-- color_scheme = "Catppuccin Macchiato",
	color_scheme = "tokyonight_moon",
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = false,
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = false,
	macos_window_background_blur = 70,
	scrollback_lines = 50000,
	enable_scroll_bar = true,
	window_background_opacity = 0.8,
	text_background_opacity = 1,
	adjust_window_size_when_changing_font_size = false,
	window_padding = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 5,
	},
	-- background = {
	-- 	{
	-- 		source = { File = wezterm.config_dir .. "/space.jpg" },
	-- 	},
	-- 	{
	-- 		source = { Color = "#1A1B26" },
	-- 		height = "100%",
	-- 		width = "100%",
	-- 		opacity = 0.95,
	-- 	},
	-- },
}

-- Fonts
config.font_size = 18
config.font = wezterm.font_with_fallback({
	-- {
	-- 	family = "ComicShannsMono Nerd Font",
	-- 	scale = 1.1,
	-- 	weight = "Regular",
	-- },
	{
		family = "JetBrainsMono Nerd Font Mono",
		-- scale = 1.1,
		weight = "Regular",
	},
	{
		family = "JetBrains Mono",
		scale = 1.24,
		weight = "Medium",
	},
})

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

	-- Pane keybindings
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	-- We can make separate keybindings for resizing panes
	-- But Wezterm offers custom "mode" in the name of "KeyTable"
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
	},

	-- Tab keybindings
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },
	{ -- 编辑tab名称
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Key table for moving tabs around
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	-- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
	{ key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

	-- Lastly, workspace
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

-- event: update-status
config.status_update_interval = 1000
wezterm.on("update-status", function(window)
	local date = wezterm.strftime("%b %-d %H:%M ")

	window:set_right_status(wezterm.format({
		{ Text = " " },
		{ Foreground = { Color = "#74ECB5" } },
		{ Background = { Color = "rgba(0,0,50,0.9)" } },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = wezterm.nerdfonts.fa_calendar .. " " .. date },
		{ Text = " " },
	}))
end)

return config
