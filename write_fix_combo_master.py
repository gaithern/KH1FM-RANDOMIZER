import tkinter as tk
from tkinter import filedialog
import csv
import json

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

def get_fix_combo_master_template_lua():
    with open('./Template Luas/1fmRandoFixComboMaster.lua', mode = 'r') as file:
        fix_combo_master_lua_str = file.read()
    return fix_combo_master_lua_str

def update_fix_combo_master_template_lua(fix_combo_master_lua_str, seed_json_data):
    if "2658150" in seed_json_data.keys():
        if seed_json_data["2658150"] > 2643000 and seed_json_data["2658150"] < 2644000:
            fix_combo_master_lua_str = fix_combo_master_lua_str.replace("level_50_overwrite_value = 0x0", "level_50_overwrite_value = " + str(hex(seed_json_data["2658150"] % 2643000 + 0x80)))
        if seed_json_data["2658155"] > 2643000 and seed_json_data["2658155"] < 2644000:
            fix_combo_master_lua_str = fix_combo_master_lua_str.replace("level_55_overwrite_value = 0x0", "level_55_overwrite_value = " + str(hex(seed_json_data["2658155"] % 2643000 + 0x80)))
    return fix_combo_master_lua_str

def output_fix_combo_master_lua_file(fix_combo_master_lua_str):
    with open('./Output/scripts/1fmRandoFixComboMaster.lua', mode = 'w') as file:
        file.write(fix_combo_master_lua_str)

def write_fix_combo_master(seed_json_file = None):
    seed_json_data = get_seed_json_data(seed_json_file)
    fix_combo_master_lua_str = get_fix_combo_master_template_lua()
    fix_combo_master_lua_str = update_fix_combo_master_template_lua(fix_combo_master_lua_str, seed_json_data)
    output_fix_combo_master_lua_file(fix_combo_master_lua_str)

if __name__ == "__main__":
    write_fix_combo_master()