#!/usr/bin/env bash
# Arch Linux setup: packages, zsh/tmux plugins, and dotfiles symlinks
# safe to re-run. desktop settings live in kde.sh
set -euo pipefail

DOTFILES="$HOME/dotfiles"

# official repo packages
PACMAN_PKGS=(
    # core tools
    git stow zsh tmux neovim fzf ghostty wget curl unzip
    # search / preview
    ripgrep fd bat jq
    # nvim: treesitter parsers (main branch) + mason (gopls, ts_ls)
    tree-sitter-cli base-devel go nodejs npm
    # zsh
    zsh-syntax-highlighting
    # font used by ghostty, tmux and nvim icons
    ttf-inconsolata-nerd
    github-cli
    # vietnamese input (wired up in kde.sh)
    fcitx5 fcitx5-bamboo fcitx5-qt fcitx5-gtk fcitx5-configtool
)

# AUR packages
AUR_PKGS=(
    look-bin
    claude-code
)

echo "==> pacman packages"
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

if ! command -v yay >/dev/null; then
    echo "==> yay"
    tmp="$(mktemp -d)"
    git clone --depth 1 https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
    (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmp"
fi

echo "==> AUR packages"
yay -S --needed --noconfirm "${AUR_PKGS[@]}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> oh-my-zsh"
    # KEEP_ZSHRC: don't let the installer write its template over ours
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

autosuggest="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$autosuggest" ]; then
    echo "==> zsh-autosuggestions"
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$autosuggest"
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "==> tpm"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "==> dotfiles"
cd "$DOTFILES"
for pkg in nvim tmux zsh ghostty; do
    # move real files that block stow (e.g. a generated ~/.zshrc) out of the way
    { stow -n "$pkg" 2>&1 || true; } | sed -n 's/.*existing target \(.*\) since.*/\1/p' | while read -r target; do
        echo "    backup ~/$target -> ~/$target.bak"
        mv "$HOME/$target" "$HOME/$target.bak"
    done
    stow "$pkg"
done

echo "==> tmux plugins"
"$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null

if [ "$(basename "$SHELL")" != zsh ]; then
    echo "==> default shell -> zsh"
    chsh -s "$(command -v zsh)"
fi

echo "done. run $DOTFILES/others/kde.sh for desktop settings"
