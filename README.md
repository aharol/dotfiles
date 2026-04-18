# dotfiles

Personal config for a macOS development machine. Symlink-based: edit in this
repo, changes are live immediately.

## Layout

```
.
├── shell/        zsh login + interactive + aliases
├── prompt/       Starship prompt (dual: dark + light, OS-appearance synced)
├── tmux/         tmux config (catppuccin, vim-tmux-navigator, resurrect/continuum)
├── wezterm/      WezTerm Lua config (Catppuccin Mocha/Latte)
├── iterm2/       iTerm2 dynamic profiles (placeholder)
├── nvim/         AstroNvim user config
├── git/          .gitconfig + global gitignore
├── gh/           GitHub CLI config
├── claude/       Claude Code settings
├── launchagents/ macOS LaunchAgents (WezTerm mux-server)
├── Brewfile      `brew bundle install` to restore packages
├── .env.example  Template for secrets sourced into the shell
└── install.sh    Symlink deployer (idempotent, --dry-run supported)
```

## Bootstrap a new Mac

```sh
# 1. Xcode CLT
xcode-select --install

# 2. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Clone this repo
mkdir -p ~/Workspace && cd ~/Workspace
git clone git@github.com:aharol/dotfiles.git

# 4. Symlink configs
cd dotfiles
./install.sh --dry-run     # preview
./install.sh               # apply

# 5. Restore packages
brew bundle install --file=Brewfile

# 6. Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 7. Install tpm and fetch tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new -s init
# inside tmux: prefix + I  (capital i) — fetches plugins, exit when done

# 8. First nvim launch — Lazy.nvim bootstraps and installs from lazy-lock.json
nvim +Lazy

# 9. Copy secrets template, fill in
cp .env.example ~/.env
$EDITOR ~/.env
```

## What each tool does

- **Zsh + oh-my-zsh** — shell. Plugins: `macos`, `python`, `git`. History
  shared across sessions. Sources `~/.env` for secrets.
- **Starship** — prompt. Two configs (`starship.toml` dark, `starship-light.toml`
  light); a `precmd` hook in `.zshrc` swaps `$STARSHIP_CONFIG` based on
  `defaults read -g AppleInterfaceStyle`, so the prompt theme follows macOS
  appearance with no shell restart.
- **tmux** — multiplexer. tpm plugins: vim-tmux-navigator, catppuccin, resurrect,
  continuum. Truecolor caps (`RGB` + `Tc`) set so apps inside tmux render with
  full 24-bit colour.
- **WezTerm** — terminal emulator. Same dual-Catppuccin pattern as Starship,
  driven by `wezterm.gui.get_appearance()`.
- **Neovim (AstroNvim)** — editor. Lazy.nvim, Mason-managed LSPs, conform.nvim
  formatting, nvim-lint linting, Catppuccin colourscheme that follows macOS
  appearance via a `precmd` autocommand in `lua/polish.lua`.
- **GitHub CLI** — `gh` config with `co = pr checkout` alias.
- **Claude Code** — settings (`effortLevel: high`, plugins).

## Light/dark theming

Four tools (zsh prompt, tmux, WezTerm, Neovim) all detect macOS appearance and
swap palettes:

| Tool      | Mechanism                                                      |
|-----------|----------------------------------------------------------------|
| Starship  | `precmd` hook in `.zshrc` swaps `$STARSHIP_CONFIG`             |
| tmux      | `if-shell` at config load time picks catppuccin flavour        |
| WezTerm   | `wezterm.gui.get_appearance()` at config evaluation            |
| Neovim    | `precmd` autocmd in `lua/polish.lua` syncs `vim.o.background`  |

Switch macOS appearance and reopen apps (or run `prefix + T` in tmux) to flip.

## Secrets

Sensitive values (API keys, GitHub PAT, etc.) **never** go in tracked files.
Pattern:

1. `.env.example` (tracked) lists what variables the shell expects.
2. Real values live in `~/.env` (in `.gitignore`, not tracked).
3. `shell/zprofile` sources `~/.env` if present.

## Editing workflow

1. Edit files in this repo.
2. Changes are live in `~/` instantly via the symlinks.
3. Test with `exec zsh` or by reopening the affected app.
4. Commit.

## Updating Brewfile

After installing new tools:

```sh
brew bundle dump --file=Brewfile --no-vscode --no-restart --force
git add Brewfile && git commit -m "brew: snapshot packages"
```

## Restoring a backup

`install.sh` timestamps anything it would overwrite:

```sh
ls ~/.zshrc.backup-*
mv ~/.zshrc.backup-20260418-120000 ~/.zshrc
```
