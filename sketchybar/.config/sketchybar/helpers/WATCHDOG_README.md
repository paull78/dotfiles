# Sketchybar watchdog

Auto-restarts sketchybar when it deadlocks (mach_send_message stall, see
[issue #794](https://github.com/FelixKratz/SketchyBar/issues/794)).

## Files

- `watchdog.sh` — the probe script. Calls `sketchybar --query bar` with a
  3-second hard timeout via `python3`. If the query fails or hangs, runs
  `brew services restart sketchybar`. Logs every recovery to
  `/tmp/sketchybar_watchdog.log`.
- `com.paolo.sketchybar.watchdog.plist` — LaunchAgent definition that runs
  the script every 60 seconds.

## Install

```sh
# Symlink the plist into LaunchAgents
ln -sf ~/.config/sketchybar/helpers/com.paolo.sketchybar.watchdog.plist \
       ~/Library/LaunchAgents/com.paolo.sketchybar.watchdog.plist

# Bootstrap into the user's GUI domain
launchctl bootstrap gui/$(id -u) \
  ~/Library/LaunchAgents/com.paolo.sketchybar.watchdog.plist

# Verify it's loaded
launchctl list | grep watchdog
```

## Uninstall

```sh
launchctl bootout gui/$(id -u) \
  ~/Library/LaunchAgents/com.paolo.sketchybar.watchdog.plist
rm ~/Library/LaunchAgents/com.paolo.sketchybar.watchdog.plist
```

## Patched sketchybar build (real fix)

The watchdog is a safety net. The deadlock itself is patched out by building
sketchybar and SbarLua from source with a 100ms `MACH_SEND_TIMEOUT` on the
`mach_send_message` calls. See:

- https://github.com/FelixKratz/SketchyBar/issues/794
- Patched sources at `~/src/sketchybar/` and `~/src/SbarLua/`
- Original binaries backed up at `~/src/sketchybar_backup_v2.23.0/`

If `brew upgrade sketchybar` ever overwrites the patched binary, rebuild and
reinstall by:

```sh
cd ~/src/sketchybar && make
cp ~/src/sketchybar/bin/sketchybar /opt/homebrew/Cellar/sketchybar/<ver>/bin/sketchybar

cd ~/src/SbarLua && make
cp ~/src/SbarLua/bin/sketchybar.so ~/.local/share/sketchybar_lua/sketchybar.so

brew services restart sketchybar
```

The SbarLua repo must be checked out at `437bd20` (last commit before Lua
5.5.0 bump) to maintain ABI compatibility with the system's Lua 5.4.
