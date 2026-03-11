local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
	display = "active",
	icon = { drawing = false },
	label = {
		color = colors.white,
		font = {
			style = settings.font.style_map["Black"],
			size = 12.0,
		},
		-- background = {
		-- 	color = colors.with_alpha(colors.bar.bg, 0.3),
		-- 	height = 26,
		-- },
	},
	updates = true,
})

front_app:subscribe("front_app_switched", function(env)
	-- DEADLOCK FIX: Defer :set() call
	sbar.delay(0.1, function()
		front_app:set({ label = { string = env.INFO } })
	end)
end)

front_app:subscribe("mouse.clicked", function(env)
	-- DEADLOCK FIX: Defer trigger call
	sbar.delay(0.1, function()
		sbar.trigger("swap_menus_and_spaces")
	end)
end)
