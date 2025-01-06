import tkinter as tk
from tkinter import filedialog
import csv
import pprint

root = tk.Tk()
root.withdraw()

def get_kh1_data_path():
    kh1_data_path = None
    while not kh1_data_path:
        kh1_data_path = filedialog.askdirectory()
        if not kh1_data_path:
            print("Error, please select a valid KH1 data path")
    return kh1_data_path

def get_corrected_evdl_data():
    with open('./KH1FM Documentation - Static Items.csv', mode = 'r') as file:
        corrected_evdl_data = []
        corrected_evdl_csv_file_data = csv.DictReader(file)
        for line in corrected_evdl_csv_file_data:
            corrected_evdl_data.append(line)
    return corrected_evdl_data

def validate_data():
    error = False
    kh1_data_path = get_kh1_data_path()
    corrected_evdl_data = get_corrected_evdl_data()
    static_item_dict = {}
    for file_location in corrected_evdl_data:
        key = file_location["World"] + " " + file_location["Location"] + " " + file_location["Action"] + " " + file_location["Item"] + " " + file_location["Number"]
        if key not in static_item_dict.keys():
            static_item_dict[key] = []
        static_item_dict[key].append({"File": file_location["File"], "Offset": file_location["Offset"], "Use Corrected File?": file_location["Use Corrected File?"]})
    for item in static_item_dict.keys():
        bytes = []
        for file_location in static_item_dict[item]:
            if file_location["Use Corrected File?"] == "N":
                with open(kh1_data_path + "/" + file_location["File"], mode = 'rb') as data_file:
                    data = data_file.read()
                    offset = int(file_location["Offset"],16)
                    bytes.append(hex(data[offset]))
            else:
                with open("./Corrected EVDLs/" + file_location["File"], mode = 'rb') as data_file:
                    data = data_file.read()
                    offset = int(file_location["Offset"],16)
                    bytes.append(hex(data[offset]))
        if bytes.count(bytes[0]) != len(bytes):
            print("ERROR! Check " + item + " again!")
            print(bytes)
            error = True
    if not error:
        print("All checks completed successfully!")

if __name__=="__main__":
    validate_data()