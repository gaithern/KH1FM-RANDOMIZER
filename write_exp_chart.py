import tkinter as tk
from tkinter import filedialog
import csv
import json

root = tk.Tk()
root.withdraw()

def get_exp_chart_definitions():
    with open('./Documentation/KH1FM Documentation - EXP Chart.csv', mode = 'r') as file:
        exp_chart_definitions = []
        exp_chart_data = csv.DictReader(file)
        for line in exp_chart_data:
            exp_chart_definitions.append(line)
    return exp_chart_definitions

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def get_battle_table(kh1_data_path):
    with open(kh1_data_path + "/btltbl.bin", mode = 'rb') as file:
        return bytearray(file.read())

def output_battle_table(battle_table_bytes):
    with open('./Working/btltbl.bin', mode = 'wb') as file:
        file.write(battle_table_bytes)

def apply_exp_multiplier(battle_table_bytes, settings_data, exp_chart_definitions):
    multiplier = settings_data["exp_multiplier"]
    for line in exp_chart_definitions:
        new_exp_to_add = max(int(int(line["EXP to Add"])//multiplier), 1)
        new_exp_to_add_bytes = new_exp_to_add.to_bytes(2, byteorder='little')
        battle_table_bytes[int(line["Offset"], 16)] = new_exp_to_add_bytes[0]
        battle_table_bytes[int(line["Offset"], 16) + 1] = new_exp_to_add_bytes[1]
    return battle_table_bytes

def output_battle_table(battle_table_bytes):
    with open('./Working/btltbl.bin', mode = 'wb') as file:
        file.write(battle_table_bytes)

def write_exp_chart(settings_file = None):
    kh1_data_path = "./Working/"
    exp_chart_definitions = get_exp_chart_definitions()
    settings_data = get_settings_data(settings_file = settings_file)
    battle_table_bytes = get_battle_table(kh1_data_path)
    battle_table_bytes = apply_exp_multiplier(battle_table_bytes, settings_data, exp_chart_definitions)
    output_battle_table(battle_table_bytes)

if __name__ == "__main__":
    write_exp_chart()