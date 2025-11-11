import os
import json
import csv

from definitions import kh1_hex_to_char_map
from pprint import pprint

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
        300: [0x24, 0x68, 0x21, 0x01, 0x37]} # "3.0 M"
    indexes = {
        0x133F:  0, 0x134C:  1, 0x135B:  2, # Fire     description
        0x1380:  0, 0x138D:  1, 0x139C:  2, # Fira     description
        0x13C2:  0, 0x13CF:  1, 0x13DE:  2, # Firaga   description
        0x140D:  3, 0x141E:  4, 0x142F:  5, # Blizzard description
        0x1447:  3, 0x1458:  4, 0x1469:  5, # Blizzara description
        0x149D:  3, 0x14AE:  4, 0x14BF:  5, # Blizzaga description
        0x14E5:  6, 0x14F6:  7, 0x1507:  8, # Thunder  description
        0x1521:  6, 0x1532:  7, 0x1543:  8, # Thundara description
        0x1565:  6, 0x1576:  7, 0x1587:  8, # Thundaga description
        0x15AA:  9, 0x15B7: 10, 0x15C6: 11, # Cure     description
        0x15E0:  9, 0x15ED: 10, 0x15FC: 11, # Cura     description
        0x1616:  9, 0x1623: 10, 0x1632: 11, # Cura     description
        0x165A: 12, 0x166A: 13, 0x167A: 14, # Gravity  description
        0x16BF: 12, 0x16CF: 13, 0x16DF: 14, # Gravira  description
        0x171C: 12, 0x172C: 13, 0x173C: 14, # Graviga  description
        0x1776: 15, 0x1785: 16, 0x1794: 17, # Stop     description
        0x17BC: 15, 0x17CB: 16, 0x17DA: 17, # Stopra   description
        0x1818: 15, 0x1827: 16, 0x1836: 17, # Stopga   description
        0x1876: 18, 0x1885: 19, 0x1894: 20, # Aero     description
        0x18AC: 18, 0x18BB: 19, 0x18CA: 20, # Aerora   description
        0x18FE: 18, 0x190D: 19, 0x191C: 20, # Aeroga   description
    }
    for index in indexes.keys():
        new_cost = spell_mp_costs_data[indexes[index]]
        sysmsg_bytes[index]   = replacement_bytes[new_cost][0]
        sysmsg_bytes[index+1] = replacement_bytes[new_cost][1]
        sysmsg_bytes[index+2] = replacement_bytes[new_cost][2]
        sysmsg_bytes[index+3] = replacement_bytes[new_cost][3]
        sysmsg_bytes[index+4] = replacement_bytes[new_cost][4]
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
