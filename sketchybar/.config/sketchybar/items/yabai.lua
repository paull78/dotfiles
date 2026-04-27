local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Yabai space-layout indicator. Shows the current space's layout (bsp/stack/
-- float) inside a coloured pill, plus a row of app icons for every app with
-- a window in the current space — so you can see at a glance what's about
-- to be tiled / stacked / floated. Click cycles the layout.
--
-- Polled every couple of seconds AND on space_change/space_windows_change
-- so it updates promptly when you switch spaces or open/close windows.

local YABAI_BG    = 0xff1a1a1a
local TILE_COLOR  = 0xff5e9bd6  -- soft blue
local STACK_COLOR = 0xffd6a35e  -- amber
local FLOAT_COLOR = 0xff9aa5b5  -- muted grey

-- Items added in REVERSE visual order: padding first (rightmost = closest
-- to spotify bubble), label last (leftmost in the group).

-- Spacer between this widget and the spotify bubble. Width=6 matches the
-- visible gap between the spotify and system bubbles, which is determined
-- by their natural bracket padding (the right_bubble's leftward bracket
-- padding swallows most of spotify.padding's nominal 30px). Keeping all
-- inter-bubble gaps the same for visual consistency.
sbar.add("item", "yabai.padding", {
  position = "right",
  width = 6,
  drawing = false,
})

-- App-icons row. Shows one glyph per app with a window in the current
-- space, in sketchybar-app-font (same font your /spaces/ widget uses).
-- The label is set dynamically by update_apps(); icon side is unused.
local yabai_apps = sbar.add("item", "yabai.apps", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "",
    color = colors.bubble.text,
    padding_left = 4,
    padding_right = 12,
    font = "sketchybar-app-font:Regular:14.0",
    y_offset = -1,
  },
  drawing = false,
})

-- Layout glyph. The click target and the indicator of the current layout.
-- `updates = "on"` keeps the routine firing even while hidden, so the
-- widget can come back if yabai/the space starts reporting again.
-- Icon uses Nerd Font glyphs (Font Awesome): the icon string is set
-- dynamically by update_yabai().
local yabai_layout = sbar.add("item", "yabai.layout", {
  position = "right",
  icon = {
    string = "\u{F009}",  -- nf-fa-th_large (2x2 grid) — placeholder for bsp
    color = TILE_COLOR,
    padding_left = 6,
    padding_right = 4,
    font = {
      family = "JetBrainsMono Nerd Font",
      style = "Bold",
      size = 13.0,
    },
  },
  label = { drawing = false },
  updates = "on",
  update_freq = 2,
  drawing = false,
})

-- Brand label "yabai" sitting to the left of the layout glyph. Tinted to
-- match the active layout's accent so the bubble feels visually unified.
-- Added LAST among the right-positioned items so it ends up leftmost in
-- the visual order: [yabai brand] [layout glyph] [padding].
local yabai_brand = sbar.add("item", "yabai.brand", {
  position = "right",
  icon = {
    string = "yabai",
    color = TILE_COLOR,
    padding_left = 12,
    padding_right = 0,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 11.0,
    },
  },
  label = { drawing = false },
  drawing = false,
})

-- Bracket: dark pill with a coloured border that tracks the active layout.
sbar.add("bracket", "yabai.bracket", {
  yabai_brand.name,
  yabai_layout.name,
  yabai_apps.name,
}, {
  background = {
    color = YABAI_BG,
    border_color = TILE_COLOR,
    border_width = 2,
    corner_radius = 14,
    height = 30,
  }
})

-- Path to the yabai binary. sketchybar is launched by brew services with a
-- minimal PATH that often doesn't include /opt/homebrew/bin, so spell it out.
local YABAI = "/opt/homebrew/bin/yabai"

