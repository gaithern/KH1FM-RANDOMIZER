from globals import read_json, read_file, write_file

def update_fix_combo_master_template_lua(fix_combo_master_lua_str, seed_json_data):
    if "2658150" in seed_json_data.keys():
        if seed_json_data["2658150"] > 2643000 and seed_json_data["2658150"] < 2644000:
            fix_combo_master_lua_str = fix_combo_master_lua_str.replace("level_50_overwrite_value = 0x0", "level_50_overwrite_value = " + str(hex(seed_json_data["2658150"] % 2643000 + 0x80)))
    if "2658155" in seed_json_data.keys():
        if seed_json_data["2658155"] > 2643000 and seed_json_data["2658155"] < 2644000:
            fix_combo_master_lua_str = fix_combo_master_lua_str.replace("level_55_overwrite_value = 0x0", "level_55_overwrite_value = " + str(hex(seed_json_data["2658155"] % 2643000 + 0x80)))
    return fix_combo_master_lua_str

def write_fix_combo_master(seed_json_file):
    seed_json_data = read_json(seed_json_file)
    fix_combo_master_lua_str = read_file(BASE_DIR / "Template Luas/1fmRandoFixComboMaster.lua")
    fix_combo_master_lua_str = update_fix_combo_master_template_lua(fix_combo_master_lua_str, seed_json_data)
    write_file(BASE_DIR / "Working/1fmRandoFixComboMaster.lua", fix_combo_master_lua_str)