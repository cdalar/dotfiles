# dotfiles

Bash configuration for macOS (Homebrew bash + oh-my-bash).

## Bootstrap

```bash
git clone https://github.com/cdalar/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

`install.sh` will:
1. Symlink `.bashrc`, `.bash_profile`, `.gitconfig`, `.gitignore_global` into `$HOME`
2. Create `~/.env.local` from `.env.local.example` (fill in your secrets there)
3. Install Homebrew if missing
4. Run `brew bundle` to install all packages
5. Install oh-my-bash if missing

## Secrets

`~/.env.local` is sourced by `.bashrc` but is never committed. Copy and fill in:

```bash
cp .env.local.example ~/.env.local
```
