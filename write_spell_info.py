import os
import json
import csv

from definitions import kh1_hex_to_char_map
from pprint import pprint

def find_byte_sequence(data, pattern):
    indexes = []
    start = 0
    while True:
        pos = data.find(pattern, start)
        if pos == -1:
            break
        indexes.append(pos)
        start = pos + 1
    return indexes

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def get_spell_mp_cost_definitions():
    with open('./Documentation/KH1FM Documentation - Spell MP Cost.csv', mode = 'r') as file:
        spell_mp_cost_definitions = []
        spell_mp_cost_data = csv.DictReader(file)
        for line in spell_mp_cost_data:
            spell_mp_cost_definitions.append(line)
    return spell_mp_cost_definitions

def get_spell_effectiveness_definitions():
    with open('./Documentation/KH1FM Documentation - Spell Effectiveness.csv', mode = 'r') as file:
        spell_effectiveness_definitions = []
        spell_effectiveness_data = csv.DictReader(file)
        for line in spell_effectiveness_data:
            spell_effectiveness_definitions.append(line)
    return spell_effectiveness_definitions

def get_spell_mp_costs_data(spell_mp_costs_json_file = None):
    while not spell_mp_costs_json_file:
        spell_mp_costs_json_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Spell MP Costs JSON File")
        if not spell_mp_costs_json_file:
            print("Error, please select a valid KH1 spell mp costs json file")
    with open(spell_mp_costs_json_file, mode='r') as file:
        spell_mp_costs_data = json.load(file)
    return spell_mp_costs_data

def get_battle_table(kh1_data_path):
    with open(kh1_data_path + "/btltbl.bin", mode = 'rb') as file:
        return bytearray(file.read())

def get_sysmsg_bytes(kh1_data_path):
    with open(kh1_data_path + "/remastered/menu/uk/sysmsg.bin/UK_sysmsg.binl", mode = 'rb') as file:
        return bytearray(file.read())

def replace_sysmsgs(sysmsg_bytes, spell_mp_costs_data):
    replacement_bytes = {
        15:  [0x21, 0x68, 0x26, 0x01, 0x2D], # "0.5 C"
        30:  [0x22, 0x68, 0x21, 0x01, 0x2D], # "1.0 C"
        60:  [0x23, 0x68, 0x21, 0x01, 0x2D], # "2.0 C"
        90:  [0x24, 0x68, 0x21, 0x01, 0x2D], # "3.0 C"
        100: [0x22, 0x68, 0x21, 0x01, 0x37], # "1.0 M"
        200: [0x23, 0x68, 0x21, 0x01, 0x37], # "2.0 M"
        300: [0x24, 0x68, 0x21, 0x01, 0x37]} # "2.0 M"
    search_sequence = [0x21, 0x68, 0x21, 0x01, 0x42] # Bytes corresponding to "0.0 X"
    indexes = find_byte_sequence(bytes(sysmsg_bytes), bytes(search_sequence))
    if len(indexes) != len(spell_mp_costs_data):
        print("ERROR: Indexes of substrings don't match number of spells expected.")
        exit(1)
    for i in range(len(spell_mp_costs_data)):
        sysmsg_bytes[indexes[i]]   = replacement_bytes[spell_mp_costs_data[i]][0]
        sysmsg_bytes[indexes[i]+1] = replacement_bytes[spell_mp_costs_data[i]][1]
        sysmsg_bytes[indexes[i]+2] = replacement_bytes[spell_mp_costs_data[i]][2]
        sysmsg_bytes[indexes[i]+3] = replacement_bytes[spell_mp_costs_data[i]][3]
        sysmsg_bytes[indexes[i]+4] = replacement_bytes[spell_mp_costs_data[i]][4]
    return sysmsg_bytes

def safe_open_wb(path):
    ''' Open "path" for writing, creating any parent directories as needed.
    '''
    os.makedirs(os.path.dirname(path), exist_ok=True)
    return open(path, 'wb')

def output_sysmsg_bytes(new_sysmsg_bytes):
    with safe_open_wb('./Working/remastered/menu/uk/sysmsg.bin/UK_sysmsg.binl') as file:
        file.write(new_sysmsg_bytes)

def replace_spell_costs_bytes(battle_table_bytes, spell_mp_costs_data, spell_mp_cost_definitions):
    for i in range(len(spell_mp_costs_data)):
        print(f"Index {i}: changing {spell_mp_cost_definitions[i]["Spell"]} to have a cost of {spell_mp_costs_data[i]} at offset {spell_mp_cost_definitions[i]["Offset"]}")
        battle_table_bytes[int(spell_mp_cost_definitions[i]["Offset"], 16)]     = spell_mp_costs_data[i]%256
        battle_table_bytes[int(spell_mp_cost_definitions[i]["Offset"], 16) + 1] = spell_mp_costs_data[i]//256
    return battle_table_bytes

def output_battle_table(battle_table_bytes):
    with open('./Working/btltbl.bin', mode = 'wb') as file:
        file.write(battle_table_bytes)

def replace_spell_effectiveness(battle_table_bytes, spell_mp_costs_data, spell_effectiveness_definitions):
    original_spell_costs = [
        30, 30, 30,
        30, 30, 30,
        100, 100, 100,
        100, 100, 100,
        100, 100, 100,
        200, 200, 200,
        200, 200, 200]
    for i in range(len(spell_effectiveness_definitions)):
        current_effectiveness = battle_table_bytes[int(spell_effectiveness_definitions[i]["Offset"], 16)]
        new_effectiveness = max([round(current_effectiveness * (spell_mp_costs_data[i] / original_spell_costs[i])), 1])
        battle_table_bytes[int(spell_effectiveness_definitions[i]["Offset"], 16)]     = new_effectiveness%256
        battle_table_bytes[int(spell_effectiveness_definitions[i]["Offset"], 16) + 1] = new_effectiveness//256
    return battle_table_bytes

def write_spell_info(settings_file = None, mp_cost_file = None):
    settings_data = get_settings_data(settings_file)
    if "randomize_spell_mp_costs" not in settings_data.keys():
        print("Generation is from older AP world, skipping...")
        return
    
    kh1_data_path = "./Working/"
    spell_mp_costs_data = get_spell_mp_costs_data(mp_cost_file)
    spell_mp_cost_definitions = get_spell_mp_cost_definitions()
    
    # Handle spell descriptions
    sysmsg_bytes = get_sysmsg_bytes(kh1_data_path)
    new_sysmsg_bytes = replace_sysmsgs(sysmsg_bytes, spell_mp_costs_data)
    output_sysmsg_bytes(bytes(new_sysmsg_bytes))
    
    # Handle spell costs
    battle_table_bytes = get_battle_table(kh1_data_path)
    battle_table_bytes = replace_spell_costs_bytes(battle_table_bytes, spell_mp_costs_data, spell_mp_cost_definitions)
    
    # Handle spell potency
    if settings_data["scaling_spell_potency"]:
        spell_effectiveness_definitions = get_spell_effectiveness_definitions()
        battle_table_bytes = replace_spell_effectiveness(battle_table_bytes, spell_mp_costs_data, spell_effectiveness_definitions)
    
    output_battle_table(battle_table_bytes)

if __name__ == "__main__":
    write_spell_info()
