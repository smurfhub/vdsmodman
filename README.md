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

```yaml
# Thunderstore format (Owner-Name-X.Y.Z), e.g. ValheimModding-Jotunn-2.30.2
github:
  both:
    - Smurfhub-ModSync-0.3.3

thunderstore:
  both:
    - ValheimModding-Jotunn-2.30.2
    - ZenDragon-Zen_ModLib-1.14.22
    - ZenDragon-ZenBossStone-1.0.3

  server:
    - ArgusMagnus-ServersideQoL-2.4.3

  client:
    required:
      - Goldenrevolver-Quick_Stack_Store_Sort_Trash_Restock-1.4.16
    
    optional:
      - ZenDragon-ZenUI-1.9.3
```

### mods.conf

| Variable | Description |
|---|---|
| `VALHEIM_SERVER_DIR` | Path to the server (Defaults to `.` if not set) |
| `BEPINEX_PLUGINS_DIR` | Path to BepInEx/plugins |
| `MODSYNC_REQUIRED_MODS_DIR` | Path to BepInEx/config/ModSync/required_mods |
| `MODSYNC_OPTIONAL_MODS_DIR` | Path to BepInEx/config/ModSync/optional_mods |