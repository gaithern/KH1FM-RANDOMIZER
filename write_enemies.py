import random

from globals import BASE_DIR, read_csv, read_json, read_bytes, write_bytes, write_file

def choose_random_enemies(map_enemies, enemy_categories, seed):
    random.seed(seed)
    categories = ["Easy", "Medium", "Hard"]
    changes = {}
    for enemy in map_enemies:
        world          = enemy["World"]
        room           = enemy["Room"]
        original_enemy = enemy["Enemy"]
        file           = enemy["File"]
        offset         = enemy["Offset"]
        key = f"{world} {room} {original_enemy}"
        if key not in changes.keys():
            possible_options = []
            for category in categories:
                if enemy[category] == "TRUE":
                    possible_options = possible_options + enemy_categories[category]
            randomized_enemy = random.choice(possible_options)
            changes[key] = [{"randomized_enemy": randomized_enemy, "file": file, "offset": offset}]
        else:
            changes[key].append({"randomized_enemy": changes[key][0]["randomized_enemy"], "file": changes[key][0]["file"], "offset": offset})
    return changes

def compile_enemy_categories(enemy_categories):
    compiled_enemy_categories = {}
    for enemy in enemy_categories:
        if enemy["Category"] not in compiled_enemy_categories.keys():
            compiled_enemy_categories[enemy["Category"]] = []
        compiled_enemy_categories[enemy["Category"]].append({"enemy": enemy["Enemy"], "value": enemy["String"]})
    return compiled_enemy_categories

def get_enemy_rando_log(changes):
    log = ""
    for key in changes.keys():
        for change in changes[key]:
            log = f"{log}Changed {key} to {change["randomized_enemy"]["enemy"]}\n"
    return log

def change_ard_bytes(kh1_data_path, changes):
    for key in changes.keys():
        for change in changes[key]:
            file = change["file"]
            offset = int(change["offset"], 16)
            change_byte_array = bytearray(change["randomized_enemy"]["value"], "utf-8")
            
            print(f"Changed {key} to {change["randomized_enemy"]["enemy"]}\n")
            print_str = ""
            for byte in change_byte_array:
                print_str = f"{print_str}{hex(byte)} "
            print(print_str)
            
            bytes = read_bytes(kh1_data_path / file)
            i = 0
            for changed_byte in change_byte_array:
                bytes[offset + i] = change_byte_array[i]
                i = i + 1
            write_bytes(file, bytes)

def write_enemies(settings_file):
    kh1_data_path = BASE_DIR / "Working"
    settings_data = read_json(settings_file)
    if "randomize_enemies" in settings_data.keys():
        if settings_data["randomize_enemies"] != "off":
            map_enemies = read_csv(BASE_DIR / "Documentation/KH1FM Documentation - Map Enemies.csv")
            enemy_categories = read_csv(BASE_DIR / "Documentation/KH1FM Documentation - Enemy Categories.csv")
            enemy_categories = compile_enemy_categories(enemy_categories)
            changes = choose_random_enemies(map_enemies, enemy_categories, settings_data["seed"])
            change_ard_bytes(kh1_data_path, changes)
            enemy_rando_log = get_enemy_rando_log(changes)
            write_file(kh1_data_path / "enemy_rando_log.txt", enemy_rando_log)