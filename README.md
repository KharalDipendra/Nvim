# nvim

## Install

```bash
sudo pacman -S neovim git ripgrep fd tree-sitter-cli nodejs npm ttf-jetbrains-mono-nerd
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
git clone https://github.com/KharalDipendra/Nvim ~/.config/nvim
nvim
```

Plugins and language servers install on first launch.

For kitty, add to `kitty.conf`:

```
allow_remote_control socket-only
listen_on unix:${XDG_RUNTIME_DIR}/kitty
```
