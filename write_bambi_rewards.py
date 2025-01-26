import tkinter as tk
from tkinter import filedialog
import csv
import json
from pprint import pprint
import os

from definitions import filler_item_ids

root = tk.Tk()
root.withdraw()

def get_bambi_definitions():
    with open('./KH1FM Documentation - Bambi Drops.csv', mode = 'r') as file:
        bambi_definitions = []
        bambi_data = csv.DictReader(file)
        for line in bambi_data:
            bambi_definitions.append(line)
    return bambi_definitions

def get_bambi_data(kh1_data_path):
    with open(kh1_data_path + "/xa_ex_4030.mdls", mode = 'rb') as file:
        return bytearray(file.read())

def remove_bambi_synth_drops(bambi_bytes, bambi_definitions):
    for bambi_definition in bambi_definitions:
        if bambi_definition["Notes"].startswith("Drop"):
            if int(bambi_definition["Value"]) not in filler_item_ids:
                offset = int(bambi_definition["Offset"], 16)
                bambi_bytes[offset-4] = 0
                bambi_bytes[offset-3] = 0
                bambi_bytes[offset-2] = 0
                bambi_bytes[offset-1] = 0
                bambi_bytes[offset] = 0
                bambi_bytes[offset+1] = 0
                bambi_bytes[offset+2] = 0
                bambi_bytes[offset+3] = 0
    return bambi_bytes

def safe_open_wb(path):
    ''' Open "path" for writing, creating any parent directories as needed.
    '''
    os.makedirs(os.path.dirname(path), exist_ok=True)
    return open(path, 'wb')

def write_bambi_mdls(bambi_bytes):
    with safe_open_wb('./Output/' + "xa_ex_4030.mdls") as file:
        file.write(bambi_bytes)

def write_bambi_rewards():
    kh1_data_path = "./Output/"
    bambi_definitions = get_bambi_definitions()
    bambi_bytes = get_bambi_data(kh1_data_path)
    bambi_bytes = remove_bambi_synth_drops(bambi_bytes, bambi_definitions)
    write_bambi_mdls(bambi_bytes)

if __name__=="__main__":
    write_bambi_rewards()