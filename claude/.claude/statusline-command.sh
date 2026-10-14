#!/usr/bin/env bash
# Claude Code status line — Gruvbox Dark powerline style

# Gruvbox Dark colors
FG0='\033[38;2;251;241;199m'      # #fbf1c7
BG_YELLOW='\033[48;2;215;153;33m' # #d79921
BG_BLUE='\033[48;2;69;133;136m'   # #458588

FG_YELLOW='\033[38;2;215;153;33m'
FG_BLUE='\033[38;2;69;133;136m'

# Text colour for bright backgrounds. Cream #fbf1c7 on the yellow #d79921
# measures 2.19:1 contrast -- well under the 4.5:1 WCAG AA threshold and
# genuinely hard to read. Gruvbox bg0 #282828 on the same yellow is 5.94:1.
FG_DARK='\033[38;2;40;40;40m'    # #282828
FG_BG1='\033[38;2;60;56;54m'
RESET='\033[0m'

# Table of readable colors for the folder segment — bright, high-contrast
# Gruvbox Dark accents chosen to stay legible even when the terminal dims
# ANSI colors. A color is picked deterministically from a hash of the
# current folder's full path, so the same folder always renders the same
# color across sessions.
FOLDER_COLORS=(
  "251;73;52"   # bright red    #fb4934
  "254;128;25"  # bright orange #fe8019
  "250;189;47"  # bright yellow #fabd2f
  "184;187;38"  # bright green  #b8bb26
  "142;192;124" # bright aqua   #8ec07c
  "131;165;152" # bright blue   #83a598
  "211;134;155" # bright purple #d3869b
  "255;121;198" # bright pink   #ff79c6
  "139;233;253" # bright cyan   #8be9fd
  "166;226;46"  # bright lime   #a6e22e
  "124;131;253" # bright indigo #7c83fd
  "45;212;191"  # bright teal   #2dd4bf
)

# Percentages arrive as "37.4". Under a locale whose decimal separator is a
# comma (it_IT, de_DE, fr_FR ...) printf %.0f rejects them, truncating instead
# of rounding and warning on stderr. Force C numerics.
export LC_NUMERIC=C

input=$(cat)

# Fields
MODEL=$(echo "$input" | jq -r '.model.display_name // ""')
CWD=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
FOLDER=$(basename "$CWD" 2>/dev/null)
[ -z "$FOLDER" ] && FOLDER="~"

# Pick a readable color for the folder from FOLDER_COLORS, keyed by a hash
# of the full folder path (same folder -> same color, every time).
FOLDER_HASH=$(printf '%s' "$CWD" | cksum | awk '{print $1}')
FOLDER_COLOR_IDX=$(( FOLDER_HASH % ${#FOLDER_COLORS[@]} ))
FG_FOLDER="\033[38;2;${FOLDER_COLORS[$FOLDER_COLOR_IDX]}m"

USED_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
CTX_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
CTX_STR=""
if [ -n "$USED_PCT" ] && [ -n "$CTX_SIZE" ]; then
  USED_INT=$(printf '%.0f' "$USED_PCT")
  USED_TOKENS=$(echo "$USED_PCT * $CTX_SIZE / 100" | bc | cut -d. -f1)
  if [ "$USED_TOKENS" -ge 1000000 ]; then
    TOKEN_DISPLAY="$(echo "scale=1; $USED_TOKENS / 1000000" | bc)M"
  elif [ "$USED_TOKENS" -ge 1000 ]; then
    TOKEN_DISPLAY="$(echo "scale=0; $USED_TOKENS / 1000" | bc)k"
  else
    TOKEN_DISPLAY="$USED_TOKENS"
  fi
  CTX_STR=" ctx:${USED_INT}%% ${TOKEN_DISPLAY}"
fi

FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
# resets_at is Unix epoch seconds; show it as local wall-clock time (HH:MM).
FIVE_H_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
RATE_STR=""
if [ -n "$FIVE_H" ]; then
  RATE_STR=" 5h:$(printf '%.0f' "$FIVE_H")%%"
  if [ -n "$FIVE_H_RESET" ]; then
    RESET_TIME=$(date -r "${FIVE_H_RESET%.*}" +%H:%M 2>/dev/null)
    [ -n "$RESET_TIME" ] && RATE_STR="${RATE_STR} ↻${RESET_TIME}"
  fi
fi

# Segment 1: model (blue bg)
printf "${FG_BG1}${BG_BLUE}${FG0} ${MODEL} ${RESET}"
# blue -> yellow separator (U+E0B0 as UTF-8 bytes: bash 3.2 printf has no \u)
printf "${FG_BLUE}${BG_YELLOW}\xee\x82\xb0${RESET}"
# Segment 2: context + rate limits (yellow/gold bg)
printf "${BG_YELLOW}${FG_DARK}${CTX_STR}${RATE_STR} ${RESET}"
printf "${FG_YELLOW}\xee\x82\xb0${RESET}"
# Segment 3: current folder, colored by a hash of its path
printf " ${FG_FOLDER}${FOLDER}${RESET}"
# Segment 4: git branch of the session's working directory (nothing outside a repo)
BRANCH=""
if [ -n "$CWD" ]; then
  BRANCH=$(GIT_OPTIONAL_LOCKS=0 git -C "$CWD" branch --show-current 2>/dev/null)
fi
[ -n "$BRANCH" ] && printf " ${FG_BLUE}(%s)${RESET}" "$BRANCH"
printf "\n"
