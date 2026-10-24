# vdsmodman

Mod Manager for Valheim Dedicated Servers on Debian-based distributions. 

The script is idempotent; it clears old data and performs a fresh download on every run.

Dependencies are not resolved.

> [!WARNING]  
> Ensure all variables in mods.conf are set correctly.  
> Script cleans up using rm -rf without asking for confirmation.

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

```yaml
# Thunderstore format (Owner-Name-Version)
# BepInEx/plugins
server:
  - ValheimModding-Jotunn-2.30.2
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