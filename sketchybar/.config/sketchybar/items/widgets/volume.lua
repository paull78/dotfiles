local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local popup_width = 250

local volume_percent = sbar.add("item", "widgets.volume1", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "??%",
    color = colors.bubble.text,
    padding_left = -1,
    font = { family = settings.font.numbers }
  },
})

local volume_icon = sbar.add("item", "widgets.volume2", {
  position = "right",
  padding_right = -1,
  icon = {
    string = icons.volume._100,
    width = 0,
    align = "left",
    color = colors.bubble.text,
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
  },
  label = {
    width = 25,
    align = "left",
    color = colors.bubble.text,
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },
  },
  -- Popup attached to the item (not the bracket) so popup items keep their
  -- anchor when the bracket is created later in items.right_bubble.
  popup = { align = "center" },
})

-- Bracket is created in items.right_bubble.lua for z-order control.

sbar.add("item", "widgets.volume.padding", {
  position = "right",
  width = 0
})

local volume_slider = sbar.add("slider", popup_width, {
  position = "popup." .. volume_icon.name,
  slider = {
    highlight_color = colors.blue,
    background = {
      height = 6,
      corner_radius = 3,
      color = colors.bg2,
    },
    knob= {
      string = "􀀁",
      drawing = true,
    },
  },
  background = { color = colors.bg1, height = 2, y_offset = -20 },
  click_script = 'osascript -e "set volume output volume $PERCENTAGE"'
})

-- Track popup visibility locally to avoid :query() deadlock
local volume_popup_visible = false

volume_percent:subscribe("volume_change", function(env)
  local volume = tonumber(env.INFO)
  local icon = icons.volume._0
  if volume > 60 then
    icon = icons.volume._100
  elseif volume > 30 then
    icon = icons.volume._66
  elseif volume > 10 then
    icon = icons.volume._33
  elseif volume > 0 then
    icon = icons.volume._10
  end

  local lead = ""
  if volume < 10 then
    lead = "0"
  end

  -- DEADLOCK FIX: Defer :set() calls
  sbar.delay(0.1, function()
    volume_icon:set({ label = icon })
    volume_percent:set({ label = lead .. volume .. "%" })
    volume_slider:set({ slider = { percentage = volume } })
  end)
end)

local function volume_collapse_details()
  -- Use local state instead of :query() to avoid IPC deadlock
  if not volume_popup_visible then return end
  volume_popup_visible = false
  -- DEADLOCK FIX: Defer :set() call
  sbar.delay(0.1, function()
    volume_icon:set({ popup = { drawing = false } })
    sbar.remove('/volume.device\\.*/')
  end)
end

local current_audio_device = "None"
local function volume_toggle_details(env)
  if env.BUTTON == "right" then
    sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
    return
  end

  -- Use local state instead of :query() to avoid IPC deadlock
  if not volume_popup_visible then
    volume_popup_visible = true
    -- DEADLOCK FIX: Defer :set() call
    sbar.delay(0.1, function()
      volume_icon:set({ popup = { drawing = true } })
    end)
    sbar.exec("SwitchAudioSource -t output -c", function(result)
      current_audio_device = result:sub(1, -2)
      sbar.exec("SwitchAudioSource -a -t output", function(available)
        current = current_audio_device
        local color = colors.grey
        local counter = 0

        for device in string.gmatch(available, '[^\r\n]+') do
          local color = colors.grey
          if current == device then
            color = colors.white
          end
          sbar.add("item", "volume.device." .. counter, {
            position = "popup." .. volume_icon.name,
            width = popup_width,
            align = "center",
            label = { string = device, color = color },
            click_script = 'SwitchAudioSource -s "' .. device .. '" && sketchybar --set /volume.device\\.*/ label.color=' .. colors.grey .. ' --set $NAME label.color=' .. colors.white

          })
          counter = counter + 1
        end
      end)
    end)
  else
    volume_collapse_details()
  end
end

local function volume_scroll(env)
  local delta = env.INFO.delta
  if not (env.INFO.modifier == "ctrl") then delta = delta * 10.0 end

  sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

volume_icon:subscribe("mouse.clicked", volume_toggle_details)
volume_icon:subscribe("mouse.scrolled", volume_scroll)
volume_percent:subscribe("mouse.clicked", volume_toggle_details)
volume_percent:subscribe("mouse.exited.global", volume_collapse_details)
volume_percent:subscribe("mouse.scrolled", volume_scroll)

