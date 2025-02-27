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

def get_lua_str(lua_file_name):
    with open('./Template Luas/' + lua_file_name, mode = 'r') as file:
        lua_str = file.read()
    return lua_str

def output_lua_file(lua_str, lua_file_name):
    with open('./Working/scripts/' + lua_file_name, mode = 'w') as file:
        file.write(lua_str)

def write_synthesis_item_names_lua(settings_file = None):
    settings_data = get_settings_data(settings_file)
    synthesis_item_names_bytes_array = settings_data["synthesis_item_name_byte_arrays"]
    synth_item_bytes_str = str(synthesis_item_names_bytes_array).replace("[", "{").replace("]", "}")
    synthesis_item_names_lua_str = get_lua_str("1fmRandoWriteSynthesisItemNames.lua")
    synthesis_item_names_lua_str = synthesis_item_names_lua_str.replace("synth_item_bytes = {}", "synth_item_bytes = " + str(synth_item_bytes_str))
    output_lua_file(synthesis_item_names_lua_str, "1fmRandoWriteSynthesisItemNames.lua")

if __name__ == "__main__":
    write_synthesis_item_names_lua()