-- WezTerm Keybindings Documentation by dragonlobster
-- ===================================================
-- Leader Key:
-- The leader key is set to ALT + q, with a timeout of 2000 milliseconds (2 seconds).
-- To execute any keybinding, press the leader key (ALT + q) first, then the corresponding key.

-- Keybindings:
-- 1. Tab Management:
--    - LEADER + c: Create a new tab in the current pane's domain.
--    - LEADER + x: Close the current pane (with confirmation).
--    - LEADER + b: Switch to the previous tab.
--    - LEADER + n: Switch to the next tab.
--    - LEADER + <number>: Switch to a specific tab (0–9).
-- 2. Status Line:
--    - The status line indicates when the leader key is active, displaying a crab emoji.

-- Miscellaneous Configurations:
-- - Tabs are shown even if there's only one tab.
-- - The tab bar is located at the bottom of the terminal window.
-- - Tab and split indices are zero-based.

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- max fps
config.max_fps = 60
config.animation_fps = 60
--[[
============================
Custom Configuration
============================
]]
--
-- for random leader key prefix text generator later
math.randomseed(os.time())
-- change to square if you don't like rounded tab style
local tab_style = "square"

-- use ps7
config.default_prog = { "pwsh.exe", "-NoLogo" }

config.window_close_confirmation = "NeverPrompt"

-- leader active indicator prefix
local leader_prefix = "🦀"
local leader_prefix_text_choices = {
	"extra rust larp",
	"extra linux larp",
	"hi nerrader",
	"hi cookie monster",
	"ok leader key",
	"i hate writing nvim configs",
	"qt sucks",
	"have you done today's wordle",
	"woi asteya",
	"sing legato",
	"meow for me",
	"good boy",
	"flicks are impossible",
	"future funk 99%",
	"you're never beating destinias",
}

config.background = {
	{
		source = {
			File = wezterm.config_dir .. '/bg.jpg',
		},
		hsb = { brightness = 0.05 },
	},
}
--[[
============================
Font
============================
]]
--

config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 14

config.window_decorations = "RESIZE"

--[[
============================
Colors
============================
]]
--

local color_scheme = "Catppuccin Macchiato"
config.color_scheme = color_scheme

-- color_scheme not sufficient in providing available colors
-- local colors = wezterm.color.get_builtin_schemes()[color_scheme]

-- color scheme colors for easy access
local scheme_colors = {
	catppuccin = {
		macchiato = {
			rosewater = "f4dbd6",
			flamingo = "f0c6c6",
			pink = "f5bde6",
			mauve = "c6a0f6",
			red = "ed8796",
			maroon = "ee99a0",
			peach = "#f5a97f",
			yellow = "#eed49f",
			green = "#a6da95",
			teal = "#8bd5ca",
			sky = "#91d7e3",
			sapphire = "#7dc4e4",
			blue = "#8aadf4",
			lavender = "#b7bdf8",
			text = "#cad3f5",
			crust = "#181926",
		},
	},
}

local colors = {
	border = scheme_colors.catppuccin.macchiato.lavender,
	tab_bar_active_tab_fg = scheme_colors.catppuccin.macchiato.mauve,
	tab_bar_active_tab_bg = scheme_colors.catppuccin.macchiato.crust,
	tab_bar_text = scheme_colors.catppuccin.macchiato.crust,
	leader_prefix_background = "#333333", -- the same color as my taskbar
	leader_prefix_foreground = scheme_colors.catppuccin.macchiato.text,
}

--[[
============================
Border
============================
]]
--

config.window_frame = {
	border_left_width = "0.4cell",
	border_right_width = "0.4cell",
	border_bottom_height = "0.15cell",
	border_top_height = "0.15cell",
	border_left_color = colors.border,
	border_right_color = colors.border,
	border_bottom_color = colors.border,
	border_top_color = colors.border,
}

--[[
============================
Shortcuts
============================
]]
--

-- shortcut_configuration
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 500 }
config.keys = {
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "d",
		action = wezterm.action.CloseCurrentTab { confirm = false },
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "q",
		action = wezterm.action.QuitApplication,
	},
}

--[[
============================
Tab Bar
============================
]]
--

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true
config.tab_and_split_indices_are_zero_based = true

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = " " .. tab.tab_index .. ": " .. tab_title(tab) .. " "
	local left_edge_text = ""
	local right_edge_text = ""

	if tab_style == "rounded" then
		title = tab.tab_index .. ": " .. tab_title(tab)
		title = wezterm.truncate_right(title, max_width - 2)
		left_edge_text = wezterm.nerdfonts.ple_left_half_circle_thick
		right_edge_text = wezterm.nerdfonts.ple_right_half_circle_thick
	end

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	-- title = wezterm.truncate_right(title, max_width - 2)

	if tab.is_active then
		return {
			{ Background = { Color = colors.tab_bar_active_tab_bg } },
			{ Foreground = { Color = colors.tab_bar_active_tab_fg } },
			{ Text = left_edge_text },
			{ Background = { Color = colors.tab_bar_active_tab_fg } },
			{ Foreground = { Color = colors.tab_bar_text } },
			{ Text = title },
			{ Background = { Color = colors.tab_bar_active_tab_bg } },
			{ Foreground = { Color = colors.tab_bar_active_tab_fg } },
			{ Text = right_edge_text },
		}
	end
end)

--[[
============================
Leader Active Indicator
============================
]]
--

wezterm.on("update-status", function(window, _)
	if window:leader_is_active() then
		local random_prefix_quote = leader_prefix_text_choices[math.random(#leader_prefix_text_choices)]
		window:set_left_status(wezterm.format({
			{ Background = { Color = colors.leader_prefix_background } },
			{ Foreground = { Color = colors.leader_prefix_foreground } },
			{ Text = " " .. leader_prefix .. random_prefix_quote .. " " },
		}))
	else
		window:set_left_status("")
	end
end)
-- wezterm.on("format-tab-title", function(tab, _, _, _, _)
-- 	local title = tab.active_pane.title
--
-- 	title = title:gsub("C:\\Users\\[^\\]+", "~")
--
-- 	return title
-- end)
-- and finally, return the configuration to wezterm
return config
