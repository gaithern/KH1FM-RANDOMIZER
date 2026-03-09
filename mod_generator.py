from gooey import Gooey,GooeyParser
from write_mod import write_mod
from globals import BASE_DIR, read_json, write_json
import os
import json
import zipfile
import ctypes
import requests
import webbrowser

# Constants for readability
MB_YESNO = 0x00000004
MB_ICONQUESTION = 0x00000020
IDYES = 6
IDNO = 7

VERSION = "1.1.0"

# Handle Splash Screen
try:
    import pyi_splash
    pyi_splash.close()
except:
    pass
# End Handle Splash Screen

def check_for_updates():
    initial_url = "https://github.com/gaithern/KH1FM-RANDOMIZER/releases/latest"
    response = requests.get(initial_url)
    final_url = response.url
    latest_version_number = final_url.split("/")[-1]
    if VERSION != latest_version_number:
        result = Mbox("Update available", "There is an update available for the mod generator and AP World.\n\n"
        "Would you like to open the download page now?",
        MB_YESNO | MB_ICONQUESTION)
        if result == IDYES:
            webbrowser.open("https://github.com/gaithern/KH1FM-RANDOMIZER/releases/latest")
            exit(0)

def Mbox(title, text, style):
    return ctypes.windll.user32.MessageBoxW(0, text, title, style)

@Gooey(program_name='KH1 Randomizer Mod Generator',
        image_dir=BASE_DIR / 'Images/',
        header_bg_color="#efcf78")

def main():
    #check_for_updates()
    presets = read_json(BASE_DIR / "mod_generator_presets.json")
    parser = GooeyParser()
    parser.add_argument("kh1_randomizer_patch_file",
        widget = "FileChooser",
        gooey_options = {'wildcard':"KH1 Randomizer Patch File (*.kh1rpatch)|*kh1rpatch|Seed Zip (Old) (*.zip)|*.zip"},
        default = presets["kh1_randomizer_patch_file"],
        metavar = "KH1 Randomizer Patch File",
        help = "The KH1 Randomizer patch file associated with your seed.")
    parser.add_argument("kh1_data_path",
        widget = "DirChooser",
        default = presets["kh1_data_path"],
        metavar = "KH1 Data Path",
        help = "The path to your KH1 data extracted by OpenKH.")
    
    args = parser.parse_args()
    write_json(BASE_DIR / "mod_generator_presets.json", vars(args))
    kh1_randomizer_patch_file = args.kh1_randomizer_patch_file
    write_mod(kh1_randomizer_patch_file, args.kh1_data_path)

if __name__ == "__main__":
    main()
