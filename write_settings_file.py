import shutil
import os
from tkinter import filedialog

def write_settings_file(settings_file=None):
    # Prompt for a file if not provided
    while not settings_file:
        settings_file = filedialog.askopenfilename(
            filetypes=[('JSON', '*.json')],
            title="KH1 Randomizer Settings JSON"
        )
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    
    # Ensure the target directory exists
    target_dir = "./Working"
    os.makedirs(target_dir, exist_ok=True)
    
    # Copy the file into the target directory
    target_path = os.path.join(target_dir, os.path.basename(settings_file))
    shutil.copy2(settings_file, target_path)
    print(f"Copied settings file to: {target_path}")
    
    return target_path

if __name__ == "__main__":
    write_settings_file()