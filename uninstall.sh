#!/bin/bash
set -euo pipefail

TMUX_CONF="$HOME/.tmux.conf"
BIN_DIR="$HOME/.local/bin"
PLUGIN_DIR="$HOME/.tmux/plugins"

# --- helper: safe unlink ---
# Removes symlink if it exists, restores .bak if present.
unlink_target() {
  local dst="$1"

  if [ -L "$dst" ]; then
    rm "$dst"
    echo "  removed $dst"
    if [ -e "$dst.bak" ]; then
      mv "$dst.bak" "$dst"
      echo "  restored $dst from backup"
    fi
  fi
}

# --- tmux.conf ---
echo "Removing tmux.conf..."
unlink_target "$TMUX_CONF"

# --- bin scripts ---
echo "Removing bin scripts..."
for script in tmux-load tmux-mem tmux-status-right tmux-status-window-format tmux-status-current-window-format; do
  unlink_target "$BIN_DIR/$script"
done

# --- plugins ---
echo "Removing plugins..."
for plugin in tpm tmux-resurrect tmux-continuum; do
  unlink_target "$PLUGIN_DIR/$plugin"
done

echo ""
echo "Done. Submodules and repo files are untouched."
