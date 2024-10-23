# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Set the Directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"


# Download Zinit if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi


# Load zinit
source "${ZINIT_HOME}/zinit.zsh"


# Add in powerlevel10k theme
zinit ice depth=1; zinit light romkatv/powerlevel10k


# Add in zsh plugins
zinit ice depth=1; zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1; zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1; zinit light Aloxaf/fzf-tab


# Add in snippets (OHMYZSH Plugins)
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found


# Recomanded by zinit docs
zinit cdreplay -q


# Load Completions
autoload -U compinit && compinit


# Key Binding v for vim mode, and e for emacs mode
bindkey -v
bindkey '^[[A' history-search-backward     # Up   Arrow
bindkey '^[[B' history-search-forward      # Down Arrow
bindkey '^p' history-search-backward       # Cntl p
bindkey '^n' history-search-forward        # Cntl n


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


# Aliases
alias ls='ls --color'


# Shell intergrations
eval "$(fzf --zsh)" # intergrate fzf

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
