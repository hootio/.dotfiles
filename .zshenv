# rust
. "$HOME/.cargo/env"

# go(lang)
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GOROOT="$(brew --prefix golang)/libexec"
export PATH=$PATH:$GOBIN:$GOROOT/bin
