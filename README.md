# renderorange-tmux

tmux configuration, utility scripts, and plugin management.

## Install

```bash
git clone <repo-url> ~/renderorange-tmux
cd ~/renderorange-tmux
./install.sh
```

The installer will:
- Initialize plugin submodules (tpm, tmux-resurrect, tmux-continuum)
- Symlink tmux.conf to ~/.tmux.conf
- Symlink bin scripts to ~/.local/bin/
- Symlink plugins to ~/.tmux/plugins/

If ~/.tmux.conf already exists, you'll be prompted to back it up, skip, or abort.

## Uninstall

```bash
./uninstall.sh
```

Removes symlinks and restores backups if they exist.

## Updating

```bash
git pull
git submodule update --remote
```

## What's included

- **tmux.conf** — screen-style prefix (C-a), truecolor, mouse, status bar with system stats
- **bin/** — tmux-load, tmux-mem, tmux-status-right, tmux-status-window-format, tmux-status-current-window-format
- **plugins/** — tpm, tmux-resurrect, tmux-continuum (submodules)
