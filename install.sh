#!/usr/bin/env bash
# install.sh — symlink configs from this repo into $HOME.
# Idempotent. Safe to re-run. Use --dry-run to preview.

set -euo pipefail

DOTFILES="$HOME/Workspace/dotfiles"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

# Format:  source-relative-to-repo | target-absolute-path
links=(
  "shell/zshrc                | $HOME/.zshrc"
  "shell/zprofile             | $HOME/.zprofile"
  "shell/zsh_aliases          | $HOME/.zsh_aliases"
  "prompt/starship.toml       | $HOME/.config/starship.toml"
  "prompt/starship-light.toml | $HOME/.config/starship-light.toml"
  "tmux/tmux.conf             | $HOME/.tmux.conf"
  "wezterm/wezterm.lua        | $HOME/.wezterm.lua"
  "zellij/config.kdl          | $HOME/.config/zellij/config.kdl"
  "iterm2/DynamicProfiles     | $HOME/Library/Application Support/iTerm2/DynamicProfiles"
  "nvim                       | $HOME/.config/nvim"
  "git/gitconfig              | $HOME/.gitconfig"
  "git/gitignore_global       | $HOME/.gitignore_global"
  "gh/config.yml              | $HOME/.config/gh/config.yml"
  "claude/settings.json       | $HOME/.claude/settings.json"
)

stamp=$(date +%Y%m%d-%H%M%S)
linked=0; replaced=0; unchanged=0; backed_up=0

run() {
  if (( DRY_RUN )); then
    printf '  + %s\n' "$*"
  else
    "$@"
  fi
}

# Trim leading/trailing whitespace
trim() { local s="$*"; s="${s#"${s%%[![:space:]]*}"}"; s="${s%"${s##*[![:space:]]}"}"; printf '%s' "$s"; }

link_one() {
  local src_rel="$1" target="$2"
  local src="$DOTFILES/$src_rel"

  if [[ ! -e "$src" ]]; then
    printf '✗ missing source: %s\n' "$src" >&2
    return 1
  fi

  run mkdir -p "$(dirname "$target")"

  if [[ -L "$target" ]]; then
    if [[ "$(readlink "$target")" == "$src" ]]; then
      printf '= unchanged   %s\n' "$target"
      ((unchanged+=1))
      return 0
    fi
    run rm "$target"
    run ln -s "$src" "$target"
    printf '↻ replaced    %s  →  %s\n' "$target" "$src"
    ((replaced+=1))
    return 0
  fi

  if [[ -e "$target" ]]; then
    local backup="${target}.backup-${stamp}"
    run mv "$target" "$backup"
    printf '  backed up   %s  →  %s\n' "$target" "$backup"
    ((backed_up+=1))
  fi

  run ln -s "$src" "$target"
  printf '✓ linked      %s  →  %s\n' "$target" "$src"
  ((linked+=1))
}

printf '=== dotfiles install %s===\n' "$([[ $DRY_RUN == 1 ]] && echo "(dry-run) " || echo "")"
printf '  source: %s\n\n' "$DOTFILES"

for entry in "${links[@]}"; do
  src=$(trim "${entry%%|*}")
  target=$(trim "${entry#*|}")
  link_one "$src" "$target"
done

printf '\n=== summary ===\n'
printf '  linked:    %d\n' "$linked"
printf '  replaced:  %d\n' "$replaced"
printf '  unchanged: %d\n' "$unchanged"
printf '  backed up: %d\n' "$backed_up"
printf '\n'

cat <<'POST'
Post-install reminders:
  • Install Homebrew if missing, then:  brew bundle install
  • Install oh-my-zsh:                  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  • Install tpm:                        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  • In a tmux session, fetch plugins:   prefix + I  (capital i)
  • First nvim launch will bootstrap Lazy.nvim and install plugins from lazy-lock.json
  • Copy .env.example → ~/.env and fill in any secrets (GitHub PAT, OpenAI keys, etc.)
POST
