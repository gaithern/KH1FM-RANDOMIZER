from gooey import Gooey,GooeyParser
import os
import shutil
import subprocess
import re
import json

def read_presets():
    with open("./seed_generator_presets.json", 'r') as file:
        data = json.load(file)
        return data

def write_presets(args):
    data = json.dumps(vars(args), indent=4)
    with open("./seed_generator_presets.json", "w") as file:
        file.write(data)

@Gooey(program_name='KH1 Randomizer Seed Generator',
        image_dir='./Images/',
        program_description = "Program to generate KH1 Randomizer seed.",
        header_bg_color="#efcf78")

def main():
    presets = read_presets()
    parser = GooeyParser()
    parser.add_argument("archipelago_directory",
        widget = "DirChooser",
        default = presets["archipelago_directory"],
        metavar = "Archipelago Directory",
        help = "The directory where Archipelago is installed, which will be used for generation.")
    parser.add_argument("settings_file",
        widget = "FileChooser",
        default = presets["settings_file"],
        metavar = "Settings File",
        help = "The settings file (yaml) to be used in generation.")
    parser.add_argument("--replace_ap_world",
        choices = ["Yes",
            "No"],
        default = presets["replace_ap_world"],
        metavar = "Replace AP World",
        help = "Determines whether to replace the AP World in the specified Archipelago installation.  If unsure, set this to \"Yes\".")
    parser.add_argument("--clean_players_folder",
        choices = ["Yes",
            "No"],
        default = presets["clean_players_folder"],
        metavar = "Clean Players Folder",
        help = "Determines whether clear all previous data in Archipelago's \"Players\" folder before generation.\nSet to \"No\" if there are YAMLs or subfolders in this folder you'd like to keep.")
    
    args = parser.parse_args()
    write_presets(args)
    print("Handling moving AP World...")
    handle_replacing_ap_world(args.archipelago_directory, args.replace_ap_world)
    print("Handling moving YAML...")
    move_settings_file_to_players_folder(args.archipelago_directory, args.settings_file, args.clean_players_folder)
    print("Generating AP game...")
    generated_seed_zip = generate_ap_game(args.archipelago_directory)
    print("Moving generated game back to files...")
    move_generated_seed_zip_to_files(args.archipelago_directory, generated_seed_zip)

def copy_and_replace(source_path, destination_path):
    if os.path.exists(destination_path):
        os.remove(destination_path)
    shutil.copy2(source_path, destination_path)

def handle_replacing_ap_world(archipelago_directory, replace_ap_world):
    if replace_ap_world  == "Yes":
        ap_world_file = "./AP World/kh1.apworld"
        destination_path = archipelago_directory + "/lib/worlds/kh1.apworld"
        copy_and_replace(ap_world_file, destination_path)
        print("Placed " + ap_world_file + " in " + destination_path)

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

def move_settings_file_to_players_folder(archipelago_directory, settings_file, clean_players_folder):
    players_directory = archipelago_directory + "/Players/"
    if not os.path.exists(players_directory):
        os.makedirs(players_directory)
    if clean_players_folder == "Yes":
        clear_folder(players_directory)
    shutil.copy(settings_file, players_directory)
    print(settings_file + " copied to " + players_directory)

def generate_ap_game(archipelago_directory):
    if os.path.exists(archipelago_directory + "/ArchipelagoGenerate.exe"):
        p = subprocess.run(archipelago_directory + "/ArchipelagoGenerate.exe", input = "\n", capture_output=True, text=True)
    else:
        print("Didn't find ArchipelagoGenerate.exe!  Exiting...")
        exit(1)
    print(p.stdout)
    try:
        generated_seed_zip = re.search("AP.*.zip", str(p.stdout)).group()
    except:
        print("Couldn't find a seed zip!  Maybe generation failed?")
        exit(1)
    print("Found generated seed zip: " + str(generated_seed_zip))
    return generated_seed_zip

def move_generated_seed_zip_to_files(archipelago_directory, generated_seed_zip):
    if not os.path.exists("./Files/"):
        os.makedirs("./Files/")
    os.rename(archipelago_directory + "/Output/" + generated_seed_zip, "./Files/" + generated_seed_zip)
    print("Moved " + archipelago_directory + "/Output/" + generated_seed_zip + " to " + "./Files/" + generated_seed_zip)

if __name__ == "__main__":
    main()