from globals import BASE_DIR, read_csv, read_json, read_bytes, write_bytes

def sort_evdl_location_data(evdl_locations):
    sorted_evdl_location_data = {}
    for evdl_location in evdl_locations:
        if evdl_location["File"] not in sorted_evdl_location_data.keys():
            sorted_evdl_location_data[evdl_location["File"]] = []
        sorted_evdl_location_data[evdl_location["File"]].append(evdl_location)
    return sorted_evdl_location_data

def write_updated_evdl_files(sorted_evdl_location_data, seed_json_data, kh1_data_path):
    for file in sorted_evdl_location_data.keys():
        print("Preparing " + str(file))
        corrected_file = sorted_evdl_location_data[file][0]["Use Corrected File?"]
        if corrected_file == "Y":
            file_path = BASE_DIR / "Corrected EVDLs" / file
        else:
            file_path = kh1_data_path / file
        evdl_bytes = read_bytes(file_path)
        for replacement in sorted_evdl_location_data[file]:
            print(replacement)
            print("Updating " + replacement["AP Location ID"] + " at offset " + replacement["Offset"])
            if replacement["AP Location ID"] in seed_json_data:
                item_id = seed_json_data[replacement["AP Location ID"]] % 2640000
                if item_id > 1000 and item_id < 2000:
                    evdl_bytes[int(replacement["Offset"], 16)] = item_id % 1000
                    print("Writing item with value " + str(item_id % 1000))
                else:
                    evdl_bytes[int(replacement["Offset"], 16)] = 230
                    print("Writing generic AP Item")
            else:
                evdl_bytes[int(replacement["Offset"], 16)] = 1
                print("AP Location ID not found in replacement JSON, writing potion")
        write_bytes(kh1_data_path / file, evdl_bytes)

def write_static_items(seed_json_file):
    kh1_data_path = BASE_DIR / "Working"
    seed_json_data = read_json(seed_json_file)
    evdl_locations = read_csv(BASE_DIR / "Documentation" / "KH1FM Documentation - Static Items.csv")
    sorted_evdl_location_data = sort_evdl_location_data(evdl_locations)
    write_updated_evdl_files(sorted_evdl_location_data, seed_json_data, kh1_data_path)