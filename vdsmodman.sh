#!/usr/bin/env bash

source ./mods.conf

# Usage: install_mods <path> <yq paths...>
install_mods() {
  local path="$1"
  shift # Remove the path argument, rest are yq paths
  local -a yq_paths=("$@")

  rm -rf "$path"
  mkdir -p "$path"

  mapfile -t mods < <(
      for yq_path in "${yq_paths[@]}"; do
          yq -r "${yq_path}[]" ./mods.yml
      done | sort -u
  )

  if [ ${#mods[@]} -eq 0 ]; then
      return 0
  fi

  for mod in "${mods[@]}"; do
    curl -fsSL -o "${mod}.zip" "$THUNDERSTORE_DOWNLOAD_URL${mod//-//}"
    unzip -oq "${mod}.zip" -d "$path/${mod}"
    rm -f "${mod}.zip"
  done
}

install_mods "$BEPINEX_PLUGINS_DIR" '.both' '.server' 
install_mods "$MODSYNC_REQUIRED_MODS_DIR" '.both' '.client.required'
install_mods "$MODSYNC_OPTIONAL_MODS_DIR" '.client.optional'