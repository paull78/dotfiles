# dotfiles

Personal macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a Stow package whose contents mirror their target
location under `$HOME`. Stowing a package symlinks its files into place.

## Contents

| Package     | What it configures                                              |
| ----------- | -------------------------------------------------------------- |
| `ghostty`   | [Ghostty](https://ghostty.org) terminal                        |
| `nvim`      | Neovim, built on [LazyVim](https://www.lazyvim.org)            |
| `sketchybar`| [SketchyBar](https://felixkratz.github.io/SketchyBar/) menu bar|
| `skhd`      | [skhd](https://github.com/koekeishiya/skhd) hotkey daemon      |
| `yabai`     | [yabai](https://github.com/koekeishiya/yabai) tiling WM        |
| `starship`  | [Starship](https://starship.rs) shell prompt                   |
| `zsh`       | Zsh / Oh My Zsh configuration                                  |

## Usage

```bash
git clone https://github.com/paull78/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Stow individual packages...
stow zsh nvim ghostty

# ...or everything at once
stow */
```

## SketchyBar

![SketchyBar menu bar](.github/screenshots/sketchybar-full.png)

A custom [SketchyBar](https://felixkratz.github.io/SketchyBar/) setup written in
Lua, with hand-written C event providers for CPU and network load, a per-space
color palette, and a launchd watchdog that auto-restarts the bar if it deadlocks
(see [`helpers/WATCHDOG_README.md`](sketchybar/.config/sketchybar/helpers/WATCHDOG_README.md)).

## Keyboard shortcuts (skhd)

[skhd](https://github.com/koekeishiya/skhd) binds <kbd>Alt</kbd> + a letter to
launch or focus an app:

| Shortcut          | App                | Shortcut          | App                |
| ----------------- | ------------------ | ----------------- | ------------------ |
| <kbd>Alt</kbd>+B  | Obsidian           | <kbd>Alt</kbd>+M  | Mail               |
| <kbd>Alt</kbd>+C  | Google Meet        | <kbd>Alt</kbd>+O  | Sourcetree         |
| <kbd>Alt</kbd>+D  | Claude             | <kbd>Alt</kbd>+P  | Spotify            |
| <kbd>Alt</kbd>+E  | Microsoft Edge     | <kbd>Alt</kbd>+S  | Safari             |
| <kbd>Alt</kbd>+F  | Finder             | <kbd>Alt</kbd>+T  | iTerm              |
| <kbd>Alt</kbd>+G  | Ghostty            | <kbd>Alt</kbd>+V  | Visual Studio Code |
| <kbd>Alt</kbd>+H  | GitHub             | <kbd>Alt</kbd>+W  | WhatsApp           |
| <kbd>Alt</kbd>+J  | Jira               | <kbd>Alt</kbd>+`  | Cycle yabai layout |
| <kbd>Alt</kbd>+K  | Spark              |                   | (bsp → stack → float) |
| <kbd>Alt</kbd>+L  | Slack              |                   |                    |

## Notes

These are tuned for my own machine, so some paths and tool locations
(Homebrew, bun, deno, etc.) are hardcoded and may need adjusting for yours.
Machine-specific and secret files are kept out of version control — see
`.gitignore`.
