#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backup and symlink a dotfile
link() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$1"
  if [ -f "$dst" ] && [ ! -L "$dst" ]; then
    echo "  Backing up existing $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sf "$src" "$dst"
  echo "  Linked $dst"
}

echo "==> Installing dotfiles"
link .bashrc
link .bash_profile
link .gitconfig
link .gitignore_global

echo ""
echo "==> Setting up .env.local"
if [ ! -f "$HOME/.env.local" ]; then
  cp "$DOTFILES/.env.local.example" "$HOME/.env.local"
  echo "  Created ~/.env.local from example — fill in your secrets"
else
  echo "  ~/.env.local already exists, skipping"
fi

echo ""
echo "==> Checking Homebrew"
if ! command -v brew &>/dev/null; then
  echo "  Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "  Homebrew already installed"
fi

echo ""
echo "==> Installing Homebrew packages (this may take a while)"
brew bundle --file="$DOTFILES/Brewfile"

echo ""
echo "==> Checking oh-my-bash"
if [ ! -d "$HOME/.oh-my-bash" ]; then
  echo "  Installing oh-my-bash..."
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
else
  echo "  oh-my-bash already installed"
fi

echo ""
echo "==> Setting default shell to Homebrew bash"
BREW_BASH="/opt/homebrew/bin/bash"
if [ "$SHELL" = "$BREW_BASH" ]; then
  echo "  Already using $BREW_BASH"
else
  if ! grep -qF "$BREW_BASH" /etc/shells; then
    echo "  Adding $BREW_BASH to /etc/shells (requires sudo)"
    echo "$BREW_BASH" | sudo tee -a /etc/shells
  fi
  chsh -s "$BREW_BASH"
  echo "  Default shell set to $BREW_BASH"
fi

echo ""
echo "Done! Open a new terminal — it will use bash."
