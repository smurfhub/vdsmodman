#!/usr/bin/env bash

source ./mods.conf

TMP_ROOT="$(mktemp -d)" || exit 1
trap 'rm -rf "$TMP_ROOT"' EXIT

# Thunderstore format: Owner-Name-Version
MOD_REGEX='^[A-Za-z0-9_]+-[A-Za-z0-9_]+-[0-9]+\.[0-9]+\.[0-9]+$'

# Usage: install_mods <yq_list_path> <dest_dir> <required_dest_suffix>
# Downloads and extracts every mod into a temp dir. The destination is replaced only if all mods succeed.
install_mods() {
  echo "Installing from $1..."
  local list_path="$1" dest_dir="$2" dest_suffix="$3" mod url list stage
  local -a mods

  # Only replace a destination that lives inside the server dir and ends with the expected path
  [[ -n "${VALHEIM_SERVER_DIR:-}" && "$VALHEIM_SERVER_DIR" != "/" ]] || { echo "ERROR - invalid server dir" >&2; return 1; }
  [[ "$dest_dir" == "$VALHEIM_SERVER_DIR/$dest_suffix" && "$dest_dir" != "/$dest_suffix" ]] || { echo "ERROR - invalid destination: $dest_dir" >&2; return 1; }

  list="$(yq -r "${list_path}[]" ./mods.yml)" || { echo "ERROR - cannot read $list_path from mods.yml" >&2; return 1; }
  if [[ -z "$list" ]]; then
    echo "WARNING - no mods listed in $list_path, destination left untouched" >&2
    return 0
  fi
  mapfile -t mods <<< "$list"

  for mod in "${mods[@]}"; do
    [[ "$mod" =~ $MOD_REGEX ]] || { echo "ERROR - invalid mod name: $mod" >&2; return 1; }
  done

  stage="$(mktemp -d -p "$TMP_ROOT")" || { echo "ERROR - temp dir failed" >&2; return 1; }

  for mod in "${mods[@]}"; do
    url="$THUNDERSTORE_DOWNLOAD_URL${mod//-//}"
    curl -fsSL -o "$stage/${mod}.zip" "$url" 2>/dev/null || { echo "ERROR - download failed: $mod" >&2; return 1; }
    mkdir -p "$stage/$mod" || { echo "ERROR - mkdir failed: $mod" >&2; return 1; }
    # unzip rc 1 = warnings only (e.g. backslash separators); files are extracted
    unzip -oq "$stage/${mod}.zip" -d "$stage/$mod" 2>/dev/null; (( $? <= 1 )) || { echo "ERROR - extraction failed: $mod" >&2; return 1; }
    rm -f "$stage/${mod}.zip"
  done

  rm -rf "$dest_dir" || { echo "ERROR - cleanup failed: $dest_dir" >&2; return 1; }
  mkdir -p "$(dirname "$dest_dir")" || { echo "ERROR - mkdir failed: $dest_dir" >&2; return 1; }
  mv "$stage" "$dest_dir" || { echo "ERROR - install failed: $dest_dir" >&2; return 1; }
  chmod 755 "$dest_dir"
}

rc=0
install_mods '.server'          "$BEPINEX_PLUGINS_DIR"        "BepInEx/plugins"                       || rc=1
install_mods '.client.required' "$MODSYNC_REQUIRED_MODS_DIR"  "BepInEx/config/ModSync/required_mods" || rc=1
install_mods '.client.optional' "$MODSYNC_OPTIONAL_MODS_DIR"  "BepInEx/config/ModSync/optional_mods" || rc=1
exit $rc
