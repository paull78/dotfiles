local settings = require("settings")
local colors = require("colors")

-- Right-edge anchor: must be added BEFORE calendar.cal so it sits at the
-- absolute rightmost slot. Sketchybar brackets struggle to bound the very
-- last item in the bar; pinning a 1px sentinel here lets the right_bubble
-- bracket reliably extend through calendar.cal.
sbar.add("item", "right_edge_anchor", {
  position = "right",
  width = 1,
  background = { drawing = false },
})

local cal = sbar.add("item", "calendar.cal", {
  icon = {
    color = colors.bubble.text,
    padding_left = 8,
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  label = {
    color = colors.bubble.text,
    padding_right = 8,
    width = 49,
    align = "right",
    font = { family = settings.font.numbers },
  },
  position = "right",
  update_freq = 30,
  padding_left = 1,
  padding_right = 1,
  background = { drawing = false },
  click_script = "open -a 'Calendar'"
})

-- Bracket is created in items.right_bubble.lua for z-order control.

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  local icon = os.date("%a. %d %b.")
  local label = os.date("%H:%M")
  -- DEADLOCK FIX: Defer :set() call
  sbar.delay(0.1, function()
    cal:set({ icon = icon, label = label })
  end)
end)
