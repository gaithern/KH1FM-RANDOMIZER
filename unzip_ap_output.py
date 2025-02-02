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

def unzip_ap_output(ap_zip_file_name = None):
    cwd = os.getcwd().replace("\\", "/")
    if ap_zip_file_name is None:
        ap_zip_file_name = get_ap_zip_file_name()
    extract_zip(ap_zip_file_name)
    json_path = ap_zip_file_name.replace(".zip","") + "/"
    print(json_path)
    return json_path

if __name__ == "__main__":
    unzip_ap_output()