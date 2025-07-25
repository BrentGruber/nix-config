# Nix-Darwin & Home Manager Configuration

This repository contains my macOS system configuration using nix-darwin and home-manager, providing a declarative way to manage system settings, packages, and dotfiles.

## Overview

This setup includes:
- **nix-darwin**: System-level configuration for macOS
- **home-manager**: User-level package and dotfile management
- **nix-homebrew**: Declarative Homebrew management
- Comprehensive development environment with multiple programming languages
- Custom shell configuration with zsh, oh-my-zsh, and starship prompt

## Key Features

### System Configuration
- Touch ID for sudo authentication
- Caps Lock remapped to Escape
- Dock auto-hide and Finder enhancements
- Custom keyboard repeat rates
- Screenshot location customization

### Development Environment
- Programming languages: Node.js, Python, Go, Rust, Zig, Nim, Crystal, Gleam, Elixir
- CLI tools: ripgrep, fd, kubectl, podman, jq, glow, and many more
- Text editor: Neovim with custom configuration
- Terminal: WezTerm with auto-updating config
- Version control: Git with GitHub CLI

### Shell Configuration
- Zsh with oh-my-zsh framework
- Syntax highlighting and autosuggestions
- Starship prompt
- FZF fuzzy finder integration
- Custom aliases and environment variables

## Installation

### Prerequisites
1. Install Nix with flakes support:
   ```bash
   sh <(curl -L https://nixos.org/nix/install)
   ```

2. Enable flakes in your nix configuration:
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

### Initial Setup
1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/.config/nix-darwin
   cd ~/.config/nix-darwin
   ```

2. Build and apply the configuration:
   ```bash
   darwin-rebuild build --flake .#simple
   darwin-rebuild switch --flake .#simple
   ```

## Usage

### Applying Configuration Changes

After making changes to any configuration files, apply them with:

```bash
darwin-rebuild switch --flake .#simple
```

This command will:
- Build the new configuration
- Switch to the new configuration
- Update both system and home-manager settings

### Alternative Commands

- **Build only** (without switching): `darwin-rebuild build --flake .#simple`
- **Check configuration**: `darwin-rebuild check --flake .#simple`

## File Structure

```
├── flake.nix           # Main flake configuration
├── home.nix            # Home Manager user configuration
├── homebrew.nix        # Homebrew package declarations
├── bat/                # Bat (cat replacement) configuration
├── eza/                # Eza (ls replacement) configuration  
├── nvim/               # Neovim configuration
├── wezterm/            # WezTerm terminal configuration
└── dotfiles/           # Dotfiles managed by home-manager
    ├── init.lua        # Neovim init file
    └── kube-config     # Kubernetes configuration
```

## Customization

### Adding Packages
- **System packages**: Add to `environment.systemPackages` in `flake.nix`
- **User packages**: Add to `home.packages` in `home.nix`
- **Homebrew packages**: Add to `homebrew.nix`

### Modifying System Settings
Edit the `system.defaults` section in `flake.nix` to customize macOS preferences.

### Shell Configuration
Modify the zsh configuration in `home.nix` to add aliases, change themes, or add plugins.

## Troubleshooting

### Permission Issues
If you encounter permission issues, ensure your user has the necessary permissions:
```bash
sudo chown -R $(whoami) /nix
```

### Rollback
To rollback to a previous generation:
```bash
darwin-rebuild --rollback
```

### Cleaning Up
Remove old generations:
```bash
nix-collect-garbage -d
```

## Notes

- The configuration uses the "simple" profile name as defined in `darwinConfigurations."simple"`
- WezTerm configuration is automatically updated from a separate GitHub repository
- Some applications may require manual setup after initial installation
- The configuration is set up for Apple Silicon Macs (`aarch64-darwin`)