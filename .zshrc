# zsh configs

## up/down arrow search given string
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# plugins
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# aliases
alias l="ls -al --color"
alias ll=l
alias cat=bat
alias grep=rg
alias config="$(which git) --git-dir=$HOME/github/.dotfiles/ --work-tree=$HOME"

# go(lang)
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOBIN:${GOROOT}/bin

# prompt
# eval "$(starship init zsh)"
# export STARSHIP_CONFIG=~/.starship.toml
