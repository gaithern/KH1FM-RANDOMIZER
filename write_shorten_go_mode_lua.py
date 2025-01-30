import tkinter as tk
from tkinter import filedialog
import csv
import json
from pprint import pprint

root = tk.Tk()
root.withdraw()

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def get_shorten_go_mode_lua_str():
    with open('./Template Luas/1fmRandoShortenGoMode.lua', mode = 'r') as file:
        interaction_lua_str = file.read()
    return interaction_lua_str

def output_shorten_go_mode_lua_file(shorten_go_mode_lua_str):
    with open('./Output/scripts/1fmRandoShortenGoMode.lua', mode = 'w') as file:
        file.write(interaction_lua_str)

def write_shorten_go_mode_lua(settings_file = None):
    settings_data = get_settings_data(settings_file)
    if settings_data["shorten_go_mode"]:
        shorten_go_mode_lua_str = get_shorten_go_mode_lua_str()
        output_shorten_go_mode_lua_file(shorten_go_mode_lua_str)

if __name__ == "__main__":
    write_shorten_go_mode_lua()