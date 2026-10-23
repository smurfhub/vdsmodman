#!/usr/bin/env bash

source ./mods.conf

# Usage: install_mods <yq_list_path> <dest_dir>
install_mods() {
  echo "Installing from $1..."
  local list_path="$1" dest_dir="$2" mod url
  local -a mods
  mapfile -t mods < <(yq -r "${list_path}[]" ./mods.yml)
  for mod in "${mods[@]}"; do
    url="$THUNDERSTORE_DOWNLOAD_URL${mod//-//}"
    curl -fsSL -o "${mod}.zip" "$url" 2>/dev/null || { echo "ERROR - download failed: $mod" >&2; continue; }
    mkdir -p "$dest_dir/${mod}" 2>/dev/null || { echo "ERROR - mkdir failed: $mod" >&2; rm -f "${mod}.zip"; continue; }
    unzip -oq "${mod}.zip" -d "$dest_dir/${mod}" 2>/dev/null; (( $? <= 1 )) || echo "ERROR - extraction failed: $mod" >&2
    rm -f "${mod}.zip"
  done
}

install_mods '.server'          "$BEPINEX_PLUGINS_DIR"
install_mods '.client.required' "$MODSYNC_REQUIRED_MODS_DIR"
install_mods '.client.optional' "$MODSYNC_OPTIONAL_MODS_DIR"