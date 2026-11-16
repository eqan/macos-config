#!/usr/bin/env sh
set -eu

path="${1:?path required}"

if [ -d "$path" ]; then
  lf -remote "send ${id:-0} cd \"$path\"" 2>/dev/null || cd "$path"
  exit 0
fi

case "$(printf '%s' "${path##*.}" | tr '[:upper:]' '[:lower:]')" in
  txt|md|markdown|mdx|rst|org|tex|latex|json|yaml|yml|toml|ini|conf|cfg|xml|html|css|js|ts|tsx|jsx|py|rs|go|c|h|cpp|hpp|cs|java|lua|vim|sh|fish|sql|csv)
    exec nvim "$path"
    ;;
  mp4|mkv|webm|avi|mov|mp3|flac|wav|ogg|m4a)
    if command -v vlc >/dev/null 2>&1; then
      open -a VLC "$path"
    else
      open "$path"
    fi
    ;;
  *)
    open "$path"
    ;;
esac
