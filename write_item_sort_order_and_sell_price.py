from tkinter import filedialog
import json
import csv
#import pandas as pd

from definitions import item_list, sort_order, filler_item_ids, buy_prices

def get_battle_table(kh1_data_path):
    with open(kh1_data_path + "/btltbl.bin", mode = 'rb') as file:
        return bytearray(file.read())

def to_hex_no_0x(val):
    val = hex(val).upper().replace("0X","")
    if len(val) % 2 == 1:
        val = "0" + val
    return val
    
def bytes_to_int(byte_array, byteorder='little'):
    return int.from_bytes(byte_array, byteorder)

def convert_byte_array_to_string(byte_array):
    output_string = ""
    for byte in byte_array:
        output_string = output_string + to_hex_no_0x(byte) + " "
    return output_string[:-1]

#def write_item_csv():
#    kh1_data_path = "./Working/"
#    battle_table_bytes = get_battle_table(kh1_data_path)
#    per_item_bytes = 20
#    items = 255
#    start_index = 0x1A58
#    end_index = start_index + (per_item_bytes * items)
#    item_bytes = battle_table_bytes[start_index:end_index]
#    i = 0
#    j = 0
#    btl_tbl_item_values = []
#    while i < len(item_bytes):
#        btl_tbl_item_values.append({
#            "Item Index": j + 1,
#            "Item Name": item_list[j],
#            "File": "btltbl.bin",
#            "Offset": to_hex_no_0x(start_index + i),
#            "Value (HEX)": convert_byte_array_to_string(item_bytes[i:i+2]),
#            "Value": bytes_to_int(item_bytes[i:i+2]),
#            "Notes": "Item Name"
#            })
#        btl_tbl_item_values.append({
#            "Item Index": j + 1,
#            "Item Name": item_list[j],
#            "File": "btltbl.bin",
#            "Offset": to_hex_no_0x(start_index + i+2),
#            "Value (HEX)": convert_byte_array_to_string([item_bytes[i+2]]),
#            "Value": bytes_to_int([item_bytes[i+2]]),
#            "Notes": "Item Icon"
#            })
#        btl_tbl_item_values.append({
#            "Item Index": j + 1,
#            "Item Name": item_list[j],
#            "File": "btltbl.bin",
#            "Offset": to_hex_no_0x(start_index + i+3),
#            "Value (HEX)": convert_byte_array_to_string([item_bytes[i+3]]),
#            "Value": bytes_to_int([item_bytes[i+3]]),
#            "Notes": "???"
#            })
#        btl_tbl_item_values.append({
#            "Item Index": j + 1,
#            "Item Name": item_list[j],
#            "File": "btltbl.bin",
#            "Offset": to_hex_no_0x(start_index + i+4),
#            "Value (HEX)": convert_byte_array_to_string(item_bytes[i+4:i+6]),
#            "Value": bytes_to_int(item_bytes[i+4:i+6]),
#            "Notes": "???"
#            })
#        btl_tbl_item_values.append({
#            "Item Index": j + 1,
#            "Item Name": item_list[j],
#            "File": "btltbl.bin",
#            "Offset": to_hex_no_0x(start_index + i+6),
#            "Value (HEX)": convert_byte_array_to_string(item_bytes[i+6:i+8]),
#            "Value": bytes_to_int(item_bytes[i+6:i+8]),
#            "Notes": "???"
#            })
#        btl_tbl_item_values.append({
#            "Item Index": j + 1,
#            "Item Name": item_list[j],
#            "File": "btltbl.bin",
#            "Offset": to_hex_no_0x(start_index + i+8),
#            "Value (HEX)": convert_byte_array_to_string(item_bytes[i+8:i+10]),
#            "Value": bytes_to_int(item_bytes[i+8:i+10]),
#            "Notes": "Buy Price"
#            })
#        btl_tbl_item_values.append({
#            "Item Index": j + 1,
#            "Item Name": item_list[j],
#            "File": "btltbl.bin",
#            "Offset": to_hex_no_0x(start_index + i+10),
#            "Value (HEX)": convert_byte_array_to_string(item_bytes[i+10:i+12]),
#            "Value": bytes_to_int(item_bytes[i+10:i+12]),
#            "Notes": "Sell Price"
#            })
#        btl_tbl_item_values.append({
#            "Item Index": j + 1,
#            "Item Name": item_list[j],
#            "File": "btltbl.bin",
#            "Offset": to_hex_no_0x(start_index + i+12),
#            "Value (HEX)": convert_byte_array_to_string(item_bytes[i+12:i+14]),
#            "Value": bytes_to_int(item_bytes[i+12:i+14]),
#            "Notes": "???"
#            })
#        btl_tbl_item_values.append({
#            "Item Index": j + 1,
#            "Item Name": item_list[j],
#            "File": "btltbl.bin",
#            "Offset": to_hex_no_0x(start_index + i+14),
#            "Value (HEX)": convert_byte_array_to_string(item_bytes[i+14:i+16]),
#            "Value": bytes_to_int(item_bytes[i+14:i+16]),
#            "Notes": "???"
#            })
#        btl_tbl_item_values.append({
#            "Item Index": j + 1,
#            "Item Name": item_list[j],
#            "File": "btltbl.bin",
#            "Offset": to_hex_no_0x(start_index + i+16),
#            "Value (HEX)": convert_byte_array_to_string(item_bytes[i+16:i+20]),
#            "Value": bytes_to_int(item_bytes[i+16:i+20]),
#            "Notes": "Sort Order"
#            })
#        i = i + 20
#        j = j + 1
#
#       for item in btl_tbl_item_values:
#           print(item)
#
#       df = pd.DataFrame(btl_tbl_item_values)
#       df.to_csv("Battle Table Items.csv", index=False, quoting=csv.QUOTE_ALL)

