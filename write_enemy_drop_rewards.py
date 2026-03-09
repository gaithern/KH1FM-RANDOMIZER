from definitions import filler_item_ids
from globals import BASE_DIR, read_csv, read_bytes, write_bytes

def remove_enemy_synth_drops(enemy_bytes, enemy_drop_definitions):
    for enemy_drop_definition in enemy_drop_definitions:
        if enemy_drop_definition["Notes"].startswith("Drop"):
            if int(enemy_drop_definition["Value"]) not in filler_item_ids:
                offset = int(enemy_drop_definition["Offset"], 16)
                enemy_bytes[offset-4] = 0
                enemy_bytes[offset-3] = 0
                enemy_bytes[offset-2] = 0
                enemy_bytes[offset-1] = 0
                enemy_bytes[offset] = 0
                enemy_bytes[offset+1] = 0
                enemy_bytes[offset+2] = 0
                enemy_bytes[offset+3] = 0
    return enemy_bytes

def sort_enemy_drop_definitions(enemy_drop_definitions):
    sorted_enemy_drop_definitions = {}
    for enemy_drop_definition in enemy_drop_definitions:
        if enemy_drop_definition["File"] not in sorted_enemy_drop_definitions.keys():
            sorted_enemy_drop_definitions[enemy_drop_definition["File"]] = []
        sorted_enemy_drop_definitions[enemy_drop_definition["File"]].append(enemy_drop_definition)
    return sorted_enemy_drop_definitions

def write_enemy_drop_rewards():
    kh1_data_path = BASE_DIR / "Working"
    enemy_drop_definitions = read_csv(BASE_DIR / "Documentation/KH1FM Documentation - Enemy Stats and Drops.csv")
    sorted_enemy_drop_definitions = sort_enemy_drop_definitions(enemy_drop_definitions)
    for file in sorted_enemy_drop_definitions.keys():
        enemy_bytes = read_bytes(kh1_data_path / file)
        enemy_bytes = remove_enemy_synth_drops(enemy_bytes, sorted_enemy_drop_definitions[file])
        write_bytes(kh1_data_path / file, enemy_bytes)