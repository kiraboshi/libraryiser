#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_FILE="$ROOT_DIR/AGENTS.md"

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "Source file not found: $SOURCE_FILE" >&2
  exit 1
fi

TARGET_NAMES=(
  ".cursorrules"  # Cursor
  "GEMINI.md"     # Gemini
  "CLAUDE.md"     # Claude
  "QWEN.md"       # Qwen
  "CODEX.md"      # Codex
  "OPENCODE.md"   # OpenCode
)

sync_file() {
  local path="$1"
  if [[ "$DRY_RUN" == true ]]; then
    echo "Would sync -> $path"
  else
    mkdir -p "$(dirname "$path")"
    cp -f "$SOURCE_FILE" "$path"
    echo "Synced -> $path"
  fi
}

# 1) Root-level targets
for name in "${TARGET_NAMES[@]}"; do
  sync_file "$ROOT_DIR/$name"
done

echo "Done."


