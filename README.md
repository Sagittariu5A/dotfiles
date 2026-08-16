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

#### Display manager (ly)

```bash
sudo pacman -S ly
sudo systemctl enable ly@tty2
sudo systemctl disable getty@tty1
```

> **Note:** ly runs on tty2; disabling `getty@tty1` removes the tty1 console so the machine boots straight into ly on tty2.

### 5. Fonts

pacman:

```bash
sudo pacman -S ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-iosevka-nerd \
  ttf-roboto-mono-nerd ttf-space-mono-nerd ttf-nerd-fonts-symbols \
  noto-fonts noto-fonts-cjk noto-fonts-emoji
```

yay (feather icon font, used by rofi menus):

```bash
yay -S ttf-icomoon-feather
```

Used by:

- **wofi / rofi / waybar / mako / wlogout**: JetBrainsMono Nerd Font, JetBrains Mono, Iosevka Nerd Font, Symbols Nerd Font
- **rofi menus** (powermenu, confirm, music, screenshot, asroot): feather icon font
- **hyprlock**: Iosevka Nerd Font, RobotoMono Nerd Font, SpaceMono Nerd Font, Symbols Nerd Font
- **GTK apps**: Noto Sans
- **CJK / emoji fallback**: Noto Sans/Serif CJK SC and Noto Color Emoji, configured via `config/fontconfig/fonts.conf` (deployed with the rest of `config` by stow; run `fc-cache -f` after changes)

### 6. Oh My Posh

Requires `curl` and `unzip` (installed above); `realpath` and `dirname` come from `coreutils` (preinstalled on Arch).

```bash
curl -s https://ohmyposh.dev/install.sh | bash -s
```

### 7. Apply the dotfiles

From the repo root (`~/.dotfiles`):

```bash
stow -t ~/.config config
stow --dotfiles ssh zsh git
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
