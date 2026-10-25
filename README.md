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

Each source has the same lists: `both`, `server`, `client.required`, and
`client.optional`.

```yaml
github:
  both:
    - Smurfhub-ModSync-0.3.3

thunderstore:
  both:
    - ValheimModding-Jotunn-2.30.2
```

Thunderstore entries use the `Owner-Name-Version` format. GitHub entries use
`Owner-Repository-Version`; the script downloads the release asset named
`Owner-Repository-Version.zip` from that repository's matching release tag.

### mods.conf

| Variable | Description |
|---|---|
| `THUNDERSTORE_DOWNLOAD_URL` | Thunderstore download URL |
| `VALHEIM_SERVER_DIR` | Path to the server (Defaults to `.` if not set) |
| `BEPINEX_PLUGINS_DIR` | Path to BepInEx/plugins |
| `MODSYNC_REQUIRED_MODS_DIR` | Path to BepInEx/config/ModSync/required_mods |
| `MODSYNC_OPTIONAL_MODS_DIR` | Path to BepInEx/config/ModSync/optional_mods |