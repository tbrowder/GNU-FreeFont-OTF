#!/usr/bin/env bash
# check-utf8.sh — verify (and optionally fix) files to be UTF-8
#
# Usage:
#   ./check-utf8.sh [--fix] [path...]
#
# Examples:
#   ./check-utf8.sh .          # dry-run, just report
#   ./check-utf8.sh --fix src  # fix non-UTF8 text files under src/

set -euo pipefail

fix_mode=0
paths=()

for arg in "$@"; do
  if [[ "$arg" == "--fix" ]]; then
    fix_mode=1
  else
    paths+=("$arg")
  fi
done

if [ ${#paths[@]} -eq 0 ]; then
  paths=(".")
fi

non_utf8=0

check_file() {
  local f="$1"
  [ -d "$f" ] && return

  local info
  info=$(file -i "$f" 2>/dev/null || true)

  if [[ "$info" == *"charset=utf-8"* ]]; then
    echo "OK   : $f"
  elif [[ "$info" == *"charset=binary"* ]]; then
    echo "SKIP : $f (binary)"
  else
    echo "FAIL : $f ($info)"
    non_utf8=$((non_utf8+1))

    if [ $fix_mode -eq 1 ]; then
      local bak="${f}.bak"
      cp "$f" "$bak"
      echo " → converting $f to UTF-8 (backup at $bak)"
      # Assume ISO-8859-1/Latin-1 fallback; adjust -f if needed (e.g., WINDOWS-1252)
      if iconv -f latin1 -t utf-8 "$bak" > "$f"; then
        echo " ✓ fixed $f"
      else
        echo " ✗ could not convert $f"
      fi
    fi
  fi
}

export -f check_file
export fix_mode
export non_utf8

find "${paths[@]}" -type f -print0 | while IFS= read -r -d '' f; do
  check_file "$f"
done

if [ $non_utf8 -ne 0 ] && [ $fix_mode -eq 0 ]; then
  echo
  echo "❌ $non_utf8 file(s) are not UTF-8"
  exit 1
else
  echo
  echo "✅ All files are UTF-8 (or binary skipped)"
fi
