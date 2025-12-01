# rust
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
else
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# brew on linux
if [ -d "$HOME/.brew" ]; then
  export PATH="$HOME/.brew/bin:$HOME/.brew/sbin:$PATH"
fi
