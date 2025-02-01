import tkinter as tk
from tkinter import filedialog
import csv
import json
from pprint import pprint
import os

from definitions import filler_item_ids

root = tk.Tk()
root.withdraw()

def get_map_prize_definitions():
    with open('./Documentation/KH1FM Documentation - Map Prizes.csv', mode = 'r') as file:
        bambi_definitions = []
        bambi_data = csv.DictReader(file)
        for line in bambi_data:
            bambi_definitions.append(line)
    return bambi_definitions

def get_map_prize_data(kh1_data_path):
    with open(kh1_data_path + "/map_prize.bin", mode = 'rb') as file:
        return bytearray(file.read())

def remove_map_prizes(map_prize_bytes, map_prize_definitions):
    for map_prize_definition in map_prize_definitions:
        offset = int(map_prize_definition["Offset"],16)
        for i in range(13):
            map_prize_bytes[offset + i] = 0
    return map_prize_bytes

def safe_open_wb(path):
    ''' Open "path" for writing, creating any parent directories as needed.
    '''
    os.makedirs(os.path.dirname(path), exist_ok=True)
    return open(path, 'wb')

def write_map_prize_bin(map_prize_bytes):
    with safe_open_wb('./Working/' + "map_prize.bin") as file:
        file.write(map_prize_bytes)

def get_seed_json_data(seed_json_file = None):
    while not seed_json_file:
        seed_json_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Seed JSON")
        if not seed_json_file:
            print("Error, please select a valid KH1 seed file")
    with open(seed_json_file, mode='r') as file:
        seed_json_data = json.load(file)
    return seed_json_data

def replace_map_prize_items(map_prize_bytes, map_prize_definitions, seed_json_data):
    for map_prize_definition in map_prize_definitions:
        if map_prize_definition["AP Location ID"] != "-":
            offset = int(map_prize_definition["Offset"],16)
            item = seed_json_data[map_prize_definition["AP Location ID"]] % 264100
            map_prize_bytes[offset + 7] = 100
            map_prize_bytes[offset + 8] = item
    return map_prize_bytes

def write_map_prizes(seed_json_file = None):
    kh1_data_path = "./Working/"
    map_prize_definitions = get_map_prize_definitions()
    map_prize_data = get_map_prize_data(kh1_data_path)
    map_prize_bytes = remove_map_prizes(map_prize_data, map_prize_definitions)
    seed_json_data = get_seed_json_data(seed_json_file = seed_json_file)
    map_prize_bytes = replace_map_prize_items(map_prize_bytes, map_prize_definitions, seed_json_data)
    write_map_prize_bin(map_prize_bytes)

if __name__=="__main__":
    write_map_prizes()