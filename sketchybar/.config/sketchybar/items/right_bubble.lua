local colors = require("colors")

-- Right-side single-bubble layout.
--
-- Strategy: a teal "fill" bracket sits at the bottom of the z-stack, providing
-- a continuous tinted backdrop that matches the leftmost segment (CPU). When
-- inner brackets are drawn on top with corner_radius=0, their flat edges
-- naturally butt against each other; any pixel-level gap from CPU's rounded
-- right corner exposes the teal fill underneath, which matches CPU and is
-- visually invisible.
--
-- Calendar (rightmost) has corner_radius=14 to provide the right rounded
-- corner in blue. Its left rounded corner exposes the teal fill — a small
-- cosmetic compromise, but the slivers are tiny against blue.
--
-- The cream border is a separate outer bracket drawn last, so the border
-- sits on top of all colored fills.

local member_items = {
  "calendar.cal",
  "widgets.battery",
  "widgets.battery.padding",
  "widgets.volume1",
  "widgets.volume2",
  "widgets.volume.padding",
  "widgets.wifi.padding",
  "widgets.wifi1",
  "widgets.wifi2",
  "widgets.wifi.outer_padding",
  "widgets.cpu",
  "widgets.cpu.padding",
}

-- 0. Outer fill: teal backdrop. Drawn first so all inner brackets paint over.
sbar.add("bracket", "right_bubble.fill", member_items, {
  background = {
    color = colors.bubble.cpu,
    border_width = 0,
    corner_radius = 14,
    height = 30,
  }
})

-- 1. Wifi (purple, flat).
sbar.add("bracket", "widgets.wifi.bracket", {
  "widgets.wifi.padding",
  "widgets.wifi1",
  "widgets.wifi2",
}, {
  background = {
    color = colors.bubble.network,
    border_width = 0,
    corner_radius = 0,
    height = 30,
  }
})

-- 2. Volume (salmon, flat).
sbar.add("bracket", "widgets.volume.bracket", {
  "widgets.volume2",
  "widgets.volume1",
}, {
  background = {
    color = colors.bubble.volume,
    border_width = 0,
    corner_radius = 0,
    height = 30,
  }
})

-- 3. Battery (orange, flat).
sbar.add("bracket", "widgets.battery.bracket", { "widgets.battery" }, {
  background = {
    color = colors.bubble.battery,
    border_width = 0,
    corner_radius = 0,
    height = 30,
  }
})

-- 4. Calendar (blue, rounded right corner).
sbar.add("bracket", "calendar.bracket", { "calendar.cal" }, {
  background = {
    color = colors.bubble.time,
    border_width = 0,
    corner_radius = 14,
    height = 30,
  }
})

-- 5. Outer border: drawn last so cream border sits on top of all fills.
sbar.add("bracket", "right_bubble", member_items, {
  background = {
    color = colors.transparent,
    border_color = colors.bubble.border,
    border_width = 2,
    corner_radius = 14,
    height = 30,
  }
})
