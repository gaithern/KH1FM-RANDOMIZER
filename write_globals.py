from tkinter import filedialog
import json

from definitions import filler_item_ids, augment_strings

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def get_spell_mp_costs_data(spell_mp_costs_json_file = None):
    while not spell_mp_costs_json_file:
        spell_mp_costs_json_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Spell MP Costs JSON File")
        if not spell_mp_costs_json_file:
            print("Error, please select a valid KH1 spell mp costs json file")
    with open(spell_mp_costs_json_file, mode='r') as file:
        spell_mp_costs_data = json.load(file)
    return spell_mp_costs_data

def get_seed_json_data(seed_json_file = None):
    while not seed_json_file:
        seed_json_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Seed JSON")
        if not seed_json_file:
            print("Error, please select a valid KH1 seed file")
    with open(seed_json_file, mode='r') as file:
        seed_json_data = json.load(file)
    return seed_json_data

def get_ap_cost_data(ap_cost_file = None):
    while not ap_cost_file:
        ap_cost_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 AP Cost JSON")
        if not ap_cost_file:
            print("Error, please select a valid KH1 seed file")
    with open(ap_cost_file, mode='r') as file:
        ap_cost_data = json.load(file)
    return ap_cost_data

def get_globals_lua():
    with open('./Working/scripts/io_packages/globals.lua', mode = 'r') as file:
        globals_lua_str = file.read()
    return globals_lua_str

def output_globals_lua_file(globals_lua_str):
    with open('./Working/scripts/io_packages/globals.lua', mode = 'w') as file:
        file.write(globals_lua_str)

def get_new_spell_effectiveness(spell_mp_costs_data):
    original_spell_costs = [
        30, 30, 30,
        30, 30, 30,
        100, 100, 100,
        100, 100, 100,
        100, 100, 100,
        200, 200, 200,
        200, 200, 200]
    spell_effectiveness = [
        20,28,36,
        22,27,34,
        16,20,26,
        15,27,36,
        40,55,70,
        2,2,2,
        18,18,18]
    for i in range(len(spell_effectiveness)):
        current_effectiveness = spell_effectiveness[i]
        spell_effectiveness[i] = max([round(current_effectiveness * (spell_mp_costs_data[i] / original_spell_costs[i])), 1])
    return spell_effectiveness

def get_synth_items(seed_json_data):
    synth_items = []
    i = 1
    while i <= 33:
        synth_item_id = seed_json_data[str(2656400 + i)] % 2641000
        if synth_item_id > 255: # If not a regular item
            synth_item_id = 230 # Make it an AP Item
        synth_items.append(synth_item_id)
        i = i + 1
    return synth_items

def update_globals_lua_deathlink(globals_lua_str, settings_data):
    if settings_data["donald_death_link"]:
        globals_lua_str = globals_lua_str.replace("donald_death_link = false", "donald_death_link = true")
    if settings_data["goofy_death_link"]:
        globals_lua_str = globals_lua_str.replace("goofy_death_link = false", "goofy_death_link = true")
    if settings_data["death_link"] != "off":
        globals_lua_str = globals_lua_str.replace("reg_death_link = false", "reg_death_link = true")
    return globals_lua_str

def update_globals_lua_ap_costs(globals_lua_str, ap_cost_data):
    costs_string = ""
    for ap_cost in ap_cost_data:
        costs_string = costs_string + str(ap_cost["AP Cost"]) + ","
    costs_string = costs_string[:-1]
    globals_lua_str = globals_lua_str.replace("ability_costs = {}", "ability_costs = {" + costs_string + "}")
    return globals_lua_str

def update_globals_lua_destiny_islands(globals_lua_str, settings_data):
    day_2_materials = settings_data["day_2_materials"]
    homecoming_materials = settings_data["homecoming_materials"]
    globals_lua_str = globals_lua_str.replace("day_2_materials = 100", "day_2_materials = " + str(day_2_materials))
    globals_lua_str = globals_lua_str.replace("homecoming_materials = 100", "homecoming_materials = " + str(homecoming_materials))
    return globals_lua_str

def update_globals_lua_fix_combo_master(globals_lua_str, seed_json_data):
    if "2658150" in seed_json_data.keys():
        if seed_json_data["2658150"] > 2643000 and seed_json_data["2658150"] < 2644000:
            globals_lua_str = globals_lua_str.replace("level_50_overwrite_value = 0x0", "level_50_overwrite_value = " + str(hex(seed_json_data["2658150"] % 2643000 + 0x80)))
    if "2658155" in seed_json_data.keys():
        if seed_json_data["2658155"] > 2643000 and seed_json_data["2658155"] < 2644000:
            globals_lua_str = globals_lua_str.replace("level_55_overwrite_value = 0x0", "level_55_overwrite_value = " + str(hex(seed_json_data["2658155"] % 2643000 + 0x80)))
    return globals_lua_str