-- Map a yabai layout name to (Nerd Font glyph, accent colour). Glyphs are
-- drawn from Font Awesome (always present in Nerd Fonts):
--   bsp   → th-large (2x2 grid) — represents tiled regions
--   stack → bars            — horizontal lines for stacked windows
--   float → clone           — two overlapping squares for floaters
local function style_for(layout)
  if layout == "bsp"   then return "\u{F009}", TILE_COLOR  end  -- nf-fa-th_large
  if layout == "stack" then return "\u{F0C9}", STACK_COLOR end  -- nf-fa-bars
  if layout == "float" then return "\u{F24D}", FLOAT_COLOR end  -- nf-fa-clone
  return "?", FLOAT_COLOR
end

local function set_visibility(visible)
  yabai_brand:set({ drawing = visible })
  yabai_layout:set({ drawing = visible })
  yabai_apps:set({ drawing = visible })
  sbar.set("yabai.padding", { drawing = visible })
end

-- Build the app-icon string from a list of windows. Dedupes apps (one glyph
-- per unique app), maps each through helpers/app_icons, falls back to the
-- "Default" glyph when an app isn't in the map.
local function icons_for_windows(windows)
  if not windows or #windows == 0 then return "" end
  local seen, out = {}, {}
  for _, w in ipairs(windows) do
    local app = w.app
    if app and not seen[app] then
      seen[app] = true
      local glyph = app_icons[app] or app_icons["Default"] or ""
      out[#out + 1] = glyph
    end
  end
  return table.concat(out, " ")
end

local function update_apps()
  sbar.exec(YABAI .. " -m query --windows --space 2>/dev/null", function(result)
    local windows
    if type(result) == "table" then
      windows = result
    end
    local icon_line = icons_for_windows(windows)
    sbar.delay(0.05, function()
      yabai_apps:set({ label = { string = icon_line } })
    end)
  end)
end

local function update_yabai()
  sbar.exec(YABAI .. " -m query --spaces --space 2>/dev/null", function(result)
    -- sbar.exec auto-parses JSON output into a Lua table; handle both cases.
    local layout
    if type(result) == "table" then
      layout = result.type
    elseif type(result) == "string" then
      layout = result:match('"type"%s*:%s*"([^"]+)"')
    end
    if not layout or layout == "" then
      sbar.delay(0.05, function() set_visibility(false) end)
      return
    end
    local glyph, color = style_for(layout)
    sbar.delay(0.05, function()
      set_visibility(true)
      yabai_layout:set({ icon = { string = glyph, color = color } })
      yabai_brand:set({ icon = { color = color } })
      sbar.set("yabai.bracket", { background = { border_color = color } })
    end)
    -- Also refresh the app icons whenever we refresh the layout.
    update_apps()
  end)
end

-- Update on periodic poll, on macOS space changes, and on wake.
yabai_layout:subscribe(
  { "routine", "forced", "system_woke", "space_change", "front_app_switched" },
  function() update_yabai() end
)

-- App icons refresh independently when windows open/close in any space —
-- this fires for every space, but we always show whatever's in the focused
-- one, so a re-query is the simplest correct response.
yabai_apps:subscribe(
  { "space_change", "space_windows_change", "front_app_switched" },
  function() update_apps() end
)

-- Click: cycle layouts bsp → stack → float → bsp …
local CYCLE = { bsp = "stack", stack = "float", float = "bsp" }

-- Click on either the brand text or the layout glyph cycles the layout.
local function cycle_layout()
  sbar.exec(YABAI .. " -m query --spaces --space 2>/dev/null", function(result)
    local layout
    if type(result) == "table" then
      layout = result.type
    elseif type(result) == "string" then
      layout = result:match('"type"%s*:%s*"([^"]+)"')
    end
    local next_layout = CYCLE[layout] or "bsp"
    sbar.exec(YABAI .. " -m space --layout " .. next_layout, function() end)
    sbar.delay(0.15, update_yabai)
  end)
end

yabai_layout:subscribe("mouse.clicked", cycle_layout)
yabai_brand:subscribe("mouse.clicked", cycle_layout)

-- Initial render so we don't wait for the first poll.
update_yabai()
