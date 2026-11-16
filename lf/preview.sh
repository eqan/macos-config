#!/usr/bin/env sh
set -eu

path="${1:?path required}"

if [ -d "$path" ]; then
  ls -la "$path" | sed -n '1,80p'
  exit 0
fi

ext="$(printf '%s' "${path##*.}" | tr '[:upper:]' '[:lower:]')"

case "$ext" in
  txt|md|markdown|tex|latex|json|yaml|yml|toml|ini|conf|xml|html|css|js|ts|py|rs|go|c|h|cpp|hpp|cs|java|lua|vim|sh|sql|csv)
    sed -n '1,120p' "$path"
    ;;
  pdf)
    if command -v pdftotext >/dev/null 2>&1; then
      pdftotext "$path" - 2>/dev/null | sed -n '1,80p'
    else
      file "$path"
    fi
    ;;
  zip)
    if command -v unzip >/dev/null 2>&1; then
      unzip -l "$path" 2>/dev/null | sed -n '1,60p'
    else
      file "$path"
    fi
    ;;
  tar|gz)
    if command -v tar >/dev/null 2>&1; then
      tar -tf "$path" 2>/dev/null | sed -n '1,60p'
    else
      file "$path"
    fi
    ;;
  *)
    file "$path"
    ;;
esac
