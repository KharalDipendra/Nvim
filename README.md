# Nvim

Neovim with stock Vim keys (no custom shortcuts), language servers, completion, a file tree and fuzzy search.

## Install

Install the tools for your system (below), then:

```sh
git clone https://github.com/KharalDipendra/Nvim ~/.config/nvim
nvim
```

Plugins, language servers and syntax parsers install themselves on first launch. Give it a minute, then restart nvim.

### macOS

```sh
brew install neovim git ripgrep fd tree-sitter-cli node go
brew install --cask font-caskaydia-cove-nerd-font dotnet-sdk
```

Set your terminal's font to **CaskaydiaCove Nerd Font**, or the icons show as boxes. If the colours look washed out, your terminal lacks 24-bit colour (older versions of macOS Terminal); use kitty, iTerm2, Ghostty or WezTerm.

### Arch Linux

```sh
sudo pacman -S neovim git ripgrep fd tree-sitter-cli nodejs npm go dotnet-sdk wl-clipboard ttf-cascadia-code-nerd
```

## kitty (optional)

`extras/kitty/` holds the matching kitty config: font, spacing, colours, and the remote-control socket nvim uses to go full screen while it runs. Outside kitty, nvim just runs normally.

```sh
brew install --cask kitty            # macOS
sudo pacman -S kitty                 # Arch
mv ~/.config/kitty ~/.config/kitty.bak 2>/dev/null
ln -s ~/.config/nvim/extras/kitty ~/.config/kitty
```

Shared settings are in `kitty.conf`; `linux.conf` and `macos.conf` hold the bits that differ.

## Notes

- `lazy-lock.json` pins plugin versions so every machine matches. `:Lazy update` updates them; commit the new lock file.
- GDScript (Godot) completion works while the Godot editor is open.
