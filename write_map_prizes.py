from globals import BASE_DIR, read_csv, read_bytes, write_bytes, read_json

def remove_map_prizes(map_prize_bytes, map_prize_definitions):
    for map_prize_definition in map_prize_definitions:
        offset = int(map_prize_definition["Offset"],16)
        for i in range(23):
            map_prize_bytes[offset + i] = 0
    return map_prize_bytes

def replace_map_prize_items(map_prize_bytes, map_prize_definitions, seed_json_data):
    for map_prize_definition in map_prize_definitions:
        if map_prize_definition["AP Location ID"] != "-":
            offset = int(map_prize_definition["Offset"],16)
            item = seed_json_data[map_prize_definition["AP Location ID"]] % 264100
            if item > 255: # If its an ability, must have been placed there as remote_items was set to allow
                item = 230 # Make it AP item, the item must be remote.
            map_prize_bytes[offset + 7] = 100
            map_prize_bytes[offset + 8] = item
    return map_prize_bytes

def write_map_prizes(seed_json_file):
    kh1_data_path = BASE_DIR / "Working"
    map_prize_definitions = read_csv(BASE_DIR / "Documentation" / "KH1FM Documentation - Map Prizes.csv")
    map_prize_data = read_bytes(kh1_data_path / "map_prize.bin")
    map_prize_bytes = remove_map_prizes(map_prize_data, map_prize_definitions)
    seed_json_data = read_json(seed_json_file)
    map_prize_bytes = replace_map_prize_items(map_prize_bytes, map_prize_definitions, seed_json_data)
    write_bytes(kh1_data_path / "map_prize.bin", map_prize_bytes)