def update_globals_lua_lucky_emblems_eotw(globals_lua_str, settings_data):
    globals_lua_str = globals_lua_str.replace("eotw_lucky_emblems = 100", "eotw_lucky_emblems = " + str(settings_data["required_lucky_emblems_eotw"]))
    return globals_lua_str

def update_globals_lua_lucky_emblems_door(globals_lua_str, settings_data):
    globals_lua_str = globals_lua_str.replace("door_lucky_emblems = 100", "door_lucky_emblems = " + str(settings_data["required_lucky_emblems_door"]))
    return globals_lua_str

def update_globals_lua_puppies(globals_lua_str, settings_data):
    globals_lua_str = globals_lua_str.replace("puppy_value = 3", "puppy_value = " + str(settings_data["puppy_value"]))
    return globals_lua_str

def update_globals_lua_stacking_worlds(globals_lua_str, settings_data):
    globals_lua_str = globals_lua_str.replace("stacking_worlds = false", "stacking_worlds = " + str(settings_data["stacking_world_items"]).lower())
    return globals_lua_str

def update_globals_lua_stacking_forget_me_not(globals_lua_str, settings_data):
    globals_lua_str = globals_lua_str.replace("stacking_forget_me_not = false", "stacking_forget_me_not = " + str(settings_data["halloween_town_key_item_bundle"]).lower())
    return globals_lua_str

def update_globals_lua_map_prize(globals_lua_str, seed_json_data):
    map_prize_location_ids = [
        2656600,
        2656601,
        2656602,
        2656603,
        2656604,
        2656605,
        2656606,
        2656607,
        2656608,
        2656609,
        2656610,
        2656611,
        2656612,
        2656613,
        2656614,
        2656615,
        2656616,
        2656617,
        2656618,
        2656619,
        2656620,
        2656621,
        2656622,
        2656623
    ]
    for map_prize_location_id in map_prize_location_ids:
        replace = "0"
        if str(map_prize_location_id) in seed_json_data.keys():
            item = seed_json_data[str(map_prize_location_id)] % 2641000
            if item <= 255 and int(item) not in filler_item_ids and item != 230:
                replace = str(item)
        globals_lua_str = globals_lua_str.replace("replace_" + str(map_prize_location_id), str(replace))
    return globals_lua_str

def update_globals_lua_mp_costs(globals_lua_str, mp_costs):
    spell_order = [
        "Fire", "Fira", "Firaga",
        "Blizzard", "Blizzara", "Blizzaga",
        "Thunder", "Thundara", "Thundaga",
        "Cure", "Cura", "Curaga",
        "Gravity", "Gravira", "Graviga",
        "Stop", "Stopra", "Stopga",
        "Aero", "Aerora", "Aeroga"
    ]
    original_spell_costs = [
        30, 30, 30,
        30, 30, 30,
        100, 100, 100,
        100, 100, 100,
        100, 100, 100,
        200, 200, 200,
        200, 200, 200]
    cost_to_num_dict = {
        15:  1,
        30:  2,
        100: 3,
        200: 4,
        300: 5
    }
    old_costs = [cost_to_num_dict[cost] for cost in original_spell_costs]
    new_costs = [cost_to_num_dict[cost] for cost in mp_costs]
    
    for i in range(len(mp_costs)):
        search_string = f"spell_costs[\"{spell_order[i]}\"] = {old_costs[i]}"
        replace_string = f"spell_costs[\"{spell_order[i]}\"] = {new_costs[i]}"
        globals_lua_str = globals_lua_str.replace(search_string, replace_string)
    return globals_lua_str

def update_globals_lua_spell_effectiveness(globals_lua_str, spell_mp_costs_data):
    new_spell_effectiveness = get_new_spell_effectiveness(spell_mp_costs_data)
    original_spell_effectiveness = [
        20,28,36,
        22,27,34,
        16,20,26,
        15,27,36,
        40,55,70,
        2,2,2,
        18,18,18]
    spell_order = [
        "Fire", "Fira", "Firaga",
        "Blizzard", "Blizzara", "Blizzaga",
        "Thunder", "Thundara", "Thundaga",
        "Cure", "Cura", "Curaga",
        "Gravity", "Gravira", "Graviga",
        "Stop", "Stopra", "Stopga",
        "Aero", "Aerora", "Aeroga"
    ]
    
    for i in range(len(new_spell_effectiveness)):
        search_string = f"effectiveness_values[\"{spell_order[i]}\"] = {original_spell_effectiveness[i]}"
        replace_string = f"effectiveness_values[\"{spell_order[i]}\"] = {new_spell_effectiveness[i]}"
        globals_lua_str = globals_lua_str.replace(search_string, replace_string)
    return globals_lua_str

def update_globals_lua_synth(globals_lua_str, seed_json_data):
    synth_items = get_synth_items(seed_json_data)
    replace_string = "synth_items = {"
    for item in synth_items:
        replace_string = replace_string + str(item) + ", "
    replace_string = replace_string[:-2] + "}"
    return globals_lua_str.replace("synth_items = {}", replace_string)

