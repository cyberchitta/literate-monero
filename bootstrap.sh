#!/bin/bash
# bootstrap.sh - Initial setup for literate-monero installation
#
# This script:
# 1. Updates the system
# 2. Installs Emacs (terminal mode)
# 3. Installs Ansible
# 4. Configures Emacs for Org-mode
# 5. Configures tmux for persistent sessions
# 6. Creates directory structure
# 7. Installs Ansible collections
#
# Run this FIRST on a fresh Omarchy installation.

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Literate Monero Bootstrap ===${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}ERROR: Do not run this script as root${NC}"
   echo "Run as your dev user account"
   exit 1
fi

# Verify we're running as dev
if [ "$(whoami)" != "dev" ]; then
   echo -e "${YELLOW}WARNING: Expected username 'dev' but running as '$(whoami)'${NC}"
   echo ""
   echo "This system is designed for privacy-first workflow with 'dev' as the primary user."
   echo "If you created a different username during Omarchy install, you'll need to update"
   echo "config.yml to match (set dev_user: $(whoami))"
   echo ""
   read -p "Continue anyway? (y/N) " -n 1 -r
   echo
   if [[ ! $REPLY =~ ^[Yy]$ ]]; then
       echo "Aborted."
       exit 1
   fi
fi

# Confirm before proceeding
echo "This script will install:"
echo "  - emacs-nox (terminal Emacs)"
echo "  - ansible"
echo "  - tmux"
echo "  - git (if not present)"
echo "  - Required Ansible collections"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Update system
echo -e "${YELLOW}→${NC} Updating system packages..."
sudo pacman -Syu --noconfirm

# Install base packages
echo -e "${YELLOW}→${NC} Installing base packages..."
sudo pacman -S --noconfirm \
    base-devel \
    git \
    emacs-wayland \
    tmux \
    ansible \
    bind-tools \
    curl \
    wget \
    htop \
    ufw

# Install yay (AUR helper)
echo -e "${YELLOW}→${NC} Installing yay (AUR helper)..."
if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
else
    echo -e "${GREEN}✓${NC} yay already installed"
fi

# Configure Emacs for Org-mode
echo -e "${YELLOW}→${NC} Configuring Emacs..."

# Backup existing .emacs if present
if [ -f ~/.emacs ]; then
    BACKUP_FILE=~/.emacs.backup.$(date +%Y%m%d_%H%M%S)
    echo -e "${YELLOW}  Backing up existing ~/.emacs to ${BACKUP_FILE}${NC}"
    cp ~/.emacs "$BACKUP_FILE"
fi

cat > ~/.emacs << 'EOF'
;; Minimal Emacs config for Org-mode and Ansible

;; Package management
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Org-mode configuration
(require 'org)

;; Enable shell script execution
(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (python . t)
   (emacs-lisp . t)))

;; Don't ask for confirmation when executing code
(setq org-confirm-babel-evaluate nil)

;; Syntax highlighting in code blocks
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-src-preserve-indentation t)

;; Better org-mode defaults
(setq org-hide-leading-stars t)
(setq org-startup-folded 'content)
(setq org-log-done 'time)

;; Theme for terminal
(load-theme 'tango-dark t)

;; Show line numbers
(global-display-line-numbers-mode 1)

;; Better backup behavior
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions t)
(setq kept-new-versions 6)
(setq kept-old-versions 2)
(setq version-control t)

;; YAML mode for Ansible files
(unless (package-installed-p 'yaml-mode)
  (package-refresh-contents)
  (package-install 'yaml-mode))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; Jinja2 mode for templating
(unless (package-installed-p 'jinja2-mode)
  (package-refresh-contents)
  (package-install 'jinja2-mode))

(require 'jinja2-mode)
(add-to-list 'auto-mode-alist '("\\.j2\\'" . jinja2-mode))

;; Show column number
(setq column-number-mode t)

;; Better scrolling
(setq scroll-conservatively 100)

;; Disable startup screen
(setq inhibit-startup-screen t)

;; Custom keybindings
(global-set-key (kbd "C-c t") 'org-babel-tangle)
EOF

# Configure tmux
echo -e "${YELLOW}→${NC} Configuring tmux..."
cat > ~/.tmux.conf << 'EOF'
# Tmux configuration for literate-monero management

# Better prefix key (C-a instead of C-b)
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Enable mouse support
set -g mouse on

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Increase scrollback buffer
set -g history-limit 10000

# Easy config reload
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Split panes with | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Switch panes with Alt+arrow (no prefix needed)
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Status bar
set -g status-position bottom
set -g status-bg colour234
set -g status-fg colour137
set -g status-left ''
set -g status-right '#[fg=colour233,bg=colour241,bold] %Y-%m-%d #[fg=colour233,bg=colour245,bold] %H:%M:%S '
set -g status-right-length 50
set -g status-left-length 20

# Window status
setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

# Activity monitoring
setw -g monitor-activity on
set -g visual-activity off
EOF

# Create directory structure (empty, will be populated by tangling)
echo -e "${YELLOW}→${NC} Creating directory structure..."
mkdir -p org
mkdir -p ansible
mkdir -p docs
mkdir -p configs
mkdir -p scripts

# Check if config.yml exists
if [ ! -f config.yml ]; then
    echo -e "${YELLOW}→${NC} Creating config.yml from template..."
    cp config.yml.example config.yml
    echo -e "${GREEN}✓${NC} Created config.yml - edit before running playbooks"
else
    echo -e "${GREEN}✓${NC} config.yml already exists"
fi

# Create .gitkeep files for empty directories that need to exist
touch ansible/.gitkeep
touch configs/.gitkeep
touch scripts/.gitkeep

# Install Ansible collections
echo -e "${YELLOW}→${NC} Installing Ansible collections..."
ansible-galaxy collection install community.general community.libvirt

echo ""
echo -e "${GREEN}✓ Bootstrap complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Start a tmux session:"
echo "     ${YELLOW}tmux new -s install${NC}"
echo ""
echo "  2. Open the installation document:"
echo "     ${YELLOW}emacs -nw org/install.org${NC}"
echo ""
echo "  3. Edit config.yml with your settings (REQUIRED):"
echo "     ${YELLOW}nano config.yml${NC}"
echo "     - Verify dev_user matches your username (should be 'dev')"
echo "     - Set your Monero wallet address"
echo ""
echo "  4. Read through org/install.org to understand the system"
echo ""
echo "  5. Tangle all org files to generate Ansible playbooks:"
echo "     ${YELLOW}./ansible/tangle-all.sh && ./ansible/assemble-playbook.sh${NC}"
echo ""
echo "  6. Validate configuration:"
echo "     ${YELLOW}ansible-playbook validate.yml${NC}"
echo ""
echo "  7. Run the installation phase-by-phase:"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags base -K${NC}"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags wireguard -K${NC}"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags privacy -K${NC}"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags i2p -K${NC}"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags monerod -K${NC}"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags users -K${NC}"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags mining -K${NC}"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags firewall -K${NC}"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags monitoring -K${NC}"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags backup -K${NC}"
echo "     ${YELLOW}ansible-playbook playbook.yml --tags verify -K${NC}"
echo ""
echo "Emacs quick reference:"
echo "  C-c C-c    Execute code block"
echo "  C-c C-v t  Tangle (generate files)"
echo "  C-x C-s    Save"
echo "  C-x C-c    Quit"
echo ""
echo "Tmux quick reference:"
echo "  C-a d      Detach session"
echo "  C-a |      Split vertically"
echo "  C-a -      Split horizontally"
echo ""
