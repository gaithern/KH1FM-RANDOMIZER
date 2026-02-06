from gooey import Gooey,GooeyParser
from write_mod import write_mod
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

VERSION = "1.0.3"

# Handle Splash Screen
try:
    import pyi_splash
    pyi_splash.close()
except:
    pass
# End Handle Splash Screen

def get_nested_zip(zip_file_path):
    """
    Checks if a zip file contains another zip file.

    Args:
        zip_file_path (str): The path to the zip file.

    Returns:
        bool: True if the zip file contains another zip file, False otherwise.
    """
    try:
        with zipfile.ZipFile(zip_file_path, 'r') as zip_file:
            for item in zip_file.namelist():
                if os.path.splitext(item)[1].lower() == '.zip':
                    return item
            return None
    except zipfile.BadZipFile:
        return None

def extract_zip(zip_file_path):
    """Extracts a zip file to a folder with the same name."""

    with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
        # Get the name of the zip file without the extension
        folder_name = os.path.splitext(zip_file_path)[0]

        # Create the folder if it doesn't exist
        os.makedirs(folder_name, exist_ok=True)

        # Extract all contents of the zip file to the folder
        zip_ref.extractall(folder_name)

def read_presets():
    with open("./mod_generator_presets.json", 'r') as file:
        data = json.load(file)
        return data

def write_presets(args):
    data = json.dumps(vars(args), indent=4)
    with open("./mod_generator_presets.json", "w") as file:
        file.write(data)

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
        image_dir='./Images/',
        header_bg_color="#efcf78")

def main():
    check_for_updates()
    presets = read_presets()
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
    write_presets(args)
    kh1_randomizer_patch_file = args.kh1_randomizer_patch_file
    write_mod(kh1_randomizer_patch_file, args.kh1_data_path)

if __name__ == "__main__":
    main()
