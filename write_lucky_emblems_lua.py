from globals import read_json, read_file, write_file

def update_lucky_emblems_eotw_lua(lucky_emblems_lua_str, settings_data):
    lucky_emblems_lua_str = lucky_emblems_lua_str.replace("eotw_lucky_emblems = 100", "eotw_lucky_emblems = " + str(settings_data["required_lucky_emblems_eotw"]))
    return lucky_emblems_lua_str

def update_lucky_emblems_door_lua(lucky_emblems_lua_str, settings_data):
    lucky_emblems_lua_str = lucky_emblems_lua_str.replace("door_lucky_emblems = 100", "door_lucky_emblems = " + str(settings_data["required_lucky_emblems_door"]))
    return lucky_emblems_lua_str

def write_lucky_emblems_lua(settings_file):
    settings_data = read_json(settings_file)
    if settings_data["end_of_the_world_unlock"] == "lucky_emblems" or settings_data["final_rest_door_key"] == "lucky_emblems":
        lucky_emblems_lua_str = read_file(BASE_DIR / "Template Luas" / "1fmRandoHandleLuckyEmblems.lua")
        if settings_data["end_of_the_world_unlock"] == "lucky_emblems":
            lucky_emblems_lua_str = update_lucky_emblems_eotw_lua(lucky_emblems_lua_str, settings_data)
        if settings_data["final_rest_door_key"] == "lucky_emblems":
            lucky_emblems_lua_str = update_lucky_emblems_door_lua(lucky_emblems_lua_str, settings_data)
        write_file(BASE_DIR / "Working" / "scripts" / "1fmRandoHandleLuckyEmblems.lua", lucky_emblems_lua_str)