# vdsmodman

Mod Manager for Valheim Dedicated Servers on Debian-based distributions. 

The script is idempotent; it clears old data and performs a fresh download on every run.

Dependencies are not resolved.

> [!WARNING]  
> The script replaces the contents of BepInEx/plugins and the two ModSync folders on every run. Any file there that is not listed in the configured mods YAML file is deleted.

## QuickStart

```bash
git clone https://github.com/smurfhub/vdsmodman.git
export VALHEIM_SERVER_DIR="/path/to/valheim/server"
./vdsmodman.sh
```

## Recommended

1. Clone the repository:
    ```bash
    git clone https://github.com/smurfhub/vdsmodman.git
    ```

2. Create a launcher script outside the repository directory:
    ```bash
    #!/usr/bin/env bash

     # export MODS_CONF="./mods.conf"
    export VALHEIM_SERVER_DIR="/path/to/valheim/server"
    export MODS_YML="./mods.yml"

    ./vdsmodman/vdsmodman.sh
    ```

3. Grant execution permissions:
    ```bash
    chmod +x ./vdsmodman/vdsmodman.sh
    chmod +x ./launcher.sh
    ```

4. Run:
    ```bash
    ./launcher.sh
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
| `MODS_CONF` | Path to the configuration file (defaults to `mods.conf` in the script directory) |
| `MODS_YML` | Path to the mods YAML file (defaults to `mods.yml` in the script directory) |
| `VALHEIM_SERVER_DIR` | Path to the server (Defaults to `.` if not set) |
| `BEPINEX_PLUGINS_DIR` | Path to BepInEx/plugins |
| `MODSYNC_REQUIRED_MODS_DIR` | Path to BepInEx/config/ModSync/required_mods |
| `MODSYNC_OPTIONAL_MODS_DIR` | Path to BepInEx/config/ModSync/optional_mods |