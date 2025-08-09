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

def get_handle_items_lua():
    with open('./Template Luas/1fmRandoHandleItems.lua', mode = 'r') as file:
        handle_items_lua_str = file.read()
    return handle_items_lua_str

def update_puppies_handle_items_lua(handle_items_lua_str, settings_data):
    handle_items_lua_str = handle_items_lua_str.replace("puppy_value = 3", "puppy_value = " + str(settings_data["puppy_value"]))
    return handle_items_lua_str

def update_stacking_worlds(handle_items_lua_str, settings_data):
    handle_items_lua_str = handle_items_lua_str.replace("stacking_worlds = false", "stacking_worlds = " + str(settings_data["stacking_world_items"]).lower())
    return handle_items_lua_str

def update_stacking_forget_me_not(handle_items_lua_str, settings_data):
    handle_items_lua_str = handle_items_lua_str.replace("stacking_forget_me_not = false", "stacking_forget_me_not = " + str(settings_data["halloween_town_key_item_bundle"]).lower())
    return handle_items_lua_str

def output_handle_items_lua_file(handle_items_lua_str):
    with open('./Working/scripts/1fmRandoHandleItems.lua', mode = 'w') as file:
        file.write(handle_items_lua_str)

def write_handle_items_lua(settings_file = None):
    settings_data = get_settings_data(settings_file)
    handle_items_lua_str = get_handle_items_lua()
    handle_items_lua_str = update_puppies_handle_items_lua(handle_items_lua_str, settings_data)
    handle_items_lua_str = update_stacking_worlds(handle_items_lua_str, settings_data)
    handle_items_lua_str = update_stacking_forget_me_not(handle_items_lua_str, settings_data)
    output_handle_items_lua_file(handle_items_lua_str)

if __name__ == "__main__":
    write_handle_items_lua()