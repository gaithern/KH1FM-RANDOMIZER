import tkinter as tk
from tkinter import filedialog
import os

from definitions import kh1_hex_to_char_map, new_item_descriptions

root = tk.Tk()
root.withdraw()

def get_kh1_data_path():
    kh1_data_path = None
    while not kh1_data_path:
        kh1_data_path = filedialog.askdirectory()
        if not kh1_data_path:
            print("Error, please select a valid KH1 data path")
    return kh1_data_path

def get_item_description_bytes(kh1_data_path):
    with open(kh1_data_path + "/remastered/btltbl.bin/UK_ItemHelp.bin", mode = 'rb') as file:
        return bytearray(file.read())

def get_replacement_byte(char):
    for i in range(len(kh1_hex_to_char_map)):
        if kh1_hex_to_char_map[i] == char:
            return i

def safe_open_wb(path):
    ''' Open "path" for writing, creating any parent directories as needed.
    '''
    os.makedirs(os.path.dirname(path), exist_ok=True)
    return open(path, 'wb')

def output_item_descriptions(new_item_description_bytes):
    with safe_open_wb('./Output/remastered/btltbl.bin/UK_ItemHelp.bin') as file:
        file.write(new_item_description_bytes)

kh1_data_path = get_kh1_data_path()
item_description_bytes = get_item_description_bytes(kh1_data_path)
item_description_string = ""
for byte in item_description_bytes:
    item_description_string = item_description_string + kh1_hex_to_char_map[byte]
item_description_string = item_description_string.replace("{0x0D} {eol}", "{escape character}")
item_descriptions = item_description_string.replace("{lf}", "\n").split("{eol}")
new_item_description_string = ""
for i in range(len(item_descriptions)):
    if i+1 in new_item_descriptions.keys():
        new_item_description_string = new_item_description_string + new_item_descriptions[i+1] + "{eol}"
    else:
        new_item_description_string = new_item_description_string + item_descriptions[i] + "{eol}"
new_item_description_string = new_item_description_string[:-5]
new_item_description_string = new_item_description_string.replace("{escape character}","{0x0D} {eol}").replace("\n", "{lf}")
new_item_description_bytes = []
i = 0
while i < len(new_item_description_string):
    if new_item_description_string[i] == "{":
        j = 0
        char = "{"
        while new_item_description_string[i + j] != "}":
            j = j + 1
            char = char + new_item_description_string[i + j]
        i = i + j
    else:
        char = new_item_description_string[i]
    replacement_byte = get_replacement_byte(char)
    new_item_description_bytes.append(replacement_byte)
    i = i + 1
output_item_descriptions(bytes(new_item_description_bytes))
