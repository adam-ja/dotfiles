#!/bin/bash
# Claude Code status line script

input=$(cat)

# ── Colours ──────────────────────────────────────────────────────────────────
RESET="\033[0m"
DIM="\033[2m"
CYAN="\033[36m"
YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
MAGENTA="\033[35m"
BLUE="\033[34m"
WHITE="\033[37m"

# ── Helper: format seconds remaining as "Xh Ym" ─────────────────────────────
fmt_remaining() {
  local resets_at="$1"
  local now
  now=$(date +%s)
  local diff=$(( resets_at - now ))
  if [ "$diff" -le 0 ]; then
    echo "now"
    return
  fi
  local h=$(( diff / 3600 ))
  local m=$(( (diff % 3600) / 60 ))
  if [ "$h" -gt 0 ]; then
    echo "${h}h${m}m"
  else
    echo "${m}m"
  fi
}

# ── Helper: format epoch as day + time, e.g. "Tue 14:59" ────────────────────────
fmt_daytime() {
  date -d "@$1" +"%a %H:%M"
}

# ── Extract fields ────────────────────────────────────────────────────────────
vim_mode=$(echo    "$input" | jq -r '.vim.mode // empty')
model=$(echo       "$input" | jq -r '.model.display_name // empty')
thinking=$(echo    "$input" | jq -r '.thinking.enabled // empty')
effort=$(echo      "$input" | jq -r '.effort.level // empty')
in_tokens=$(echo   "$input" | jq -r '.context_window.current_usage.input_tokens // empty')
out_tokens=$(echo  "$input" | jq -r '.context_window.current_usage.output_tokens // empty')
ctx_used=$(echo    "$input" | jq -r '.context_window.used_percentage // empty')
five_pct=$(echo    "$input" | jq -r '.rate_limits.five_hour.used_percentage  // empty')
five_reset=$(echo  "$input" | jq -r '.rate_limits.five_hour.resets_at        // empty')
week_pct=$(echo    "$input" | jq -r '.rate_limits.seven_day.used_percentage  // empty')
week_reset=$(echo  "$input" | jq -r '.rate_limits.seven_day.resets_at        // empty')

# ── Assemble parts ────────────────────────────────────────────────────────────
parts=()

# Vim mode
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    INSERT)    vim_color="$GREEN"   ;;
    NORMAL)    vim_color="$CYAN"    ;;
    VISUAL*)   vim_color="$MAGENTA" ;;
    *)         vim_color="$WHITE"   ;;
  esac
  parts+=("$(printf " ${vim_color}%s${RESET}" "$vim_mode")")
fi

#  Model
if [ -n "$model" ]; then
  parts+=("$(printf "  ${CYAN}%s${RESET}" "$model")")
fi

# Thinking
thinking_str="󰧑 "
if [ "$thinking" = "true" ]; then
  thinking_str+="$(printf "${GREEN}${RESET}")"
else
  thinking_str+="$(printf "${RED}${RESET}")"
fi
parts+=("$thinking_str")

# Effort
if [ -n "$effort" ]; then
  case "$effort" in
    low)           effort_color="$GREEN"   ;;
    medium)        effort_color="$YELLOW"  ;;
    high|xhigh|max) effort_color="$RED"   ;;
    *)             effort_color="$WHITE"   ;;
  esac
  parts+=("$(printf "󰓅 ${effort_color}%s${RESET}" "$effort")")
fi

# Tokens
if [ -n "$in_tokens" ] || [ -n "$out_tokens" ]; then
  tok_str="󱊍 "
  [ -n "$in_tokens"  ] && tok_str+="$(printf "󰸇 ${WHITE}%s${RESET}" "$in_tokens")"
  [ -n "$in_tokens"  ] && [ -n "$out_tokens" ] && tok_str+=" "
  [ -n "$out_tokens" ] && tok_str+="$(printf "󰮏 ${WHITE}%s${RESET}" "$out_tokens")"
  parts+=("$tok_str")
fi

# Context window
if [ -n "$ctx_used" ]; then
  pct_int=$(printf "%.0f" "$ctx_used")
  if   [ "$pct_int" -ge 80 ]; then color="$RED"
  elif [ "$pct_int" -ge 50 ]; then color="$YELLOW"
  else color="$BLUE"; fi
  parts+=("$(printf " ${color}%s%%${RESET}" "$pct_int")")
fi

# 5-hour rate limit
if [ -n "$five_pct" ]; then
  pct_int=$(printf "%.0f" "$five_pct")
  remaining_str=""
  if [ -n "$five_reset" ]; then
    remaining_str=" $(printf "${DIM}$(fmt_remaining "$five_reset")${RESET}")"
  fi
  if   [ "$pct_int" -ge 80 ]; then color="$RED"
  elif [ "$pct_int" -ge 50 ]; then color="$YELLOW"
  else color="$GREEN"; fi
  parts+=("$(printf "󱑏 ${color}%s%%%s${RESET}" "$pct_int" "$remaining_str")")
fi

# 7-day rate limit
if [ -n "$week_pct" ]; then
  pct_int=$(printf "%.0f" "$week_pct")
  remaining_str=""
  if [ -n "$week_reset" ]; then
    remaining_str=" $(printf "${DIM}$(fmt_daytime "$week_reset")${RESET}")"
  fi
  if   [ "$pct_int" -ge 80 ]; then color="$RED"
  elif [ "$pct_int" -ge 50 ]; then color="$YELLOW"
  else color="$GREEN"; fi
  parts+=("$(printf " ${color}%s%%%s${RESET}" "$pct_int" "$remaining_str")")
fi

# ── Join with dim separator ───────────────────────────────────────────────────
sep="$(printf "${DIM}  ${RESET}")"
result=""
for part in "${parts[@]}"; do
  if [ -z "$result" ]; then
    result="$part"
  else
    result="${result}${sep}${part}"
  fi
done

printf "%b\n" "$result"
