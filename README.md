# Dotfiles

Personal dotfiles for Arch Linux + Hyprland, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

### 1. Install yay (AUR helper)

Built in `/tmp`:

```bash
sudo pacman -S --needed git base-devel
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### 2. Base packages

```bash
sudo pacman -S stow openssh neovim zellij curl wget unzip zip tar zsh
```

### 3. Essential packages

```bash
sudo pacman -S zoxide fzf eza ripgrep bat fd btop superfile
```

### 4. Hyprland requirements

> **Note:** use Hyprland **< 0.57** — the last version that supports `.conf` files as config files.

pacman:

```bash
sudo pacman -S hyprland hyprlock hypridle hyprpicker hyprpaper hyprsunset \
  hyprland-guiutils wl-clipboard waybar wofi mako yad alacritty rofi \
  pulsemixer hyprpolkitagent
```

Enable the polkit agent:

```bash
systemctl --user enable --now hyprpolkitagent.service
```

yay:

```bash
yay -S light
```

### 5. Fonts

JetBrainsMono Nerd Font:

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

### 6. Oh My Posh

Requires `curl` and `unzip` (installed above); `realpath` and `dirname` come from `coreutils` (preinstalled on Arch).

```bash
curl -s https://ohmyposh.dev/install.sh | bash -s
```

### 7. Apply the dotfiles

From the repo root (`~/.dotfiles`):

```bash
stow -t ~/.config config
stow --dotfiles ssh zsh
```

## Dev packages

### Essential

```bash
sudo pacman -S git neovim lazygit
```

### Docker

```bash
sudo pacman -S docker docker-compose docker-buildx
```

Enable Docker and add your user to the `docker` group:

```bash
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER
```

> **Note:** log out and back in (or reboot) for the group change to take effect.

### uv (Python package manager)

Installs `uv` and `uvx`:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Node.js (via fnm)

```bash
curl -fsSL https://fnm.vercel.app/install | bash
```

Then install the latest LTS Node.js:

```bash
fnm install --lts
```

### Bun

```bash
curl -fsSL https://bun.com/install | bash
```
