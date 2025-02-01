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

def get_death_link_template_lua():
    with open('./Template Luas/1fmRandoHandleDeathLink.lua', mode = 'r') as file:
        death_link_lua_str = file.read()
    return death_link_lua_str

def update_death_link_lua(death_link_lua_str, settings_data):
    if settings_data["donald_death_link"]:
        death_link_lua_str = death_link_lua_str.replace("local donald_death_link = false", "local donald_death_link = true")
    if settings_data["donald_death_link"]:
        death_link_lua_str = death_link_lua_str.replace("local goofy_death_link = false", "local goofy_death_link = true")
    if settings_data["death_link"]:
        death_link_lua_str = death_link_lua_str.replace("local death_link = false", "local death_link = true")
    return death_link_lua_str

def output_death_link_lua_file(death_link_lua_str):
    with open('./Working/scripts/1fmRandoHandleDeathLink.lua', mode = 'w') as file:
        file.write(death_link_lua_str)

def write_death_link_lua(settings_file = None):
    settings_data = get_settings_data(settings_file)
    if settings_data["death_link"] or settings_data["donald_death_link"] or settings_data["goofy_death_link"]:
        death_link_lua_str = get_death_link_template_lua()
        death_link_lua_str = update_death_link_lua(death_link_lua_str, settings_data)
        output_death_link_lua_file(death_link_lua_str)

if __name__ == "__main__":
    write_death_link_lua()