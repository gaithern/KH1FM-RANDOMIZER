import tkinter as tk
from tkinter import filedialog
import csv
import json

from definitions import filler_item_ids

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

def get_map_prize_template_lua():
    with open('./Template Luas/1fmRandoMapPrizes.lua', mode = 'r') as file:
        map_prize_lua_str = file.read()
    return map_prize_lua_str

def update_map_prize_template_lua(map_prize_lua_str, seed_json_data):
    map_prize_location_ids = [
        2656600,
        2656601,
        2656602,
        2656603,
        2656604,
        2656605,
        2656606,
        2656607,
        2656608,
        2656609,
        2656610,
        2656611
    ]
    for map_prize_location_id in map_prize_location_ids:
        replace = "0"
        if str(map_prize_location_id) in seed_json_data.keys():
            item = seed_json_data[str(map_prize_location_id)] % 2641000
            if item <= 255 and int(item) not in filler_item_ids and item != 230:
                replace = str(item)
        map_prize_lua_str = map_prize_lua_str.replace("replace_" + str(map_prize_location_id), str(replace))
    return map_prize_lua_str

def output_map_prize_lua_file(map_prize_lua_str):
    with open('./Working/scripts/1fmRandoMapPrizes.lua', mode = 'w') as file:
        file.write(map_prize_lua_str)

def write_map_prize_lua(seed_json_file = None):
    seed_json_data = get_seed_json_data(seed_json_file)
    map_prize_lua_str = get_map_prize_template_lua()
    map_prize_lua_str = update_map_prize_template_lua(map_prize_lua_str, seed_json_data)
    output_map_prize_lua_file(map_prize_lua_str)

if __name__ == "__main__":
    write_map_prize_lua()