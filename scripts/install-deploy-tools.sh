#!/usr/bin/env bash
#
# install-deploy-tools.sh — install the CLIs needed to DEPLOY this app.
#
# Deploying (`/deploy`, DEPLOYMENT.md) needs two CLIs that `./setup.sh` does NOT
# install (setup.sh only covers build/preview — npm deps + SDK skills):
#
#   • Playground CLI — deploys the frontend, registers the .dot domain, publishes.
#                      https://github.com/paritytech/playground-cli
#   • CDM CLI        — builds/deploys the Rust→PVM contract and registers it.
#                      https://github.com/paritytech/contract-dependency-manager
#
# Both installers build Rust components, so they need a C toolchain (`cc`) and a
# Rust toolchain present FIRST — otherwise the Rust step stalls on the cc linker
# or rustup. This script installs, in order: system deps → rust → the two CLIs.
#
# Idempotent: skips anything already present. Safe to re-run.
#
#   ./scripts/install-deploy-tools.sh
#
set -euo pipefail

# Pick up tools installed in a previous run even if the shell profile hasn't
# been re-sourced yet.
export PATH="$HOME/.cargo/bin:$HOME/.polkadot/bin:$HOME/.local/bin:$PATH"

log() { printf '==> %s\n' "$*"; }
warn() { printf '    %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

# --- 1. system deps: a C compiler/linker, make, curl -------------------------
install_system_deps() {
  if have curl && { have cc || have gcc; } && have make; then
    log "system deps present (curl, C toolchain, make)"
    return 0
  fi

  local sudo=""
  if [ "$(id -u)" -ne 0 ]; then
    if sudo -n true 2>/dev/null; then
      sudo="sudo"
    else
      warn "system deps (a C toolchain + curl) need root. Run the line for your OS,"
      warn "then re-run this script:"
      warn "  Debian/Ubuntu: sudo apt-get update && sudo apt-get install -y build-essential curl"
      warn "  Arch:          sudo pacman -Sy --needed base-devel curl"
      warn "  Fedora:        sudo dnf install -y gcc make curl"
      warn "  macOS:         xcode-select --install   (then: brew install curl)"
      return 0
    fi
  fi

  if have apt-get; then
    log "installing system deps via apt (build-essential, curl)"
    $sudo apt-get update -y && $sudo apt-get install -y build-essential curl
  elif have pacman; then
    log "installing system deps via pacman (base-devel, curl)"
    $sudo pacman -Sy --needed --noconfirm base-devel curl
  elif have dnf; then
    log "installing system deps via dnf (gcc, make, curl)"
    $sudo dnf install -y gcc make curl
  elif have brew; then
    log "installing curl via brew (Xcode CLT provides the C toolchain on macOS)"
    have curl || brew install curl
    have cc || warn "install the C toolchain: xcode-select --install"
  else
    warn "no known package manager — install a C toolchain (cc + make) and curl manually."
  fi
}

# --- 2. rust toolchain (installers build Rust; need cc present already) -------
install_rust() {
  if have rustc && have cargo; then
    log "rust toolchain present ($(rustc --version))"
  else
    log "installing rust via rustup"
    curl -fsSL https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
  fi
  # shellcheck source=/dev/null
  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
  # contract builds compile std from source for the PolkaVM target
  rustup component add rust-src >/dev/null 2>&1 || true
}

# --- 3. the two CLIs ---------------------------------------------------------
install_playground() {
  if have playground; then
    log "playground present ($(playground --version 2>/dev/null || echo '?'))"
  else
    log "installing Playground CLI"
    curl -fsSL https://raw.githubusercontent.com/paritytech/playground-cli/main/install.sh | bash \
      || warn "playground install failed — see output above"
  fi
}

install_cdm() {
  if have cdm; then
    log "cdm present ($(cdm --version 2>/dev/null || echo '?'))"
  else
    log "installing CDM CLI"
    curl -fsSL https://raw.githubusercontent.com/paritytech/contract-dependency-manager/main/install.sh | bash \
      || warn "cdm install failed — see output above"
  fi
}

install_system_deps
install_rust
install_playground
install_cdm

# --- summary -----------------------------------------------------------------
export PATH="$HOME/.cargo/bin:$HOME/.polkadot/bin:$HOME/.local/bin:$PATH"
log "summary (open a fresh shell if anything is still missing — installers update your PATH):"
for t in curl cc make rustup cargo playground cdm; do
  if have "$t"; then printf '      ✓ %s\n' "$t"; else printf '      ✗ %s (still missing)\n' "$t"; fi
done
