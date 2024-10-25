# Set LOCAL BIN DIR
export LOCAL_BIN_DIR="${HOME}/.local/bin"
# First: add local bin dir to PATH
[[ "$PATH" =~ "$LOCAL_BIN_DIR" ]] || export PATH="$PATH:$LOCAL_BIN_DIR"

# Set the Directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load Completions first
autoload -Uz compinit
compinit

# Load Zinit's basics (For MacOS only)
# This code block is for first time to initialize compinit, can comment it after
if [[ $SYS_ARCH =~ 'darwin_(amd|arm)64' ]]; then
	autoload -Uz _zinit
	(( ${+_comps} )) && _comps[zinit]=_zinit  # Fixed the *comps typo here
fi

# Add in zsh plugins
zinit ice depth=1; zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light Aloxaf/fzf-tab
zinit ice depth=1; zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1; zinit light zsh-users/zsh-syntax-highlighting

# Add in snippets (OHMYZSH Plugins)
zinit snippet OMZP::git
zinit snippet OMZP::sudo

# Recomanded by zinit docs
zinit cdreplay -q

# Key Binding v for vim mode, and e for emacs mode
bindkey -v
bindkey '^[[A'  history-search-backward           # Up   Arrow
bindkey '^[[B'  history-search-forward            # Down Arrow
bindkey '^p'    history-search-backward           # Cntl p
bindkey '^n'    history-search-forward            # Cntl n

# History
HISTSIZE=7000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors  "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# SSH functions
function __connect_ssh_to_jchakir () {
  ssh -p ${2:-22} ${1:-$USER}@jchakir.com
}
function __connect_ssh_to_snow-crash () {
  ssh -p ${2:-4242} ${1:-level00}@jchakir.com
}
alias sshjchakir='__connect_ssh_to_jchakir $1 $2'
alias sshjchak='__connect_ssh_to_jchakir $1 $2'
alias sshsnowcrash='__connect_ssh_to_snow-crash $1 $2'
alias sshsnow='__connect_ssh_to_snow-crash $1 $2'

# Shell integrations
eval "$(fzf --zsh)" # integrate fzf

# Setup OH-MY-POSH prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/custom-atomicBit.toml)"


