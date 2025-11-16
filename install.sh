#!/bin/bash

# --- Config ---
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

set -euo pipefail  # Fail fast on errors, undefined vars, pipe failures

log() { echo -e "\033[0;34m[•] $1\033[0m"; }
success() { echo -e "\033[0;32m[✓] $1\033[0m"; }
warn() { echo -e "\033[0;33m[!] $1\033[0m"; }
error() { echo -e "\033[0;31m[✗] $1\033[0m" >&2; exit 1; }

log "Dotfiles installer"
log "Repo: $DOTFILES_DIR"
log "Backup dir (if needed): $BACKUP_DIR"

# --- Helper: safe symlink ---
# $1 = source (absolute path), $2 = target
symlink() {
    local src="$1"
    local target="$2"

    # Ensure parent dir exists
    mkdir -p "$(dirname "$target")"

    if [[ -L "$target" ]]; then
        # Already a symlink → update if incorrect, else skip
        if [[ "$(readlink "$target")" != "$src" ]]; then
            warn "Updating symlink: $target → $src"
            ln -sf "$src" "$target"
        else
            success "Symlink already correct: $target"
        fi
    elif [[ -e "$target" ]]; then
        # Exists and is NOT a symlink → backup & replace
        warn "Backing up existing $target → $BACKUP_DIR/"
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        ln -sf "$src" "$target"
        success "Backed up & symlinked: $target"
    else
        # Doesn’t exist → create
        ln -sf "$src" "$target"
        success "Symlinked: $target"
    fi
}

# --- 1. Alacritty config (~/.config/alacritty/) ---
log "Linking Alacritty config..."
symlink "$DOTFILES_DIR/config/alacritty" "$HOME/.config/alacritty"

# --- 2. Git config (~/.gitconfig) ---
log "Linking Git config..."
symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# --- 3. SSH config (~/.ssh/config) ---
log "Linking SSH config..."
# Ensure ~/.ssh exists (it should, but be safe)
mkdir -p "$HOME/.ssh"
# Set secure permissions *before* symlinking (avoids warning)
chmod 700 "$HOME/.ssh"
symlink "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
# Ensure config is not world-readable
chmod 600 "$HOME/.ssh/config" 2>/dev/null || true

# --- Done ---
success "Dotfiles installed! Reload your shell or restart terminal."
echo
log "Tips:"
echo "  • Run 'source ~/.zshrc' or 'exec zsh' to reload shell"
echo "  • Verify SSH: 'ssh -G github.com | grep user'"
echo "  • Verify Git: 'git config --list --show-origin | grep mydots'"
echo