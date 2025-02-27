import json

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def get_destiny_islands_lua_str():
    with open('./Template Luas/1fmRandoAllowDestinyIslands.lua', mode = 'r') as file:
        destiny_islands_lua_str = file.read()
    return destiny_islands_lua_str

def output_destiny_islands_lua_file(destiny_islands_lua_str):
    with open('./Working/scripts/1fmRandoAllowDestinyIslands.lua', mode = 'w') as file:
        file.write(destiny_islands_lua_str)

def write_destiny_islands_lua(settings_file = None):
    settings_data = get_settings_data(settings_file)
    if settings_data["destiny_islands"]:
        destiny_islands_lua_str = get_destiny_islands_lua_str()
        output_destiny_islands_lua_file(destiny_islands_lua_str)

if __name__ == "__main__":
    write_destiny_islands_lua()