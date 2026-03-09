from globals import BASE_DIR, read_csv

def validate_evdl_data(kh1_data_path):
    error = False
    corrected_evdl_data = read_csv(BASE_DIR / "Documentation/KH1FM Documentation - Static Items.csv")
    static_item_dict = {}
    use_corrected_evdl_dict = {}
    for file_location in corrected_evdl_data:
        key = f"{file_location["World"]} {file_location["Location"]} {file_location["Action"]} {file_location["Item"]} {file_location["Number"]}"
        if key not in static_item_dict.keys():
            static_item_dict[key] = []
        static_item_dict[key].append({"File": file_location["File"], "Offset": file_location["Offset"], "Use Corrected File?": file_location["Use Corrected File?"]})
    for item in static_item_dict.keys():
        bytes = []
        for file_location in static_item_dict[item]:
            if file_location["Use Corrected File?"] == "N":
                with open(kh1_data_path / file_location["File"], mode = 'rb') as data_file:
                    data = data_file.read()
                    offset = int(file_location["Offset"],16)
                    bytes.append(hex(data[offset]))
            else:
                with open(BASE_DIR / "Corrected EVDLs" / file_location["File"], mode = 'rb') as data_file:
                    data = data_file.read()
                    offset = int(file_location["Offset"],16)
                    bytes.append(hex(data[offset]))
        if bytes.count(bytes[0]) != len(bytes):
            print(f"ERROR! Check {item} again!")
            print(bytes)
            error = True
    for file_location in corrected_evdl_data:
        if file_location["File"] not in use_corrected_evdl_dict.keys():
            use_corrected_evdl_dict[file_location["File"]] = file_location["Use Corrected File?"]
        elif use_corrected_evdl_dict[file_location["File"]] != file_location["Use Corrected File?"]:
            print(f"ERROR! Check {file_location["File"]} again!  Multiple Use Corrected File? values found")
            error = True
    if not error:
        print("All checks completed successfully!")