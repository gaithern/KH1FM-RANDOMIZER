import os
import shutil
import tkinter as tk
from tkinter import filedialog
import csv
import json

def get_kh1_data_path(kh1_data_path = None):
    while not kh1_data_path:
        kh1_data_path = filedialog.askdirectory()
        if not kh1_data_path:
            print("Error, please select a valid KH1 data path")
    return kh1_data_path

def write_static_files():
    shutil.copytree("./Static Files/",  "./Working/", dirs_exist_ok=True)

def list_definition_files_in_current_directory():
    files = []
    for file in os.listdir("./Documentation/"):
        if "KH1FM Documentation" in file:
            files.append(file)
    return files

def read_csv_data(filepath):
    with open(filepath, mode = 'r') as file:
        csv_lines = []
        csv_data = csv.DictReader(file)
        for line in csv_data:
            csv_lines.append(line)
    return csv_lines

def get_directory(filepath):
    return os.path.dirname(filepath)

def copy_src_kh1_files_to_output(kh1_data_path, csv_lines):
    copied_files = []
    for line in csv_lines:
        if "File" in line.keys():
            if line["File"] not in copied_files:
                source_path = kh1_data_path
                if "Use Corrected File?" in line.keys():
                    if line["Use Corrected File?"] == "Y":
                        source_path = "./Corrected EVDLs/"
                input_full_path = source_path + "/" +  line["File"]
                output_full_path = "./Working/" + "/" + line["File"]
                print("Copying " + input_full_path + " to " + output_full_path)
                if not os.path.exists(get_directory(output_full_path)):
                    os.makedirs(get_directory(output_full_path))
                shutil.copyfile(input_full_path, output_full_path)
                copied_files.append(line["File"])

def write_files_to_working(kh1_data_path = None):
    kh1_data_path = get_kh1_data_path(kh1_data_path)
    csv_lines = []
    for file in list_definition_files_in_current_directory():
        csv_lines = csv_lines + read_csv_data("./Documentation/" + file)
    copy_src_kh1_files_to_output(kh1_data_path, csv_lines)
    write_static_files()

if __name__=="__main__":
    write_files_to_working()