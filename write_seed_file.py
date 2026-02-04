import shutil
import os
from tkinter import filedialog

def write_seed_file(seed_json_file=None):
    # Prompt for a file if not provided
    while not seed_json_file:
        seed_json_file = filedialog.askopenfilename(
            filetypes=[('JSON', '*.json')],
            title="KH1 Randomizer Seed JSON"
        )
        if not seed_json_file:
            print("Error, please select a valid KH1 settings file")
    
    # Ensure the target directory exists
    target_dir = "./Working"
    os.makedirs(target_dir, exist_ok=True)
    
    # Copy the file into the target directory
    target_path = os.path.join(target_dir, os.path.basename(seed_json_file))
    shutil.copy2(seed_json_file, target_path)
    print(f"Copied settings file to: {target_path}")
    
    return target_path

if __name__ == "__main__":
    write_seed_file()