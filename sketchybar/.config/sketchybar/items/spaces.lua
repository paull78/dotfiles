local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

for i = 1, 12, 1 do
	local space = sbar.add("space", "space." .. i, {
		space = i,
		icon = {
			font = { family = settings.font.numbers },
			string = i,
			padding_left = 15,
			padding_right = 8,
			color = colors.white,
			highlight_color = colors.red,
		},
		label = {
			padding_right = 20,
			color = colors.grey,
			highlight_color = colors.white,
			font = "sketchybar-app-font:Regular:16.0",
			y_offset = -1,
		},
		padding_right = 1,
		padding_left = 1,
		background = {
			color = colors.bg1,
			border_width = 1,
			height = 26,
			border_color = colors.black,
		},
		popup = { background = { border_width = 5, border_color = colors.black } },
	})

	spaces[i] = space

	-- Single item bracket for space items to achieve double border on highlight
	local space_bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = colors.bg2,
			height = 28,
			border_width = 2,
		},
	})

	-- Padding space
	sbar.add("space", "space.padding." .. i, {
		space = i,
		script = "",
		width = settings.group_paddings,
	})

	local space_popup = sbar.add("item", {
		position = "popup." .. space.name,
		padding_left = 5,
		padding_right = 0,
		background = {
			drawing = true,
			image = {
				corner_radius = 9,
				scale = 0.2,
			},
		},
	})

	space:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		local color = selected and colors.grey or colors.bg2
		-- DEADLOCK FIX: Defer :set() calls
		sbar.delay(0.1, function()
			space:set({
				icon = { highlight = selected },
				label = { highlight = selected },
				background = { border_color = selected and colors.black or colors.bg2 },
			})
			space_bracket:set({
				background = { border_color = selected and colors.grey or colors.bg2 },
			})
		end)
	end)

	-- space:subscribe("mouse.clicked", function(env)
	-- 	if env.BUTTON == "other" then
	-- 		space_popup:set({ background = { image = "space." .. env.SID } })
	-- 		space:set({ popup = { drawing = "toggle" } })
	-- 	else
	-- 		local op = (env.BUTTON == "right") and "--destroy" or "--focus"
	-- 		sbar.exec("yabai -m space " .. op .. " " .. env.SID)
	-- 	end
	-- end)
	--
	space:subscribe("mouse.clicked", function(env)
		if env.BUTTON == "other" then
			sbar.delay(0.1, function()
				space_popup:set({ background = { image = "space." .. env.NAME } })
				space:set({ popup = { drawing = "toggle" } })
			end)
		else
			-- Yabai space focus needs the scripting-addition (partial SIP disable),
			-- which isn't installed here. Falling back to sending macOS keyboard
			-- shortcuts (System Settings → Keyboard → Shortcuts → Mission Control →
			-- "Switch to Desktop N"). Destroy is intentionally not wired.
			local keycodes = {
				[1] = 18, [2] = 19, [3] = 20, [4] = 21,
				[5] = 23, [6] = 22, [7] = 26, [8] = 28,
				[9] = 25, [10] = 29,
				-- [11], [12]: add their keycodes once bound in macOS Settings
			}
			local idx = tonumber(env.NAME:match("space%.(%d+)$"))
			local keycode = idx and keycodes[idx]
			if keycode then
				sbar.exec(string.format(
					"osascript -e 'tell application \"System Events\" to key code %d using control down'",
					keycode
				))
			end
		end
	end)

	space:subscribe("mouse.exited", function(_)
		-- DEADLOCK FIX: Defer :set() call
		sbar.delay(0.1, function()
			space:set({ popup = { drawing = false } })
		end)
	end)
end

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

-- Collapse per-space app-icon labels when any connected display is narrow
-- (typically the laptop's built-in). Decision uses the *minimum* width across
-- all displays, not the active one — otherwise moving the mouse to a wide
-- external would re-expand labels on the laptop bar too.
-- Note: sketchybar applies item state globally across bars, so when both a
-- narrow and wide display are connected, both bars lose labels.
local NARROW_WIDTH_THRESHOLD = 1800

local function apply_space_label_visibility()
	sbar.exec(
		"yabai -m query --displays 2>/dev/null | "
			.. "python3 -c 'import sys,json; "
			.. "print(int(min(d[\"frame\"][\"w\"] for d in json.load(sys.stdin))))' "
			.. "2>/dev/null",
		function(width_str)
			local width = tonumber(width_str)
			-- If we can't determine width, fail open: show labels.
			local show = width == nil or width >= NARROW_WIDTH_THRESHOLD
			for _, sp in ipairs(spaces) do
				sp:set({ label = { drawing = show } })
			end
		end
	)
end

-- Initial evaluation, then re-evaluate on display change.
sbar.delay(0.2, apply_space_label_visibility)

local display_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})
display_observer:subscribe("display_change", function(_)
	sbar.delay(0.1, apply_space_label_visibility)
end)

local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = 0,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

-- Track spaces mode locally to avoid :query() deadlock
local spaces_mode_on = true

space_window_observer:subscribe("space_windows_change", function(env)
	local icon_line = ""
	local no_app = true
	for app, count in pairs(env.INFO.apps) do
		no_app = false
		local lookup = app_icons[app]
		local icon = ((lookup == nil) and app_icons["Default"] or lookup)
		icon_line = icon_line .. icon
	end

	if no_app then
		icon_line = " —"
	end
	-- DEADLOCK FIX: Defer the :set() call to the next event loop cycle
	-- This breaks the synchronous IPC chain that was causing deadlock:
	-- sketchybar -> lua (space_windows_change) -> sketchybar (:set) -> waiting...
	local space_idx = env.INFO.space
	if space_idx and spaces[space_idx] then
		sbar.delay(0.1, function()
			spaces[space_idx]:set({ label = icon_line })
		end)
	end
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	-- Use local state instead of :query() to avoid IPC deadlock
	spaces_mode_on = not spaces_mode_on
	-- DEADLOCK FIX: Defer :set() call
	sbar.delay(0.1, function()
		spaces_indicator:set({
			icon = spaces_mode_on and icons.switch.on or icons.switch.off,
		})
	end)
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	-- Removed animation wrapper to prevent IPC deadlock
	-- DEADLOCK FIX: Defer :set() call
	sbar.delay(0.1, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	-- Removed animation wrapper to prevent IPC deadlock
	-- DEADLOCK FIX: Defer :set() call
	sbar.delay(0.1, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	-- DEADLOCK FIX: Defer trigger call
	sbar.delay(0.1, function()
		sbar.trigger("swap_menus_and_spaces")
	end)
end)