def update_globals_lua_synth_item_names(globals_lua_str, settings_data):
    synthesis_item_names_bytes_array = settings_data["synthesis_item_name_byte_arrays"]
    synth_item_bytes_str = str(synthesis_item_names_bytes_array).replace("[", "{").replace("]", "}")
    globals_lua_str = globals_lua_str.replace("synth_item_bytes = {}", "synth_item_bytes = " + str(synth_item_bytes_str))
    return globals_lua_str

def update_globals_lua_starting_items(globals_lua_str, settings_data):
    globals_lua_str = globals_lua_str.replace("starting_items = {}", "starting_items = " + str(settings_data["starting_items"]).replace("[", "{").replace("]","}"))
    return globals_lua_str

def update_globals_lua_augment(globals_lua_str, seed_json_data):
    accessory_location_map = {k: v for k, v in seed_json_data.items() if 2659100 <= int(k) <= 2659154}
    for accessory_location_id in accessory_location_map.keys():
        acc_val = int(accessory_location_id) - 2659100 + 17
        aug_val = accessory_location_map[accessory_location_id]
        aug_str = augment_strings[aug_val][0]
        search_string = f"aug_acc[\"{aug_str}\"] = 256"
        replace_string = f"aug_acc[\"{aug_str}\"] = {acc_val}"
        globals_lua_str = globals_lua_str.replace(search_string, replace_string)
    return globals_lua_str

def update_globals_lua_interact_in_battle(globals_lua_str, settings_data):
    if settings_data["interact_in_battle"]:
        globals_lua_str = globals_lua_str.replace("interactinbattle = false", "interactinbattle = true")
    return globals_lua_str

def update_globals_lua_keyblades_unlock_chests(globals_lua_str, settings_data):
    if settings_data["keyblades_unlock_chests"]:
        globals_lua_str = globals_lua_str.replace("chestslocked = false", "chestslocked = true")
    return globals_lua_str

def write_globals(settings_file = None, mp_cost_file = None, seed_json_file = None, ap_cost_file = None):
    settings_data = get_settings_data(settings_file)
    spell_mp_costs_data = get_spell_mp_costs_data(mp_cost_file)
    seed_json_data = get_seed_json_data(seed_json_file)
    ap_cost_data = get_ap_cost_data(ap_cost_file)
    
    globals_lua_str = get_globals_lua()
    
    globals_lua_str = update_globals_lua_deathlink(globals_lua_str, settings_data)
    globals_lua_str = update_globals_lua_fix_combo_master(globals_lua_str, seed_json_data)
    globals_lua_str = update_globals_lua_puppies(globals_lua_str, settings_data)
    globals_lua_str = update_globals_lua_stacking_worlds(globals_lua_str, settings_data)
    globals_lua_str = update_globals_lua_stacking_forget_me_not(globals_lua_str, settings_data)
    globals_lua_str = update_globals_lua_map_prize(globals_lua_str, seed_json_data)
    globals_lua_str = update_globals_lua_synth(globals_lua_str, seed_json_data)
    globals_lua_str = update_globals_lua_synth_item_names(globals_lua_str, settings_data)
    globals_lua_str = update_globals_lua_starting_items(globals_lua_str, settings_data)
    
    if settings_data.get("randomize_ap_costs") not in (None, "off"):
        globals_lua_str = update_globals_lua_ap_costs(globals_lua_str, ap_cost_data)
    if settings_data.get("destiny_islands"):
        globals_lua_str = update_globals_lua_destiny_islands(globals_lua_str, settings_data)
    if settings_data.get("end_of_the_world_unlock") == "lucky_emblems" or settings_data.get("final_rest_door_Key") == "lucky_emblems":
        if settings_data.get("end_of_the_world_unlock") == "lucky_emblems":
            globals_lua_str = update_globals_lua_lucky_emblems_eotw(globals_lua_str, settings_data)
        if settings_data.get("final_rest_door_key") == "lucky_emblems":
            globals_lua_str = update_globals_lua_lucky_emblems_door(globals_lua_str, settings_data)
    if settings_data.get("randomize_spell_mp_costs", "off") != "off":
        globals_lua_str = update_globals_lua_mp_costs(globals_lua_str, spell_mp_costs_data)
        if settings_data.get("scaling_spell_potency"):
            globals_lua_str = update_globals_lua_spell_effectiveness(globals_lua_str, spell_mp_costs_data)
    if settings_data.get("accessory_augments"):
        globals_lua_str = update_globals_lua_augment(globals_lua_str, seed_json_data)
    if settings_data.get("interact_in_battle"):
        globals_lua_str = update_globals_lua_interact_in_battle(globals_lua_str, settings_data)
    if settings_data.get("keyblades_unlock_chests"):
        globals_lua_str = update_globals_lua_keyblades_unlock_chests(globals_lua_str, settings_data)
    
    output_globals_lua_file(globals_lua_str)

if __name__ == "__main__":
    write_globals()