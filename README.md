# mydots

This repository contains my personal dotfiles and configuration snippets for my systems.

It holds configuration files and themes I use (for example, Alacritty terminal themes and SSH config). An `install.sh` script is provided to link or copy the configuration into the correct locations on a target machine.

## Contents

- `install.sh` — installer script to set up the configuration on a new machine.
- `config/` — configuration folders (examples below):
  - `alacritty/` — Alacritty config and color schemes
- `ssh/` — SSH client configuration

The tree looks like:

```
install.sh
README.md
config/
	alacritty/
		alacritty.toml
		catppuccin-mocha.toml
		everforest_dark.toml
		everforest_light.toml
		one_dark.toml
ssh/
	config
```

## Quick install

Before running the installer, inspect `install.sh` to confirm it does what you expect. The script is intended to create symlinks or copy files into your home directory. Typical usage:

```bash
chmod +x install.sh
./install.sh
```

If you prefer a dry-run or want to control individual pieces, open `install.sh` and run parts of it manually.

## Adding new dotfile configurations

To add a new configuration, follow these steps:

1. **Add your config files to the repo:**

   - For application-specific config, create a directory under `config/` (e.g., `config/nvim/`).
   - For single dotfiles, place them at the repo root with a leading dot (e.g., `.zshrc`, `.vimrc`).

2. **Add a symlink entry to `install.sh`:**

   - Open `install.sh` and find the section where other configs are linked (look for the "--- 1. Alacritty", "--- 2. Git" sections).
   - Add a new section with an incremented number, following this pattern:

   ```bash
   # --- X. Description (target path) ---
   log "Linking ..."
   symlink "$DOTFILES_DIR/path/to/source" "$HOME/path/to/target"
   ```

### Example: adding Neovim config

1. Create the directory structure:

   ```bash
   mkdir -p config/nvim
   # Copy or create your nvim config files here
   # For example: config/nvim/init.lua, config/nvim/lua/, etc.
   ```

2. Add this section to `install.sh` (after the SSH section, before the "--- Done ---" comment):

   ```bash
   # --- 4. Neovim config (~/.config/nvim) ---
   log "Linking Neovim config..."
   symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
   ```

### Example: adding a `.zshrc` dotfile

1. Add the dotfile to the repo root:

   ```bash
   # Copy your .zshrc to the repo root
   cp ~/.zshrc .zshrc
   ```

2. Add this section to `install.sh`:

   ```bash
   # --- 5. Zsh config (~/.zshrc) ---
   log "Linking Zsh config..."
   symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
   ```

### Key points

- The `symlink()` helper handles backing up existing files, creating parent directories, and ensuring idempotency (safe to run multiple times).
- Always use `$DOTFILES_DIR` as the source prefix to ensure absolute paths.
- If a config needs special permissions (like SSH), add `chmod` commands after the `symlink()` call (see the SSH section for reference).
- After adding entries, commit the new configs and the updated `install.sh` to git.

## Notes & assumptions

- This is my personal configuration. Use it as a reference or starting point — it reflects my preferences and may overwrite existing settings.
- I assume you have basic tools like `bash`/`zsh`, `git`, and any application the configs target (e.g., Alacritty) installed on your system.
- Inspect `install.sh` before running to avoid accidental overwrites.

## Contributing

This repository is primarily for personal use. If you find something useful and want to contribute, feel free to open an issue or send a pull request (but please be mindful that this is tailored to my setup).

## License

You may use or adapt these configs; no warranty provided. If you want a formal license, I can add one on request.

---

Maintainer: (personal dotfiles) — replace or add contact info here if you want.
