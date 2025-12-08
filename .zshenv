# rust
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
else
  export PATH="$HOME/.cargo/bin:$PATH"
fi

