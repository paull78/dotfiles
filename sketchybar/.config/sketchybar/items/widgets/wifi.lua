local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "network_update"
-- for the network interface "en0", which is fired every 2.0 seconds.
sbar.exec("killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0")

local popup_width = 250

local wifi_up = sbar.add("item", "widgets.wifi1", {
  position = "right",
  padding_left = -5,
  width = 0,
  icon = {
    padding_right = 0,
    color = colors.bubble.text,
    font = {
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    string = icons.wifi.upload,
  },
  label = {
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    color = colors.bubble.text,
    string = "??? Bps",
  },
  y_offset = 4,
})

local wifi_down = sbar.add("item", "widgets.wifi2", {
  position = "right",
  padding_left = -5,
  icon = {
    padding_right = 0,
    color = colors.bubble.text,
    font = {
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    string = icons.wifi.download,
  },
  label = {
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    color = colors.bubble.text,
    string = "??? Bps",
  },
  y_offset = -4,
})

local wifi = sbar.add("item", "widgets.wifi.padding", {
  position = "right",
  icon = { color = colors.bubble.text },
  label = { drawing = false },
  -- Popup attached to the item (not the bracket) so popup items keep their
  -- anchor when the bracket is created later in items.right_bubble.
  popup = { align = "center", height = 30 },
})

-- Bracket is created in items.right_bubble.lua for z-order control.

local ssid = sbar.add("item", {
  position = "popup." .. wifi.name,
  icon = {
    font = {
      style = settings.font.style_map["Bold"]
    },
    string = icons.wifi.router,
  },
  width = popup_width,
  align = "center",
  label = {
    font = {
      size = 15,
      style = settings.font.style_map["Bold"]
    },
    max_chars = 18,
    string = "????????????",
  },
  background = {
    height = 2,
    color = colors.grey,
    y_offset = -15
  }
})

local hostname = sbar.add("item", {
  position = "popup." .. wifi.name,
  icon = {
    align = "left",
    string = "Hostname:",
    width = popup_width / 2,
  },
  label = {
    max_chars = 20,
    string = "????????????",
    width = popup_width / 2,
    align = "right",
  }
})

local ip = sbar.add("item", {
  position = "popup." .. wifi.name,
  icon = {
    align = "left",
    string = "IP:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  }
})

local mask = sbar.add("item", {
  position = "popup." .. wifi.name,
  icon = {
    align = "left",
    string = "Subnet mask:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  }
})

local router = sbar.add("item", {
  position = "popup." .. wifi.name,
  icon = {
    align = "left",
    string = "Router:",
    width = popup_width / 2,
  },
  label = {
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",
  },
})

sbar.add("item", "widgets.wifi.outer_padding", { position = "right", width = 0 })

-- Track popup visibility locally to avoid :query() deadlock
local wifi_popup_visible = false

wifi_up:subscribe("network_update", function(env)
  -- DEADLOCK FIX: Defer :set() calls
  sbar.delay(0.1, function()
    wifi_up:set({
      icon = { color = colors.bubble.text },
      label = {
        string = env.upload,
        color = colors.bubble.text
      }
    })
    wifi_down:set({
      icon = { color = colors.bubble.text },
      label = {
        string = env.download,
        color = colors.bubble.text
      }
    })
  end)
end)

wifi:subscribe({"wifi_change", "system_woke"}, function(env)
  sbar.exec("ipconfig getifaddr en0", function(ip)
    local connected = not (ip == "")
    -- DEADLOCK FIX: Wrap :set() in sbar.exec callback
    sbar.delay(0.1, function()
      wifi:set({
        icon = {
          string = connected and icons.wifi.connected or icons.wifi.disconnected,
          color = connected and colors.bubble.text or colors.bubble.border,
        },
      })
    end)
  end)
end)

-- Cache labels locally to avoid sbar.query() deadlock
local cached_labels = {}

local function update_cached_label(item, label)
  cached_labels[item.name] = label
end

local function hide_details()
  wifi_popup_visible = false
  sbar.delay(0.1, function()
    wifi:set({ popup = { drawing = false } })
  end)
end

local function toggle_details()
  -- Use local state instead of :query() to avoid IPC deadlock
  if not wifi_popup_visible then
    wifi_popup_visible = true
    sbar.delay(0.1, function()
      wifi:set({ popup = { drawing = true }})
    end)
    sbar.exec("networksetup -getcomputername", function(result)
      update_cached_label(hostname, result)
      sbar.delay(0.1, function()
        hostname:set({ label = result })
      end)
    end)
    sbar.exec("ipconfig getifaddr en0", function(result)
      update_cached_label(ip, result)
      sbar.delay(0.1, function()
        ip:set({ label = result })
      end)
    end)
    sbar.exec("ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'", function(result)
      update_cached_label(ssid, result)
      sbar.delay(0.1, function()
        ssid:set({ label = result })
      end)
    end)
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
      update_cached_label(mask, result)
      sbar.delay(0.1, function()
        mask:set({ label = result })
      end)
    end)
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
      update_cached_label(router, result)
      sbar.delay(0.1, function()
        router:set({ label = result })
      end)
    end)
  else
    hide_details()
  end
end

wifi_up:subscribe("mouse.clicked", toggle_details)
wifi_down:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
  -- Use cached label instead of sbar.query() to avoid IPC deadlock
  local label = cached_labels[env.NAME]
  if not label then return end
  sbar.exec("echo \"" .. label .. "\" | pbcopy")
  sbar.delay(0.1, function()
    sbar.set(env.NAME, { label = { string = icons.clipboard, align="center" } })
  end)
  sbar.delay(1, function()
    sbar.set(env.NAME, { label = { string = label, align = "right" } })
  end)
end

ssid:subscribe("mouse.clicked", copy_label_to_clipboard)
hostname:subscribe("mouse.clicked", copy_label_to_clipboard)
ip:subscribe("mouse.clicked", copy_label_to_clipboard)
mask:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)
