from pathlib import Path
import sys
import json
import zipfile
import csv
import os
import shutil

if getattr(sys, "frozen", False):
    BASE_DIR = Path(sys.executable).parent
else:
    BASE_DIR = Path(__file__).resolve().parent

def read_json(path_to_json):
    with open(path_to_json, 'r') as file:
        data = json.load(file)
        return data

def write_json(path_to_json, data):
    data = json.dumps(data, indent=4)
    with open(path_to_json, "w") as file:
        file.write(data)

def copy_and_replace(source_path, destination_path):
    if os.path.exists(destination_path):
        os.remove(destination_path)
    shutil.copy2(source_path, destination_path)

def extract_zip(zip_file_path):
    with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
        folder_name = os.path.splitext(zip_file_path)[0]
        os.makedirs(folder_name, exist_ok=True)
        zip_ref.extractall(folder_name)

def read_csv(path_to_csv):
    with open(path_to_csv, "r", newline="") as file:
        return list(csv.DictReader(file))

def read_bytes(path_to_binary_file):
    with open(path_to_binary_file, mode = 'rb') as file:
        return bytearray(file.read())

def write_bytes(path_to_binary_file, bytes):
    os.makedirs(os.path.dirname(path_to_binary_file), exist_ok=True)
    with open(path_to_binary_file, 'wb') as file:
        file.write(bytes)

def read_file(path_to_file):
    with open(path_to_file, mode = 'r') as file:
        text = file.read()
    return text

def write_file(path_to_file, text):
    with open(path_to_file, mode = 'w') as file:
        file.write(text)