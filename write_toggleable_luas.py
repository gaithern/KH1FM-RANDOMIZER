from globals import BASE_DIR, read_json, read_file, write_file

def get_interaction_file(settings):
    if "world_version" not in settings:
        return "1fmRandoInteraction_Old.lua"
    return "1fmRandoInteraction.lua"

lua_map = {
    "shorten_go_mode":         "1fmRandoShortenGoMode.lua",
    "one_hp":                  "1fm1HP.lua",
    "four_by_three":           "1fm4By3.lua",
    "beep_hack":               "1fmBeepHack.lua",
    "consistent_finishers":    "1fmConsistentFinishers.lua",
    "early_skip":              "1fmEarlySkip.lua",
    "fast_camera":             "1fmFastCamera.lua",
    "faster_animations":       "1fmFasterAnims.lua",
    "unlock_0_volume":         "1fmUnlock0Volume.lua",
    "unskippable":             "1fmUnskippable.lua",
    "auto_save":               "1fmRandoAutoSave.lua",
    "warp_anywhere":           "1fmRandoWarpAnywhere.lua",
    "destiny_islands":         "1fmRandoAllowDestinyIslands.lua",
    "accessory_augments":      "1fmRandoHandleAugments.lua",
    "interact_in_battle":      get_interaction_file,
    "keyblades_unlock_chests": get_interaction_file,
    "randomize_ap_costs":      "1fmRandoAPCosts.lua"
    }

def output_lua(lua_file_name):
    lua_str = read_file(BASE_DIR / "Template Luas" / lua_file_name)
    write_file(BASE_DIR / "Working" / "scripts" / lua_file_name, lua_str)

def write_toggleable_luas(settings_file):
    settings_data = read_json(settings_file)
    written_files = set()
    for key, value in lua_map.items():
        is_enabled = str(settings_data.get(key, "false")).lower() not in ["false", "off"]
        if is_enabled:
            lua_file_name = value(settings_data) if callable(value) else value
            if lua_file_name not in written_files:
                output_lua(lua_file_name)
                written_files.add(lua_file_name)