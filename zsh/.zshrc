export ZDOTDIR="$HOME/.config/zsh"

for file in "$ZDOTDIR"/exports.zsh "$ZDOTDIR"/aliases.zsh "$ZDOTDIR"/functions.zsh; do
  if [ -r "$file" ]; then
    source "$file"
  fi
done

