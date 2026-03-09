from definitions import sort_order, filler_item_ids
from globals import BASE_DIR, read_json, read_csv, read_bytes, write_bytes

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

def write_item_sort_order():
    kh1_data_path = BASE_DIR / "Working"
    battle_table_bytes = read_bytes(kh1_data_path / "btltbl.bin")
    battle_table_item_definitions = read_csv(BASE_DIR / "Documentation" / "KH1FM Documentation - Battle Table Items.csv")
    for battle_table_item_definition in battle_table_item_definitions:
        if battle_table_item_definition["Notes"] == "Sort Order":
            offset = int(battle_table_item_definition["Offset"], 16)
            replacement = sort_order[int(battle_table_item_definition["Item Index"]) - 1]
            replacement_byte_array = replacement.to_bytes(4, byteorder = "little")
            battle_table_bytes[offset] = replacement_byte_array[0]
            battle_table_bytes[offset + 1] = replacement_byte_array[1]
            battle_table_bytes[offset + 2] = replacement_byte_array[2]
            battle_table_bytes[offset + 3] = replacement_byte_array[3]
    write_bytes(kh1_data_path / "btltbl.bin", battle_table_bytes)

def write_item_sell_price():
    kh1_data_path = BASE_DIR / "Working"
    battle_table_bytes = read_bytes(kh1_data_path / "btltbl.bin")
    battle_table_item_definitions = read_csv(BASE_DIR / "Documentation" / "KH1FM Documentation - Battle Table Items.csv")
    for battle_table_item_definition in battle_table_item_definitions:
        if battle_table_item_definition["Notes"] == "Sell Price":
            if int(battle_table_item_definition["Item Index"]) not in filler_item_ids:
                offset = int(battle_table_item_definition["Offset"], 16)
                replacement = 0
                replacement_byte_array = replacement.to_bytes(2, byteorder = "little")
                battle_table_bytes[offset] = replacement_byte_array[0]
                battle_table_bytes[offset + 1] = replacement_byte_array[1]
    write_bytes(kh1_data_path / "btltbl.bin", battle_table_bytes)

def write_item_buy_price(new_prices):
    kh1_data_path = BASE_DIR / "Working"
    battle_table_bytes = read_bytes(kh1_data_path / "btltbl.bin")
    battle_table_item_definitions = read_csv(BASE_DIR / "Documentation" / "KH1FM Documentation - Battle Table Items.csv")
    for battle_table_item_definition in battle_table_item_definitions:
        if battle_table_item_definition["Notes"] == "Buy Price":
            if int(battle_table_item_definition["Item Index"]) in new_prices.keys():
                offset = int(battle_table_item_definition["Offset"], 16)
                replacement = new_prices[int(battle_table_item_definition["Item Index"])]
                replacement_byte_array = replacement.to_bytes(2, byteorder = "little")
                battle_table_bytes[offset] = replacement_byte_array[0]
                battle_table_bytes[offset + 1] = replacement_byte_array[1]
    write_bytes(kh1_data_path / "btltbl.bin", battle_table_bytes)

def write_item_sort_order_and_sell_price(settings_file):
    settings_data = read_json(settings_file)
    new_prices = {}
    new_prices[4] = 400 # Elixir added for WL flowers
    new_prices[254] = settings_data["mythril_price"]
    new_prices[255] = settings_data["orichalcum_price"]
    write_item_sort_order()
    write_item_sell_price()
    write_item_buy_price(new_prices)