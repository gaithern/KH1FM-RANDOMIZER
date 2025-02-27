from tkinter import filedialog
import csv
import json
import os

def get_evdl_locations():
    with open('./Documentation/KH1FM Documentation - Static Items.csv', mode = 'r') as file:
        evdl_locations = []
        evdl_location_data = csv.DictReader(file)
        for line in evdl_location_data:
            evdl_locations.append(line)
    return evdl_locations

def get_seed_json_data(seed_json_file = None):
    while not seed_json_file:
        seed_json_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Seed JSON")
        if not seed_json_file:
            print("Error, please select a valid KH1 seed file")
    with open(seed_json_file, mode='r') as file:
        seed_json_data = json.load(file)
    return seed_json_data

def get_evdl_bytes(file_path):
    with open(file_path, mode = 'rb') as file:
        return bytearray(file.read())

def sort_evdl_location_data(evdl_locations):
    sorted_evdl_location_data = {}
    for evdl_location in evdl_locations:
        if evdl_location["File"] not in sorted_evdl_location_data.keys():
            sorted_evdl_location_data[evdl_location["File"]] = []
        sorted_evdl_location_data[evdl_location["File"]].append(evdl_location)
    return sorted_evdl_location_data

def safe_open_wb(path):
    ''' Open "path" for writing, creating any parent directories as needed.
    '''
    os.makedirs(os.path.dirname(path), exist_ok=True)
    return open(path, 'wb')

def write_evdl_bytes_to_file(evdl_file, evdl_bytes):
    with safe_open_wb('./Working/' + evdl_file) as file:
        file.write(evdl_bytes)

def write_updated_evdl_files(sorted_evdl_location_data, seed_json_data, kh1_data_path):
    for file in sorted_evdl_location_data.keys():
        print("Preparing " + file)
        corrected_file = sorted_evdl_location_data[file][0]["Use Corrected File?"]
        if corrected_file == "Y":
            file_path = "./Corrected EVDLs/" + file
        else:
            file_path = kh1_data_path + file
        evdl_bytes = get_evdl_bytes(file_path)
        for replacement in sorted_evdl_location_data[file]:
            print(replacement)
            print("Updating " + replacement["AP Location ID"] + " at offset " + replacement["Offset"])
            if replacement["AP Location ID"] in seed_json_data.keys():
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
        write_evdl_bytes_to_file(file, evdl_bytes)

def write_static_items(seed_json_file = None):
    kh1_data_path = "./Working/"
    seed_json_data = get_seed_json_data(seed_json_file)
    evdl_locations = get_evdl_locations()
    sorted_evdl_location_data = sort_evdl_location_data(evdl_locations)
    write_updated_evdl_files(sorted_evdl_location_data, seed_json_data, kh1_data_path)

if __name__=="__main__":
    write_static_items()