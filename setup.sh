#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID:-$(id -u)}" -eq 0 && -n "${SUDO_USER:-}" ]]; then
  echo "Run this script as your normal user, not with sudo. It will ask for sudo when needed." >&2
  exit 1
fi

case "$(uname -s)" in
  Darwin)
    exec "$ROOT/mac/setup.sh"
    ;;
  Linux)
    exec "$ROOT/linux/setup.sh"
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac
