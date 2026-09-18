#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
TMUX_CONF="$HOME/.tmux.conf"
BIN_DIR="$HOME/.local/bin"
PLUGIN_DIR="$HOME/.tmux/plugins"

# --- submodule init ---
echo "Initializing submodules..."
git -C "$REPO_DIR" submodule update --init --recursive

# --- helper: safe symlink ---
# Backs up existing file/dir/symlink, then creates symlink.
# Skips if symlink already points to correct target.
link() {
  local src="$1" dst="$2"

  if [ -L "$dst" ]; then
    local current
    current="$(readlink -f "$dst")"
    if [ "$current" = "$src" ]; then
      return 0
    fi
    # wrong target — back up and relink
    if [ -e "$dst.bak" ]; then
      echo "  warning: $dst.bak already exists, skipping backup"
    else
      mv "$dst" "$dst.bak"
    fi
  elif [ -e "$dst" ]; then
    if [ -e "$dst.bak" ]; then
      echo "  warning: $dst.bak already exists, skipping backup"
    else
      mv "$dst" "$dst.bak"
    fi
  fi

  ln -sfn "$src" "$dst"
}

# --- existing tmux.conf ---
if [ -e "$TMUX_CONF" ] || [ -L "$TMUX_CONF" ]; then
  echo ""
  echo "Existing $TMUX_CONF found. What would you like to do?"
  echo "  [b] Backup to $TMUX_CONF.bak and install"
  echo "  [s] Skip — install scripts and plugins only"
  echo "  [a] Abort"
  echo ""
  read -rp "Choice [b/s/a]: " choice
  case "$choice" in
    b|B)
      link "$REPO_DIR/tmux.conf" "$TMUX_CONF"
      echo "Installed tmux.conf (old config backed up)"
      ;;
    s|S)
      echo "Skipping tmux.conf"
      ;;
    a|A)
      echo "Aborting."
      exit 0
      ;;
    *)
      echo "Invalid choice. Aborting."
      exit 1
      ;;
  esac
else
  ln -sfn "$REPO_DIR/tmux.conf" "$TMUX_CONF"
  echo "Installed tmux.conf"
fi

# --- bin scripts ---
echo "Installing bin scripts..."
mkdir -p "$BIN_DIR"
for script in "$REPO_DIR"/bin/tmux-*; do
  name="$(basename "$script")"
  link "$script" "$BIN_DIR/$name"
  echo "  linked $name"
done

# --- plugins ---
echo "Installing plugins..."
mkdir -p "$PLUGIN_DIR"
for plugin in "$REPO_DIR"/plugins/*/; do
  name="$(basename "$plugin")"
  link "$plugin" "$PLUGIN_DIR/$name"
  echo "  linked $name"
done

echo ""
echo "Done. Run 'tmux' and press prefix + I to install tpm plugins."
