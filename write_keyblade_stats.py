from definitions import keyblade_list
from write_item_descriptions import replace_specific_item_description
from globals import BASE_DIR, read_json, read_bytes, read_csv, write_bytes

def get_weapon_byte_offset(weapon_definitions, stat, keyblade, user):
    for weapon in weapon_definitions:
        if stat == weapon["Notes"] and keyblade == weapon["Keyblade"] and weapon["User"] == user:
            return weapon["Offset"]

def write_weapon_stats(battle_table_data, weapon_definitions, keyblade_stats_data):
    i = 0
    while i < len(keyblade_list):
        if "STR" in keyblade_stats_data[i].keys():
            offset = get_weapon_byte_offset(weapon_definitions, "Strength", keyblade_list[i], "Sora")
            offset = int(offset,16)
            value = keyblade_stats_data[i]["STR"].to_bytes(1)
            if offset is not None:
                battle_table_data[offset] = int.from_bytes(value)
                print("Replaced STR of keyblade " + keyblade_list[i] + " with value " + str(keyblade_stats_data[i]["STR"]))
        if "CRR" in keyblade_stats_data[i].keys():
            offset = get_weapon_byte_offset(weapon_definitions, "Crit Percentage", keyblade_list[i], "Sora")
            offset = int(offset,16)
            value = keyblade_stats_data[i]["CRR"].to_bytes(1)
            if offset is not None:
                battle_table_data[offset] = int.from_bytes(value)
                print("Replaced CRR of keyblade " + keyblade_list[i] + " with value " + str(keyblade_stats_data[i]["CRR"]))
        if "CRB" in keyblade_stats_data[i].keys():
            offset = get_weapon_byte_offset(weapon_definitions, "Crit Bonus", keyblade_list[i], "Sora")
            offset = int(offset,16)
            value = keyblade_stats_data[i]["CRB"].to_bytes(1)
            if offset is not None:
                battle_table_data[offset] = int.from_bytes(value)
                print("Replaced CRB of keyblade " + keyblade_list[i] + " with value " + str(keyblade_stats_data[i]["CRB"]))
        if "REC" in keyblade_stats_data[i].keys():
            offset = get_weapon_byte_offset(weapon_definitions, "Recoil", keyblade_list[i], "Sora")
            offset = int(offset,16)
            value = keyblade_stats_data[i]["REC"].to_bytes(1)
            if offset is not None:
                battle_table_data[offset] = int.from_bytes(value)
                print("Replaced REC of keyblade " + keyblade_list[i] + " with value " + str(keyblade_stats_data[i]["REC"]))
        if "MP" in keyblade_stats_data[i].keys():
            offset = get_weapon_byte_offset(weapon_definitions, "MP", keyblade_list[i], "Sora")
            offset = int(offset,16)
            value = keyblade_stats_data[i]["MP"].to_bytes(1, signed=True)
            if offset is not None:
                battle_table_data[offset] = int.from_bytes(value)
                print("Replaced MP of keyblade " + keyblade_list[i] + " with value " + str(keyblade_stats_data[i]["MP"]))
        keyblade_description = ""
        keyblade_description = keyblade_description + "STR " + str(keyblade_stats_data[i]["STR"]) + " "
        keyblade_description = keyblade_description + "CRR " + str(keyblade_stats_data[i]["CRR"]) + " "
        keyblade_description = keyblade_description + "CRB " + str(keyblade_stats_data[i]["CRB"]) + " "
        keyblade_description = keyblade_description + "REC " + str(keyblade_stats_data[i]["REC"]) + " "
        keyblade_description = keyblade_description + "MP " + str(keyblade_stats_data[i]["MP"]) + "."
        replace_specific_item_description(i + 81, keyblade_description)
        i = i + 1
    return battle_table_data

def write_keyblade_stats(seed_json_file):
    kh1_data_path = BASE_DIR / "Working"
    keyblade_stats_data = read_json(seed_json_file)
    battle_table_bytes = read_bytes(kh1_data_path / "btltbl.bin")
    weapon_definitions = read_csv(BASE_DIR / "Documentation" / "KH1FM Documentation - Weapon Stats.csv")
    battle_table_bytes = write_weapon_stats(battle_table_bytes, weapon_definitions, keyblade_stats_data)
    write_bytes(kh1_data_path / "btltbl.bin", battle_table_bytes)