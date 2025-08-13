#!/usr/bin/env bash
set -euo pipefail

show_help() {
  cat <<'USAGE'
Usage: scripts/evals/supercede-eval.sh --new <new-eval.md> --prev <prev-eval.md> --delta-trend <positive|negative|neutral>

Supersede an eval by archiving the previous one and wiring frontmatter.

Required:
  --new          Path to the new eval file
  --prev         Path to the previous eval file to archive
  --delta-trend  One of: positive, negative, neutral

Behavior:
  - Validates both files and their YAML frontmatter
  - Sets on previous eval: status: archived, archived_at: <today>, superseded_by: <new>
  - Sets on new eval: supersedes: <prev>, delta_trend: <value>
  - Moves previous eval to: <prev-dir>/archive/<YYYY>/<filename>
USAGE
}

NEW=""
PREV=""
DELTA_TREND=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --new)
      NEW=${2:-}; shift 2;;
    --prev)
      PREV=${2:-}; shift 2;;
    --delta-trend)
      DELTA_TREND=${2:-}; shift 2;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown arg: $1" >&2; show_help; exit 2;;
  esac
done

if [[ -z "$NEW" || -z "$PREV" || -z "$DELTA_TREND" ]]; then
  echo "Missing required arguments" >&2
  show_help
  exit 2
fi

case "$DELTA_TREND" in
  positive|negative|neutral) ;;
  *) echo "--delta-trend must be positive|negative|neutral" >&2; exit 2;;
esac

if [[ ! -f "$NEW" ]]; then echo "New eval not found: $NEW" >&2; exit 1; fi
if [[ ! -f "$PREV" ]]; then echo "Previous eval not found: $PREV" >&2; exit 1; fi

require_frontmatter() {
  local file="$1"
  local first
  first=$(head -n1 "$file" || true)
  if [[ "$first" != "---" ]]; then
    echo "File missing YAML frontmatter (expected starting '---'): $file" >&2
    exit 1
  fi
}

require_frontmatter "$NEW"
require_frontmatter "$PREV"

set_or_insert_yaml_key() {
  local file="$1"; shift
  local key="$1"; shift
  local value="$1"; shift
  # Replace within first frontmatter section if present; otherwise insert after first '---'
  if awk 'BEGIN{found=0; fm=0} /^---\s*$/{fm++} fm==1 && $0 ~ /^'"$key"':/{found=1} END{exit (found?0:1)}' "$file"; then
    # Key exists in frontmatter; replace it
    sed -E -i.bak "/^---$/,/^---$/ s/^($key:).*/\\1 $value/" "$file"
  else
    # Insert after the first '---' line
    sed -E -i.bak "0,/^---$/ s//---\n$key: $value/" "$file"
  fi
  rm -f "$file.bak"
}

today=$(date +%F)

# Update previous eval frontmatter
set_or_insert_yaml_key "$PREV" "status" "archived"
set_or_insert_yaml_key "$PREV" "archived_at" "$today"
set_or_insert_yaml_key "$PREV" "superseded_by" "$NEW"

# Update new eval frontmatter
set_or_insert_yaml_key "$NEW" "supersedes" "$PREV"
set_or_insert_yaml_key "$NEW" "delta_trend" "$DELTA_TREND"

# Move previous eval to archive/YYYY/
prev_dir=$(dirname "$PREV")
prev_base=$(basename "$PREV")
# Try to extract year from filename (leading 4 digits); fallback to current year
year=$(echo "$prev_base" | sed -nE 's/^([0-9]{4}).*/\1/p')
if [[ -z "$year" ]]; then year=$(date +%Y); fi
archive_dir="$prev_dir/archive/$year"
mkdir -p "$archive_dir"
target="$archive_dir/$prev_base"

if [[ -f "$target" ]]; then
  echo "Archive target already exists: $target" >&2
  exit 1
fi

mv "$PREV" "$target"

echo "Archived previous eval to: $target"
echo "Updated frontmatter on new eval: $NEW (supersedes, delta_trend=$DELTA_TREND)"


