import zipfile
import os
import tkinter as tk
from tkinter import filedialog

root = tk.Tk()
root.withdraw()

def extract_zip(zip_file_path):
    """Extracts a zip file to a folder with the same name."""

    with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
        # Get the name of the zip file without the extension
        folder_name = os.path.splitext(zip_file_path)[0]

        # Create the folder if it doesn't exist
        os.makedirs(folder_name, exist_ok=True)

        # Extract all contents of the zip file to the folder
        zip_ref.extractall(folder_name)

def get_ap_zip_file_name():
    ap_zip_file = None
    while not ap_zip_file:
        ap_zip_file = filedialog.askopenfilename(filetypes =[('ZIP', '*.zip')], title = "KH1 AP Output Zip")
        if not ap_zip_file:
            print("Error, please select a valid KH1 AP output zip file")
    return ap_zip_file

def unzip_ap_output():
    cwd = os.getcwd().replace("\\", "/")
    ap_zip_file_name = get_ap_zip_file_name()
    extract_zip(ap_zip_file_name)
    extract_folder_name = ap_zip_file_name.replace(".zip", "").replace(cwd, "")
    for file in os.listdir('./' + extract_folder_name + '/'):
        if file.endswith(".zip"):
            inner_extract_folder_name_path = file.replace(".zip", "")
            json_path = "./" + extract_folder_name + "/" + inner_extract_folder_name_path
            extract_zip('./' + extract_folder_name + '/' + file)
    print(json_path)
    return json_path

if __name__ == "__main__":
    unzip_ap_output()