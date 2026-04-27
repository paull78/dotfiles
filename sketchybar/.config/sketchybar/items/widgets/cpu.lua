local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

-- Graph colour tiers. CPU load thresholds: < 50% = calm white, 50-80% = amber
-- (notable load), >= 80% = red (spike). Tints are translucent so the teal
-- bracket still shows through for a soft, readable look.
local function with_alpha(c, a)
  -- 0xRRGGBB → 0xAARRGGBB (helper around colors.with_alpha that takes a base
  -- 0xRRGGBB literal so we can express the tier colours inline below).
  return colors.with_alpha(0xff000000 + c, a)
end
local CPU_COLOR_LOW    = with_alpha(0xffffff, 0.55)  -- soft white
local CPU_COLOR_MEDIUM = with_alpha(0xffd06a, 0.85)  -- warm amber
local CPU_COLOR_HIGH   = with_alpha(0xff5e5e, 0.95)  -- red

local function tier_for(load)
  if load >= 80 then return CPU_COLOR_HIGH end
  if load >= 50 then return CPU_COLOR_MEDIUM end
  return CPU_COLOR_LOW
end

-- CPU widget. A sparkline graph of CPU load drawn behind the icon+label,
-- with the label overlaid right-aligned over the graph area. The graph
-- colour shifts from white → amber → red as load climbs, so spikes pop
-- out at a glance.
local cpu = sbar.add("graph", "widgets.cpu" , 42, {
  position = "right",
  graph = { color = CPU_COLOR_LOW },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = {
    string = icons.cpu,
    color = colors.bubble.text,
    padding_left = 6,
  },
  label = {
    string = "cpu ??%",
    color = colors.bubble.text,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    -- align=right + width=0 makes the label overlay the right edge of the
    -- graph area instead of taking horizontal space of its own.
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
  },
  padding_right = settings.paddings + 6,
})

cpu:subscribe("cpu_update", function(env)
  local load = tonumber(env.total_load) or 0
  -- DEADLOCK FIX: Defer :set() and :push() calls
  sbar.delay(0.1, function()
    cpu:push({ load / 100. })
    cpu:set({
      label = "cpu " .. env.total_load .. "%",
      graph = { color = tier_for(load) },
    })
  end)
end)

cpu:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Bracket is created in items.right_bubble.lua for z-order control.

-- Spacer used by the right_bubble to anchor segment boundaries.
sbar.add("item", "widgets.cpu.padding", {
  position = "right",
  width = 0
})
