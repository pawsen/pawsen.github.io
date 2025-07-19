#!/usr/bin/env bash
set -euo pipefail

# Usage: prune.sh [-n|--dry-run] [-v|--verbose]
# Purges everything under ./content and ./static except a whitelist.

dry_run=0
verbose=0

for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) dry_run=1 ;;
    -v|--verbose) verbose=1 ;;
    -h|--help)
      sed -n '1,/^$/p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 2
      ;;
  esac
done

keep_files_content=(
  "content/about.md"
  "content/search.md"
)

keep_paths_static=(
  "static/.gitkeep"
  "static/css"
  "static/js"
  "static/photoswipe"
)


keep_paths_assets=()

require_dir() {
  [[ -d "$1" ]] || { echo "Directory '$1' not found" >&2; exit 3; }
}

require_dir content
require_dir static

# Resolve real paths; if an entry is missing (e.g. .gitkeep may be absent) we still continue.
resolve_whitelist() {
  local -n src_array=$1
  local -n dest_array=$2
  dest_array=()
  for p in "${src_array[@]}"; do
    if [[ -e "$p" ]]; then
      dest_array+=("$(realpath "$p")")
    else
      [[ $verbose -eq 1 ]] && echo "NOTE: whitelist item '$p' does not exist (skipping)."
    fi
  done
}

mapfile -t keep_content_real < <(for p in "${keep_files_content[@]}"; do [[ -e "$p" ]] && realpath "$p"; done)
mapfile -t keep_static_real  < <(for p in "${keep_paths_static[@]}";  do [[ -e "$p" ]] && realpath "$p"; done)

purge_dir() {
  local dir="$1"; shift
  local -n whitelist="$1"
  echo "Purging $dir ..."
  # Enumerate all entries beneath dir (files and dirs)
  while IFS= read -r -d '' item; do
    local rp keep=false
    rp=$(realpath "$item")
    for k in "${whitelist[@]}"; do
      if [[ "$rp" == "$k" || "$rp" == "$k/"* ]]; then
        keep=true
        break
      fi
    done
    if $keep; then
      [[ $verbose -eq 1 ]] && echo "KEEP:   $item"
    else
      if [[ $dry_run -eq 1 ]]; then
        echo "DELETE: $item"
      else
        [[ $verbose -eq 1 ]] && echo "DELETE: $item"
        rm -rf -- "$item"
      fi
    fi
  done < <(find "$dir" -mindepth 1 -maxdepth 99 -print0)
}

if [[ $dry_run -eq 1 ]]; then
  echo "[DRY RUN] No deletions will be performed."
  verbose=1  # Implicit verbose during dry-run
fi

purge_dir "content" keep_content_real
purge_dir "static"  keep_static_real
purge_dir "assets"  keep_paths_assets


echo "Done."
