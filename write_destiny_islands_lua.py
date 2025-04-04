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

def update_destiny_islands_lua_str(destiny_islands_lua_str, day_2_materials, homecoming_materials):
    destiny_islands_lua_str = destiny_islands_lua_str.replace("day_2_materials = 0", "day_2_materials = " + str(day_2_materials))
    destiny_islands_lua_str = destiny_islands_lua_str.replace("homecoming_materials = 0", "homecoming_materials = " + str(homecoming_materials))
    return destiny_islands_lua_str

def write_destiny_islands_lua(settings_file = None):
    settings_data = get_settings_data(settings_file)
    if settings_data["destiny_islands"]:
        day_2_materials = settings_data["day_2_materials"]
        homecoming_materials = settings_data["homecoming_materials"]
        destiny_islands_lua_str = get_destiny_islands_lua_str()
        destiny_islands_lua_str = update_destiny_islands_lua_str(destiny_islands_lua_str, day_2_materials, homecoming_materials)
        output_destiny_islands_lua_file(destiny_islands_lua_str)

if __name__ == "__main__":
    write_destiny_islands_lua()