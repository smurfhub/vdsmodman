# vdsmodman

Valheim Dedicated Server Mod Manager

Bash script that simplifies mod maintenance on a Valheim dedicated server. Designed for Ubuntu-like distros.

It only downloads mods from [Thunderstore](https://thunderstore.io) and unzips each package. It supports:

- **BepInEx plugins**: server-side mods, installed in `BepInEx/plugins`.
- **ModSync**: controls which mods the client must have (required) and which are optional.

## QuickStart

```bash
git clone https://github.com/smurfhub/vdsmodman.git
export VALHEIM_SERVER_DIR=/path/to/valheim/server
./vdsmodman.sh
```

## Requirements

`yq`, `curl` and `unzip`.

```bash
sudo apt update && sudo apt install -y yq curl unzip
```

## Configuration

### mods.yml

Three lists, each entry in Thunderstore `Owner-Name-Version` format:

```yaml
server:                  # installed in BepInEx/plugins
  - ValheimModding-Jotunn-2.30.2
  - MidnightMods-NetworkPerformanceSystem-1.18.0

client:
  required:              # ModSync: clients must have them
    - McLovin-McPortalMetal-1.0.0
  optional:              # ModSync: clients may have them
    - VentureValheim-Venture_Farm_Grid-1.0.0
```

- Use the exact `Owner-Name-Version` from the Thunderstore package page.
- Each entry must start with `- `.
- Dependencies are not resolved: list every required mod (e.g. Jotunn).

### mods.conf

| Variable | Description |
|---|---|
| `THUNDERSTORE_DOWNLOAD_URL` | Thunderstore download URL. Leave the default. |
| `VALHEIM_SERVER_DIR` | Path to the server. Defaults to `.` if not set. |
| `BEPINEX_PLUGINS_DIR` | Destination of `server` mods. |
| `MODSYNC_REQUIRED_MODS_DIR` | Destination of `client.required` mods. |
| `MODSYNC_OPTIONAL_MODS_DIR` | Destination of `client.optional` mods. |

Missing destination directories are created automatically.
