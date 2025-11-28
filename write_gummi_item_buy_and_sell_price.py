import json
import csv

def get_gumi_spec_file(kh1_data_path):
    with open(kh1_data_path + "/gumi_spec_file.bin", mode = 'rb') as file:
        return bytearray(file.read())

def get_gummi_block_prices():
    with open('./Documentation/KH1FM Documentation - Gummi Block Prices.csv', mode = 'r') as file:
        gummi_block_prices_definitions = []
        gummi_block_prices_data = csv.DictReader(file)
        for line in gummi_block_prices_data:
            gummi_block_prices_definitions.append(line)
    return gummi_block_prices_definitions
    
def output_gumi_spec_file(gummi_spec_file_bytes):
    with open('./Working/gumi_spec_file.bin', mode = 'wb') as file:
        file.write(gummi_spec_file_bytes)

def write_gummi_item_buy_and_sell_price():
    kh1_data_path = "./Working/"
    gumi_spec_file = get_gumi_spec_file(kh1_data_path)
    gummi_block_prices = get_gummi_block_prices()
    for gummi_block_price in gummi_block_prices:
        offset = int(gummi_block_price["Offset"], 16)
        gumi_spec_file[offset] = 0
    output_gumi_spec_file(gumi_spec_file)

if __name__ == "__main__":
    write_gummi_item_buy_and_sell_price()