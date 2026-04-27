local colors = require("colors")
local settings = require("settings")

-- Spotify currently-playing widget. Polls Spotify via AppleScript every few
-- seconds; click to play/pause, right-click for next, scroll to skip.
-- Hides itself when Spotify is closed or stopped.

local SPOTIFY_GREEN = 0xff1ed760
local SPOTIFY_DIM   = 0xff5e6e5b
local SPOTIFY_BG    = 0xff1a1a1a

-- Items are added in REVERSE visual order: position="right" adds items from
-- right to left (last-added = leftmost). We want, going left-to-right:
-- [logo] [skip] [label] [padding spacer to right_bubble], so we add padding
-- first, label second, skip third, logo last.

-- Spacer between this widget and the right_bubble (rightmost in the group).
-- A `width` larger than the default item padding is needed because items
-- with no icon/label otherwise collapse to ~0 visual gap; we want a clear
-- breathing room between the two pills.
sbar.add("item", "spotify.padding", {
  position = "right",
  width = 30,
  drawing = false,
})

-- Label (track · artist). This item drives the periodic poll. We force
-- `updates = "on"` so the routine event keeps firing even when the widget
-- is hidden (Spotify closed) — otherwise launching Spotify later wouldn't
-- wake the widget back up.
local spotify_label = sbar.add("item", "spotify.label", {
  position = "right",
  scroll_texts = false,
  icon = { drawing = false },
  label = {
    string = "",
    color = colors.bubble.text,
    padding_right = 10,
    padding_left = 6,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 11.0,
    },
  },
  updates = "on",
  update_freq = 3,
  drawing = false,
})

-- Skip-forward button (next track). Sits between the logo and the label.
local spotify_skip = sbar.add("item", "spotify.skip", {
  position = "right",
  icon = {
    string = "\u{F051}",  -- nf-fa-step_forward
    color = SPOTIFY_GREEN,
    padding_left = 6,
    padding_right = 0,
    font = {
      family = "JetBrainsMono Nerd Font",
      style = "Regular",
      size = 11.0,
    },
  },
  label = { drawing = false },
  drawing = false,
})

-- Spotify logo (spotify green when playing, dim when paused).
-- Added last so it sits at the LEFT edge of the spotify bubble.
-- Uses Nerd Font's nf-fa-spotify glyph (U+F1BC).
local spotify_icon = sbar.add("item", "spotify.icon", {
  position = "right",
  icon = {
    string = "\u{F1BC}",  -- nf-fa-spotify
    color = SPOTIFY_GREEN,
    padding_left = 10,
    padding_right = 0,
    font = {
      family = "JetBrainsMono Nerd Font",
      style = "Bold",
      size = 14.0,
    },
  },
  label = { drawing = false },
  drawing = false,
})

-- Grouping bracket: dark pill with subtle Spotify-green border
sbar.add("bracket", "spotify.bracket", {
  spotify_icon.name,
  spotify_skip.name,
  spotify_label.name,
}, {
  background = {
    color = SPOTIFY_BG,
    border_color = SPOTIFY_GREEN,
    border_width = 2,  -- match the system bubble's cream border thickness
    corner_radius = 14,
    height = 30,
  }
})

-- AppleScript that returns "title|||artist|||state" or "|||...|||off|stopped"
local QUERY = [[osascript -e '
if application "Spotify" is running then
  tell application "Spotify"
    try
      if player state is not stopped then
        return (name of current track) & "|||" & (artist of current track) & "|||" & (player state as string)
      else
        return "|||" & "|||stopped"
      end if
    on error
      return "|||" & "|||error"
    end try
  end tell
else
  return "|||" & "|||off"
end if']]

local function set_visibility(visible)
  spotify_icon:set({ drawing = visible })
  spotify_skip:set({ drawing = visible })
  spotify_label:set({ drawing = visible })
  sbar.set("spotify.padding", { drawing = visible })
end

-- Truncate a string to `n` chars with an ellipsis if it overflows.
local function trunc(s, n)
  if not s then return "" end
  if #s <= n then return s end
  return s:sub(1, n - 1) .. "…"
end

local function update_spotify()
  sbar.exec(QUERY, function(result)
    -- Match three pipe-delimited fields, tolerating trailing whitespace.
    local title, artist, state = result:match("^(.-)|||(.-)|||(.-)%s*$")
    if not state then return end

    sbar.delay(0.1, function()
      if state == "off" or state == "stopped" or state == "error" then
        set_visibility(false)
        return
      end

      local label_text = trunc(title, 24)
      if artist and artist ~= "" then
        label_text = trunc(title, 22) .. " · " .. trunc(artist, 16)
      end
      local playing = state == "playing"

      set_visibility(true)
      local accent = playing and SPOTIFY_GREEN or SPOTIFY_DIM
      spotify_icon:set({ icon = { color = accent } })
      spotify_skip:set({ icon = { color = accent } })
      spotify_label:set({
        label = {
          string = label_text,
          color = playing and colors.bubble.text or SPOTIFY_DIM,
        },
      })
    end)
  end)
end

-- Periodic poll (driven by spotify_label's update_freq=3)
spotify_label:subscribe({ "routine", "forced", "system_woke" }, function()
  update_spotify()
end)

-- Click handlers: left = play/pause, right = next track
local function click_handler(env)
  local cmd
  if env.BUTTON == "right" then
    cmd = [[osascript -e 'tell application "Spotify" to next track']]
  else
    cmd = [[osascript -e 'tell application "Spotify" to playpause']]
  end
  sbar.exec(cmd, function() end)
  -- Refresh state shortly after the action lands
  sbar.delay(0.4, update_spotify)
end

-- Scroll: up/right = next, down/left = previous
local function scroll_handler(env)
  local delta = env.INFO and env.INFO.delta or 0
  local cmd
  if delta > 0 then
    cmd = [[osascript -e 'tell application "Spotify" to next track']]
  else
    cmd = [[osascript -e 'tell application "Spotify" to previous track']]
  end
  sbar.exec(cmd, function() end)
  sbar.delay(0.4, update_spotify)
end

spotify_icon:subscribe("mouse.clicked", click_handler)
spotify_label:subscribe("mouse.clicked", click_handler)
spotify_icon:subscribe("mouse.scrolled", scroll_handler)
spotify_label:subscribe("mouse.scrolled", scroll_handler)

-- Skip button: dedicated next-track click. Scroll on it acts like the rest.
spotify_skip:subscribe("mouse.clicked", function(env)
  sbar.exec([[osascript -e 'tell application "Spotify" to next track']], function() end)
  sbar.delay(0.4, update_spotify)
end)
spotify_skip:subscribe("mouse.scrolled", scroll_handler)

-- Initial poll so we don't wait 3s for first render
update_spotify()
