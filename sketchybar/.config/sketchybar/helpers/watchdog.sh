#!/bin/bash
# sketchybar watchdog
# ===================
# Detects the mach_send_message deadlock (sketchybar issue #794) and
# auto-restarts sketchybar when it stops responding to queries.
#
# How it works: macOS lacks `timeout`, so we use python3's subprocess.run
# with a hard 3-second timeout. If `sketchybar --query bar` hangs or fails,
# we restart the brew service.
#
# Logs to /tmp/sketchybar_watchdog.log (one line per detected hang).
# The launchd plist (com.paolo.sketchybar.watchdog.plist) runs this every
# 60 seconds.

LOG=/tmp/sketchybar_watchdog.log
SBAR=/opt/homebrew/bin/sketchybar
TIMEOUT_SECS=3

# Quick exit if sketchybar isn't running yet (don't restart what isn't there;
# brew services or login items will start it normally).
if ! pgrep -xf "$SBAR" >/dev/null 2>&1 && ! pgrep -xf "/opt/homebrew/opt/sketchybar/bin/sketchybar" >/dev/null 2>&1; then
  exit 0
fi

# Probe the bar with a hard timeout. python3 is universally available.
if ! /opt/homebrew/bin/python3 -c "
import subprocess, sys
try:
    subprocess.run(['$SBAR', '--query', 'bar'],
                   timeout=$TIMEOUT_SECS,
                   stdout=subprocess.DEVNULL,
                   stderr=subprocess.DEVNULL,
                   check=True)
except Exception:
    sys.exit(1)
" 2>/dev/null; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') sketchybar unresponsive - restarting" >> "$LOG"
  /opt/homebrew/bin/brew services restart sketchybar >> "$LOG" 2>&1
fi
