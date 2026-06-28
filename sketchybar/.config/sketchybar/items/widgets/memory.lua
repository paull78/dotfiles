local colors = require("colors")
local settings = require("settings")

-- Memory widget. Mirrors cpu.lua and gpu.lua exactly: a sparkline graph
-- behind the icon+label with load-tier colour shifts (white < 50%, amber
-- 50-80%, red >= 80%). Memory pressure is calculated Activity Monitor-
-- style: (active + wired + compressed) / total. This matches the "Memory
-- Used" figure in Activity Monitor and is the most useful single number
-- for "am I about to swap?".
--
-- Polled via vm_stat | awk every 2s. Sub-5ms cost per poll.

-- Total physical memory in bytes. Read once at module load — it never
-- changes and we don't want to re-query it on every poll.
local function exec_capture(cmd)
  local handle = io.popen(cmd)
  if not handle then return nil end
  local out = handle:read("*a")
  handle:close()
  return out
end

local TOTAL_MEM = tonumber((exec_capture("sysctl -n hw.memsize") or ""):match("(%d+)")) or 0

-- Shell command: parse vm_stat output and emit just the integer percentage.
-- The page size and TOTAL_MEM are baked into the awk command at module load.
-- Robust to localized vm_stat output by detecting `page size of N` from the
-- header line.
local MEM_QUERY = string.format(
  "vm_stat | awk -v total=%d '"
  .. "BEGIN {ps=16384} "
  .. "/page size of/ {gsub(/[)]/,\"\",$8); ps=$8} "
  .. "/^Pages active:/ {gsub(/\\./,\"\",$3); a=$3} "
  .. "/^Pages wired down:/ {gsub(/\\./,\"\",$4); w=$4} "
  .. "/^Pages occupied by compressor:/ {gsub(/\\./,\"\",$5); c=$5} "
  .. "END {if (total>0) printf \"%%d\\n\", (a+w+c)*ps*100/total; else print 0}'",
  TOTAL_MEM
)

-- Graph colour tiers — same thresholds and palette as cpu.lua / gpu.lua so
-- the three widgets read consistently at a glance.
local function with_alpha(c, a)
  return colors.with_alpha(0xff000000 + c, a)
end
local MEM_COLOR_LOW    = with_alpha(0xffffff, 0.55)  -- soft white
local MEM_COLOR_MEDIUM = with_alpha(0xffd06a, 0.85)  -- warm amber
local MEM_COLOR_HIGH   = with_alpha(0xff5e5e, 0.95)  -- red

local function tier_for(load)
  if load >= 80 then return MEM_COLOR_HIGH end
  if load >= 50 then return MEM_COLOR_MEDIUM end
  return MEM_COLOR_LOW
end

-- Icon: nf-md-memory from JetBrainsMono Nerd Font. Material Design's
-- memory glyph reads as a chip with pins, visually paired with the cpu
-- chip glyph and the gpu graphics-card glyph.
local memory = sbar.add("graph", "widgets.memory", 42, {
  position = "right",
  graph = { color = MEM_COLOR_LOW },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = {
    string = "\u{F035B}",  -- nf-md-memory
    color = colors.bubble.text,
    padding_left = 6,
    font = {
      family = "JetBrainsMono Nerd Font",
      style = "Bold",
      size = 13.0,
    },
  },
  label = {
    string = "mem ??%",
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
  -- Lua-driven polling. updates="on" keeps polling even if the item is
  -- briefly hidden during bracket churn.
  updates = "on",
  update_freq = 2,
})

local function update_memory()
  sbar.exec(MEM_QUERY, function(result)
    -- result is a string with the integer percentage; tolerate empty / odd
    -- output by clamping to [0, 100].
    local s = tostring(result):match("(%-?%d+)") or "0"
    local load = tonumber(s) or 0
    if load < 0 then load = 0 end
    if load > 100 then load = 100 end
    sbar.delay(0.05, function()
      memory:push({ load / 100. })
      memory:set({
        label = "mem " .. load .. "%",
        graph = { color = tier_for(load) },
      })
    end)
  end)
end

memory:subscribe({ "routine", "forced", "system_woke" }, function() update_memory() end)
memory:subscribe("mouse.clicked", function()
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Bracket is created in items.right_bubble.lua for z-order control.

-- Initial render so we don't wait for the first poll.
update_memory()
