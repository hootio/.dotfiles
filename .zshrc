# plugins #
source <(fzf --zsh)
BREW_PREFIX="$(brew --prefix)"
source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh


# configs #
export EDITOR="nvim"
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.zsh_history
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY

# turn on default zsh completions (refreshes cache weekly for speed)
autoload -Uz compinit
if [[ ! -f ~/.zcompdump ]] || [[ -n ~/.zcompdump(#qN.mw+1) ]]; then
  compinit
else
  compinit -C
fi
# use case-insensitive if case-sensitive result not found. ex: ls desk<tab>
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
# immediately launches select menu without asking for confirmation. ex: rsync -<tab>
zstyle ':completion:*' menu yes select
# behave like bash for word style, affecting option+arrow navigation
autoload -Uz select-word-style && select-word-style bash

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[1;9D' beginning-of-line
bindkey '^[[1;9C' end-of-line
bindkey '^[[27;9;13~' accept-line # ghostty override for cmd+enter to behave like enter


# prompt #
eval "$(starship init zsh)"
export STARSHIP_CONFIG=$HOME/.starship.toml


# aliases #
alias l="ls -al --color"
alias ll=l
alias v=nvim
alias vi=nvim
alias vim=nvim
alias grep=rg
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gl="git log"
alias gp="git push"
alias gs="git status"
alias config="git --git-dir=$HOME/github/.dotfiles/ --work-tree=$HOME"
compdef config=git
devmain() {
  if [ -z "$1" ]; then
    echo "Usage: devmain <YUBIKEY_OTP>"
    return 1
  fi
  dev connect -n hooti.sb -y "$1" -- sh -c 'tmux new-session -A -s main'
}