def get_battle_table_item_definitions():
    with open('./Documentation/KH1FM Documentation - Battle Table Items.csv', mode = 'r') as file:
        battle_table_item_definitions = []
        battle_table_item_data = csv.DictReader(file)
        for line in battle_table_item_data:
            battle_table_item_definitions.append(line)
    return battle_table_item_definitions

def output_battle_table(battle_table_bytes):
    with open('./Working/btltbl.bin', mode = 'wb') as file:
        file.write(battle_table_bytes)

def write_item_sort_order():
    kh1_data_path = "./Working/"
    battle_table_bytes = get_battle_table(kh1_data_path)
    battle_table_item_definitions = get_battle_table_item_definitions()
    for battle_table_item_definition in battle_table_item_definitions:
        if battle_table_item_definition["Notes"] == "Sort Order":
            offset = int(battle_table_item_definition["Offset"], 16)
            replacement = sort_order[int(battle_table_item_definition["Item Index"]) - 1]
            replacement_byte_array = replacement.to_bytes(4, byteorder = "little")
            battle_table_bytes[offset] = replacement_byte_array[0]
            battle_table_bytes[offset + 1] = replacement_byte_array[1]
            battle_table_bytes[offset + 2] = replacement_byte_array[2]
            battle_table_bytes[offset + 3] = replacement_byte_array[3]
    output_battle_table(battle_table_bytes)

def write_item_sell_price():
    kh1_data_path = "./Working/"
    battle_table_bytes = get_battle_table(kh1_data_path)
    battle_table_item_definitions = get_battle_table_item_definitions()
    for battle_table_item_definition in battle_table_item_definitions:
        if battle_table_item_definition["Notes"] == "Sell Price":
            if int(battle_table_item_definition["Item Index"]) not in filler_item_ids:
                offset = int(battle_table_item_definition["Offset"], 16)
                replacement = 0
                replacement_byte_array = replacement.to_bytes(2, byteorder = "little")
                battle_table_bytes[offset] = replacement_byte_array[0]
                battle_table_bytes[offset + 1] = replacement_byte_array[1]
    output_battle_table(battle_table_bytes)

def write_item_buy_price(new_prices):
    kh1_data_path = "./Working/"
    battle_table_bytes = get_battle_table(kh1_data_path)
    battle_table_item_definitions = get_battle_table_item_definitions()
    for battle_table_item_definition in battle_table_item_definitions:
        if battle_table_item_definition["Notes"] == "Buy Price":
            if int(battle_table_item_definition["Item Index"]) in new_prices.keys():
                offset = int(battle_table_item_definition["Offset"], 16)
                replacement = new_prices[int(battle_table_item_definition["Item Index"])]
                replacement_byte_array = replacement.to_bytes(2, byteorder = "little")
                battle_table_bytes[offset] = replacement_byte_array[0]
                battle_table_bytes[offset + 1] = replacement_byte_array[1]
    output_battle_table(battle_table_bytes)

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def write_item_sort_order_and_sell_price(settings_file = None):
    settings_data = get_settings_data(settings_file)
    new_prices = {}
    new_prices[4] = 400 # Elixir added for WL flowers
    new_prices[254] = settings_data["mythril_price"]
    new_prices[255] = settings_data["orichalcum_price"]
    write_item_sort_order()
    write_item_sell_price()
    write_item_buy_price(new_prices)

if __name__ == "__main__":
    write_item_sort_order_and_sell_price()