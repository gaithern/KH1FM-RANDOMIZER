from gooey import Gooey,GooeyParser
import os
import shutil
import subprocess
import re

@Gooey(program_name='KH1 Randomizer Seed Generator',
        image_dir='./Images/',
        header_bg_color="#efcf78")

def main():
    parser = GooeyParser()
    
    parser.add_argument("--archipelago_directory",
        widget = "DirChooser",
        metavar = "Archipelago Directory",
        help = "The directory where Archipelago is installed, which will be used for generation.")
    parser.add_argument("--settings_file",
        widget = "FileChooser",
        metavar = "Settings File",
        help = "The settings file (yaml) to be used in generation.")
    
    args = parser.parse_args()
    move_settings_file_to_players_folder(args.archipelago_directory, args.settings_file)
    generated_seed_zip = generate_ap_game(args.archipelago_directory)
    move_generated_seed_zip_to_files(args.archipelago_directory, generated_seed_zip)

def clear_folder(folder_path):
    """
    Clears a folder of all files and subfolders.

    Args:
        folder_path (str): The path to the folder to clear.
    """

    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print(f"Failed to delete {file_path}. Reason: {e}")

def move_settings_file_to_players_folder(archipelago_directory, settings_file):
    players_directory = archipelago_directory + "/Players/"
    if not os.path.exists(players_directory):
        os.makedirs(players_directory)
    clear_folder(players_directory)
    shutil.copy(settings_file, players_directory)
    print(settings_file + " copied to " + players_directory)

def generate_ap_game(archipelago_directory):
    if os.path.exists(archipelago_directory + "/ArchipelagoGenerate.exe"):
        p = subprocess.run(archipelago_directory + "/ArchipelagoGenerate.exe", capture_output=True, text=True)
    else:
        p = subprocess.run("python " + archipelago_directory + "/Generate.py", capture_output=True, text=True)
    print(p.stdout)
    generated_seed_zip = re.search("AP.*.zip", str(p.stdout)).group()
    print("Found generated seed zip: " + str(generated_seed_zip))
    return generated_seed_zip

def move_generated_seed_zip_to_files(archipelago_directory, generated_seed_zip):
    if not os.path.exists("./Files/"):
        os.makedirs("./Files/")
    os.rename(archipelago_directory + "/Output/" + generated_seed_zip, "./Files/" + generated_seed_zip)
    print("Moved " + archipelago_directory + "/Output/" + generated_seed_zip + " to " + "./Files/" + generated_seed_zip)

if __name__ == "__main__":
    main()