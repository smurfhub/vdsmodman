# vdsmodman

Mod Manager for Valheim Dedicated Servers on Debian-based distributions. 

The script is idempotent; it clears old data and performs a fresh download on every run.

Dependencies are not resolved.

> [!WARNING]  
> The script replaces the contents of BepInEx/plugins and the two ModSync folders on every run. Any file there that is not listed in mods.yml is deleted.

## QuickStart

1. Download
    ```bash
    git clone https://github.com/smurfhub/vdsmodman.git
    ```
2. Update mods.yml and mods.conf
3. Set server env var
    ```bash
    export VALHEIM_SERVER_DIR=/path/to/valheim/server
    ```
4. Grant execution permissions
    ```bash
    chmod +x vdsmodman.sh
    ```
4. Run
    ```bash
    ./vdsmodman.sh
    ```

## Requirements

`git`, `yq`, `curl` and `unzip`.

```bash
apt install -y git yq curl unzip
```

## Configuration

### mods.yml

| List | Description |
|---|---|
| `both` | List of mods used by both the server and the client (required) |
| `server` | List of mods used exclusively by the server |
| `client.required` | List of mods used exclusively by the client (required) |
| `client.optional` | List of mods that are optional and exclusively by the client |


```yaml
# Thunderstore format (Owner-Name-X.Y.Z), e.g. ValheimModding-Jotunn-2.30.2
# Entries that do not match this format are rejected
# BepInEx/plugins && BepInEx/config/ModSync
both:
  - ValheimModding-Jotunn-2.30.2

# BepInEx/plugins
server:
  - MidnightMods-NetworkPerformanceSystem-1.18.0

# BepInEx/config/ModSync
client:
  required:
    - McLovin-McPortalMetal-1.0.0
  
  optional:
    - VentureValheim-Venture_Farm_Grid-1.0.0
```

### mods.conf

| Variable | Description |
|---|---|
| `THUNDERSTORE_DOWNLOAD_URL` | Thunderstore download URL |
| `VALHEIM_SERVER_DIR` | Path to the server (Defaults to `.` if not set) |
| `BEPINEX_PLUGINS_DIR` | Path to BepInEx/plugins |
| `MODSYNC_REQUIRED_MODS_DIR` | Path to BepInEx/config/ModSync/required_mods |
| `MODSYNC_OPTIONAL_MODS_DIR` | Path to BepInEx/config/ModSync/optional_mods |