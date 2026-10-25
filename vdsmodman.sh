#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODS_FILE="$SCRIPT_DIR/mods.yml"
if ! DOWNLOAD_DIR="$(mktemp -d)"; then
  printf 'Unable to create temporary download directory\n' >&2
  exit 1
fi
trap 'rm -rf "$DOWNLOAD_DIR"' EXIT

source "$SCRIPT_DIR/mods.conf"

# Usage: clear_mod_directory <path>
clear_mod_directory() {
  local path="$1"
  rm -rf "$path"
  mkdir -p "$path"
}

# Usage: install_thunderstore_mods <path> <yq paths...>
install_thunderstore_mods() {
  local path="$1"
  shift # Remove the path argument, rest are yq paths
  local -a yq_paths=("$@")
  local -a mods

  mapfile -t mods < <(
      for yq_path in "${yq_paths[@]}"; do
          yq -r "(${yq_path} // [])[]" "$MODS_FILE"
      done | sort -u
  )

  for mod in "${mods[@]}"; do
    if [[ ! "$mod" =~ ^([^-]+)-(.+)-([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
      printf 'Invalid Thunderstore mod format: %s\n' "$mod" >&2
      return 1
    fi

    local owner="${BASH_REMATCH[1]}"
    local name="${BASH_REMATCH[2]}"
    local version="${BASH_REMATCH[3]}"
    local archive="$DOWNLOAD_DIR/${mod}.zip"
    local url="https://thunderstore.io/package/download/${owner}/${name}/${version}"

    if ! curl -fsSL -o "$archive" "$url"; then
      rm -f "$archive"
      return 1
    fi
    if ! unzip -oq "$archive" -d "$path/${mod}"; then
      rm -f "$archive"
      return 1
    fi
    rm -f "$archive"
  done
}

# Usage: install_github_mods <path> <yq paths...>
install_github_mods() {
  local path="$1"
  shift
  local -a yq_paths=("$@")

  mapfile -t mods < <(
      for yq_path in "${yq_paths[@]}"; do
          yq -r "(${yq_path} // [])[]" "$MODS_FILE"
      done | sort -u
  )

  for mod in "${mods[@]}"; do
    if [[ ! "$mod" =~ ^([^-]+)-(.+)-([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
      printf 'Invalid GitHub mod format: %s\n' "$mod" >&2
      return 1
    fi

    local owner="${BASH_REMATCH[1]}"
    local repository="${BASH_REMATCH[2]}"
    local version="${BASH_REMATCH[3]}"
    local archive_name="${mod}.zip"
    local archive="$DOWNLOAD_DIR/$archive_name"
    local url="https://github.com/${owner}/${repository}/releases/download/${version}/${archive_name}"

    if ! curl -fsSL -o "$archive" "$url"; then
      rm -f "$archive"
      return 1
    fi
    if ! unzip -oq "$archive" -d "$path/${mod}"; then
      rm -f "$archive"
      return 1
    fi
    rm -f "$archive"
  done
}

clear_mod_directory "$BEPINEX_PLUGINS_DIR"
clear_mod_directory "$MODSYNC_REQUIRED_MODS_DIR"
clear_mod_directory "$MODSYNC_OPTIONAL_MODS_DIR"

install_github_mods "$BEPINEX_PLUGINS_DIR" '.github.both' '.github.server'
install_github_mods "$MODSYNC_REQUIRED_MODS_DIR" '.github.both' '.github.client.required'
install_github_mods "$MODSYNC_OPTIONAL_MODS_DIR" '.github.client.optional'

install_thunderstore_mods "$BEPINEX_PLUGINS_DIR" '.thunderstore.both' '.thunderstore.server'
install_thunderstore_mods "$MODSYNC_REQUIRED_MODS_DIR" '.thunderstore.both' '.thunderstore.client.required'
install_thunderstore_mods "$MODSYNC_OPTIONAL_MODS_DIR" '.thunderstore.client.optional'