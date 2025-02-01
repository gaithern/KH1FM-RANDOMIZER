import tkinter as tk
from tkinter import filedialog
import csv
import json
from pprint import pprint

root = tk.Tk()
root.withdraw()

def get_seed_json_data(seed_json_file = None):
    while not seed_json_file:
        seed_json_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Seed JSON")
        if not seed_json_file:
            print("Error, please select a valid KH1 seed file")
    with open(seed_json_file, mode='r') as file:
        seed_json_data = json.load(file)
    return seed_json_data

def get_synth_items(seed_json_data):
    synth_items = []
    i = 1
    while i <= 33:
        synth_items.append(seed_json_data[str(2656400 + i)] % 2641000)
        i = i + 1
    return synth_items

def get_synth_template_lua():
    with open('./Template Luas/1fmRandoSynthesis.lua', mode = 'r') as file:
        synth_lua_str = file.read()
    return synth_lua_str

def update_synth_lua(synth_lua_str, synth_items):
    replace_string = "synth_items = {"
    for item in synth_items:
        replace_string = replace_string + str(item) + ", "
    replace_string = replace_string[:-2] + "}"
    return synth_lua_str.replace("synth_items = {}", replace_string)

def output_synth_lua_file(synth_lua_str):
    with open('./Working/scripts/1fmRandoSynthesis.lua', mode = 'w') as file:
        file.write(synth_lua_str)

def write_synthesis_items(seed_json_file = None):
    seed_json_data = get_seed_json_data(seed_json_file)
    synth_items = get_synth_items(seed_json_data)
    synth_lua_str = get_synth_template_lua()
    synth_lua_str = update_synth_lua(synth_lua_str, synth_items)
    output_synth_lua_file(synth_lua_str)

if __name__ == "__main__":
    write_synthesis_items()