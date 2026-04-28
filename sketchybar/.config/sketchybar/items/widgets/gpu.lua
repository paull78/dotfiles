local colors = require("colors")
local settings = require("settings")

-- GPU widget. Mirrors the CPU widget exactly: a sparkline graph behind the
-- icon+label with load-tier colour shifts (white < 50%, amber 50-80%, red
-- >= 80%). On Apple Silicon, IOKit's IOAccelerator class exposes per-device
-- "Device Utilization %" through ioreg without root, so we just shell out
-- and parse it every 2s. Sub-20ms cost per query.

-- Shell command: parse the first "Device Utilization %" value from ioreg.
-- The IOAccelerator dictionary may contain multiple PerformanceStatistics
-- blocks on multi-GPU machines; `exit` after the first match keeps it
-- cheap and consistent.
local GPU_QUERY = "ioreg -r -d 1 -w 0 -c IOAccelerator | "
               .. "awk -F'\"Device Utilization %\"=' "
               .. "'NF>1 {split($2,a,\",\"); print a[1]+0; exit}'"

-- Graph colour tiers — same thresholds and palette as cpu.lua so the two
-- widgets read consistently at a glance.
local function with_alpha(c, a)
  return colors.with_alpha(0xff000000 + c, a)
end
local GPU_COLOR_LOW    = with_alpha(0xffffff, 0.55)  -- soft white
local GPU_COLOR_MEDIUM = with_alpha(0xffd06a, 0.85)  -- warm amber
local GPU_COLOR_HIGH   = with_alpha(0xff5e5e, 0.95)  -- red

local function tier_for(load)
  if load >= 80 then return GPU_COLOR_HIGH end
  if load >= 50 then return GPU_COLOR_MEDIUM end
  return GPU_COLOR_LOW
end

-- Icon: nf-md-expansion_card from JetBrainsMono Nerd Font (graphics-card
-- glyph). SF Symbols has no GPU-specific glyph, so we use Nerd Font here
-- the same way spotify.lua does for its logo.
local gpu = sbar.add("graph", "widgets.gpu", 42, {
  position = "right",
  graph = { color = GPU_COLOR_LOW },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = {
    string = "\u{F08AE}",  -- nf-md-expansion_card
    color = colors.bubble.text,
    padding_left = 6,
    font = {
      family = "JetBrainsMono Nerd Font",
      style = "Bold",
      size = 13.0,
    },
  },
  label = {
    string = "gpu ??%",
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
  -- Lua-driven polling (no separate event provider binary like cpu_load).
  -- update_freq drives the routine event; updates="on" keeps polling even
  -- if the item is briefly hidden during bracket churn.
  updates = "on",
  update_freq = 2,
})

local function update_gpu()
  sbar.exec(GPU_QUERY, function(result)
    -- result is a string with the integer percentage; tolerate empty / odd
    -- output by clamping to [0, 100].
    local s = tostring(result):match("(%-?%d+)") or "0"
    local load = tonumber(s) or 0
    if load < 0 then load = 0 end
    if load > 100 then load = 100 end
    sbar.delay(0.05, function()
      gpu:push({ load / 100. })
      gpu:set({
        label = "gpu " .. load .. "%",
        graph = { color = tier_for(load) },
      })
    end)
  end)
end

gpu:subscribe({ "routine", "forced", "system_woke" }, function() update_gpu() end)
gpu:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Bracket is created in items.right_bubble.lua for z-order control.

-- Initial render so we don't wait for the first poll.
update_gpu()
