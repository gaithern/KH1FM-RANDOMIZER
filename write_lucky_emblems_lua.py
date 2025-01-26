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

def get_lucky_emblems_template_lua():
    with open('./Template Luas/1fmRandoHandleLuckyEmblems.lua', mode = 'r') as file:
        lucky_emblems_lua_str = file.read()
    return lucky_emblems_lua_str

def update_lucky_emblems_eotw_lua(lucky_emblems_lua_str, settings_data):
    lucky_emblems_lua_str = lucky_emblems_lua_str.replace("eotw_lucky_emblems = 100", "eotw_lucky_emblems = " + str(settings_data["required_lucky_emblems_eotw"]))
    return lucky_emblems_lua_str

def update_lucky_emblems_door_lua(lucky_emblems_lua_str, settings_data):
    lucky_emblems_lua_str = lucky_emblems_lua_str.replace("door_lucky_emblems = 100", "door_lucky_emblems = " + str(settings_data["required_lucky_emblems_door"]))
    return lucky_emblems_lua_str

def output_lucky_emblems_lua_file(lucky_emblems_lua_str):
    with open('./Output/scripts/1fmRandoHandleLuckyEmblems.lua', mode = 'w') as file:
        file.write(lucky_emblems_lua_str)

def write_lucky_emblems_lua(settings_file = None):
    settings_data = get_settings_data(settings_file)
    if settings_data["end_of_the_world_unlock"] == "lucky_emblems" or settings_data["final_rest_door_key"] == "lucky_emblems":
        lucky_emblems_lua_str = get_lucky_emblems_template_lua()
        if settings_data["end_of_the_world_unlock"] == "lucky_emblems":
            lucky_emblems_lua_str = update_lucky_emblems_eotw_lua(lucky_emblems_lua_str, settings_data)
        if settings_data["final_rest_door_key"] == "lucky_emblems":
            lucky_emblems_lua_str = update_lucky_emblems_door_lua(lucky_emblems_lua_str, settings_data)
        output_lucky_emblems_lua_file(lucky_emblems_lua_str)

if __name__ == "__main__":
    write_lucky_emblems_lua()