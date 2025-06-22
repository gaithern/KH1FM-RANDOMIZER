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

def get_interaction_template_lua():
    with open('./Template Luas/1fmRandoInteraction.lua', mode = 'r') as file:
        interaction_lua_str = file.read()
    return interaction_lua_str

def update_interaction_keyblade_lock_lua(interaction_lua_str, settings_data):
    if settings_data["interact_in_battle"]:
        interaction_lua_str = interaction_lua_str.replace("interactinbattle = false", "interactinbattle = true")
    return interaction_lua_str

def update_interaction_interact_in_battle_lua(interaction_lua_str, settings_data):
    if settings_data["keyblades_unlock_chests"]:
        interaction_lua_str = interaction_lua_str.replace("chestslocked = false", "chestslocked = true")
    return interaction_lua_str

def output_interaction_lua_file(interaction_lua_str):
    with open('./Working/scripts/1fmRandoInteraction.lua', mode = 'w') as file:
        file.write(interaction_lua_str)

def write_interaction_lua(settings_file = None):
    settings_data = get_settings_data(settings_file)
    if settings_data["interact_in_battle"] or settings_data["keyblades_unlock_chests"]:
        interaction_lua_str = get_interaction_template_lua()
        interaction_lua_str = update_interaction_interact_in_battle_lua(interaction_lua_str, settings_data)
        interaction_lua_str = update_interaction_keyblade_lock_lua(interaction_lua_str, settings_data)
        output_interaction_lua_file(interaction_lua_str)

if __name__ == "__main__":
    write_interaction_lua()