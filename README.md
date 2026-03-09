# KH1FM Randomizer

A new version of Kingdom Hearts 1 Final Mix randomizer, including support for Archipelago.
Creates installable OpenKH mods.
Uses file patching instead of strictly memory edits where viable.

## Installation

1. Ensure you have Python 3.12 or later installed.
2. Clone or download this repository.
3. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

## Usage

### Generating a seed
Seed generation works via Archipelago.  Seeds can be generated:
- On [kh1fmrando.com](https://www.kh1fmrando.com/generate_a_seed.html) via an Archipelago backend instance
- On [archipelago.gg](https://archipelago.gg/games/Kingdom%20Hearts/player-options) via Archipelago main (can have outdated AP World)
- Locally via an [installation of Archipelago](https://archipelago.gg/tutorial/Archipelago/setup_en)

Following one of these methods, you can get your patch for your seed (`.kh1rpatch` for latest or `.zip` for legacy).

### Mod Generator
Run `mod_generator.py` to generate mods. This provides a GUI for configuring and generating randomized mods.
You must have extracted your KH1 data via OpenKH to use the mod generator.
Input your patch (`.kh1rpatch` or `.zip`) and KH1 data location to the mod generator to generate your mod.
Your mod will appear in the `/Output/` folder.

## Troubleshooting

- If you encounter import errors, ensure all dependencies are installed via `pip install -r requirements.txt`.
- The executable assumes its placement will be similar to the repository relative to the `mod_generator_presets.json` file and the directories (`AP World`, `Corrected EVDLs`, `Documentation`, etc)
- For help troubleshooting, reach out on the [discord server](https://discord.com/invite/Vg55Ew4a)

## Building Executables

Use the following command to build a standalone executable for the mod_generator:
- `pyinstaller --noconsole --onefile --icon=./Images/config_icon.ico mod_generator.py --splash "./Images/splash.png"`

## License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.

<parameter name="filePath">c:\Users\gaith\Documents\GitHub\KH1FM-RANDOMIZER\README.md