from tkinter import filedialog
import json

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def output_seed(seed):
    with open('./Working/scripts/randofiles/seed.txt', mode = 'w') as file:
        file.write(seed)

def write_seed(settings_file = None):
    settings_data = get_settings_data(settings_file)
    seed = settings_data["seed"]
    output_seed(seed)

if __name__ == "__main__":
    write_seed()