local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("graph", "widgets.cpu" , 42, {
  position = "right",
  graph = { color = colors.with_alpha(colors.white, 0.0) },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = {
    string = icons.cpu,
    color = colors.bubble.text,
  },
  label = {
    string = "cpu ??%",
    color = colors.bubble.text,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4
  },
  padding_right = settings.paddings + 6
})

cpu:subscribe("cpu_update", function(env)
  local load = tonumber(env.total_load)
  -- DEADLOCK FIX: Defer :set() and :push() calls
  sbar.delay(0.1, function()
    cpu:push({ load / 100. })
    cpu:set({
      label = "cpu " .. env.total_load .. "%",
    })
  end)
end)

cpu:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Bracket is created in items.right_bubble.lua for z-order control.

-- Background around the cpu item
sbar.add("item", "widgets.cpu.padding", {
  position = "right",
  width = 0
})
