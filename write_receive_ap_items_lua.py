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

def get_receive_ap_items_lua():
    with open('./Template Luas/1fmRandoReceiveAPItems.lua', mode = 'r', encoding = 'utf8') as file:
        receive_ap_items_lua_str = file.read()
    return receive_ap_items_lua_str

def update_receive_ap_items_lua(receive_ap_items_lua_str, settings_data):
    receive_ap_items_lua_str = receive_ap_items_lua_str.replace("starting_items = {}", "starting_items = " + str(settings_data["starting_items"]).replace("[", "{").replace("]","}"))
    return receive_ap_items_lua_str

def output_receive_ap_items_lua_file(receive_ap_items_lua_str):
    with open('./Working/scripts/1fmRandoReceiveAPItems.lua', mode = 'w') as file:
        file.write(receive_ap_items_lua_str)

def write_receive_ap_items_lua(settings_file = None):
    settings_data = get_settings_data(settings_file)
    receive_ap_items_lua_str = get_receive_ap_items_lua()
    receive_ap_items_lua_str = update_receive_ap_items_lua(receive_ap_items_lua_str, settings_data)
    output_receive_ap_items_lua_file(receive_ap_items_lua_str)

if __name__ == "__main__":
    write_receive_ap_items_lua()