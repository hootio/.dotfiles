# user binaries
export PATH="$HOME/.local/bin:$PATH"

# rust toolchain (rustc, cargo) — homebrew's rustup is keg-only, so its shims
# are not linked into the brew prefix and must be added to PATH explicitly
if [ -d "/opt/homebrew/opt/rustup/bin" ]; then
  export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
fi

# binaries installed via `cargo install`
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
else
  export PATH="$HOME/.cargo/bin:$PATH"
fi

