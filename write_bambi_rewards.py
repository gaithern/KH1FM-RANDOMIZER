import os

from definitions import filler_item_ids
from globals import BASE_DIR, read_csv, read_bytes, write_bytes

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

def write_bambi_rewards():
    kh1_data_path = BASE_DIR / "Working"
    bambi_definitions = read_csv(BASE_DIR / "Documentation/KH1FM Documentation - Bambi Drops.csv")
    bambi_bytes = read_bytes(kh1_data_path / "xa_ex_4030.mdls")
    bambi_bytes = remove_bambi_synth_drops(bambi_bytes, bambi_definitions)
    write_bytes(BASE_DIR / "Working/xa_ex_4030.mdls", bambi_bytes)