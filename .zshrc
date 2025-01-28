# plugins #
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh


# configs #
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.zsh_history
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY

# turn on default zsh completions
autoload -Uz compinit && compinit
# use case-insensitive if case-sensitive result not found. ex: ls desk<tab>
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
# immediately launches select menu without asking for confirmation. ex: rsync -<tab>
zstyle ':completion:*' menu yes select
# TODO: When using the alias command `config add <tab>` no completion is done.
#       Make it go through directory files similar to `git add <tab>`

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# prompt #
eval "$(starship init zsh)"
export STARSHIP_CONFIG=$HOME/.starship.toml


# aliases #
alias config="git --git-dir=$HOME/github/.dotfiles/ --work-tree=$HOME"
alias l="ls -al --color"
alias ll=l
alias v=nvim
alias vi=nvim
alias vim=nvim
alias cat=bat
alias grep=rg
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gl="git log"
alias gp="git push"
alias gs="git status"


# attach to tmux session #
if [[ -z "$TMUX" ]]; then
    tmux a || tmux
fi
