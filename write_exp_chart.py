from globals import BASE_DIR, read_csv, read_json, read_bytes, write_bytes

def apply_exp_multiplier(battle_table_bytes, settings_data, exp_chart_definitions):
    multiplier = settings_data["exp_multiplier"]
    for line in exp_chart_definitions:
        new_exp_to_add = max(int(int(line["EXP to Add"])//multiplier), 1)
        new_exp_to_add_bytes = new_exp_to_add.to_bytes(2, byteorder='little')
        battle_table_bytes[int(line["Offset"], 16)] = new_exp_to_add_bytes[0]
        battle_table_bytes[int(line["Offset"], 16) + 1] = new_exp_to_add_bytes[1]
    return battle_table_bytes

def write_exp_chart(settings_file):
    kh1_data_path = BASE_DIR / "Working"
    exp_chart_definitions = read_csv(BASE_DIR / "Documentation/KH1FM Documentation - EXP Chart.csv")
    settings_data = read_json(settings_file)
    battle_table_bytes = read_bytes(kh1_data_path / "btltbl.bin")
    battle_table_bytes = apply_exp_multiplier(battle_table_bytes, settings_data, exp_chart_definitions)
    write_bytes(kh1_data_path / "btltbl.bin", battle_table_bytes)