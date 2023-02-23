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
# TODO: When doing a command such as `git add <tab>` no completion is done.
#       Make it go through directory files similar to `ls <tab>`

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# prompt #
eval "$(starship init zsh)"
export STARSHIP_CONFIG=$HOME/.starship.toml


# aliases #
alias l="ls -al --color"
alias ll=l
alias cat=bat
alias grep=rg
alias config="git --git-dir=$HOME/github/.dotfiles/ --work-tree=$HOME"
alias gl="git log"
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
