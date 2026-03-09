import shutil

from globals import BASE_DIR, read_csv

def write_static_files():
    shutil.copytree(BASE_DIR / "Static Files", BASE_DIR / "Working", dirs_exist_ok=True)

def list_definition_files_in_current_directory():
    files = []
    for file in (BASE_DIR / "Documentation").iterdir():
        if "KH1FM Documentation" in file.name:
            files.append(file.name)
    return files

def copy_src_kh1_files_to_output(kh1_data_path, csv_lines):
    copied_files = []
    for line in csv_lines:
        if "File" in line.keys():
            if line["File"] not in copied_files:
                source_path = kh1_data_path
                if "Use Corrected File?" in line.keys():
                    if line["Use Corrected File?"] == "Y":
                        source_path = BASE_DIR / "Corrected EVDLs"
                input_full_path = source_path / line["File"]
                output_full_path = BASE_DIR / "Working" / line["File"]
                print(f"Copying {input_full_path} to {output_full_path}")
                output_full_path.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(input_full_path, output_full_path)
                copied_files.append(line["File"])

def write_files_to_working(kh1_data_path):
    csv_lines = []
    for file in list_definition_files_in_current_directory():
        csv_lines = csv_lines + read_csv(BASE_DIR / "Documentation" / file)
    copy_src_kh1_files_to_output(kh1_data_path, csv_lines)
    write_static_files()