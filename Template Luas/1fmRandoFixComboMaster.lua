LUAGUI_NAME = "1fmRandoFixComboMaster"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Fix Combo Master"

canExecute = false

function overwrite_combo_master()
    --[[
    The game automatically overwrites the battle table 
    read from files to write Combo Master.
    Level 50 for Warrior
    Level 55 for Guardian
    Level 55 for Mystic
    ]]
    level_50_overwrite_value = 0x0
    level_55_overwrite_value = 0x0
    battle_table_address = {0x2D23740, 0x2D22D40}
    abilities_1_table_offset = 0x3BF8
    abilities_2_table_offset = 0x3BF8 - 0xD0
    abilities_3_table_offset = 0x3BF8 - 0x68
    WriteByte(battle_table_address[game_version] + abilities_1_table_offset + 48, level_50_overwrite_value)
    WriteByte(battle_table_address[game_version] + abilities_2_table_offset + 48, level_50_overwrite_value)
    WriteByte(battle_table_address[game_version] + abilities_3_table_offset + 48, level_50_overwrite_value)
    WriteByte(battle_table_address[game_version] + abilities_1_table_offset + 53, level_55_overwrite_value)
    WriteByte(battle_table_address[game_version] + abilities_2_table_offset + 53, level_55_overwrite_value)
    WriteByte(battle_table_address[game_version] + abilities_3_table_offset + 53, level_55_overwrite_value)
end

function _OnInit()
    IsEpicGLVersion  = 0x3A2B86
    IsSteamGLVersion = 0x3A29A6
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        if ReadByte(IsEpicGLVersion) == 0xF0 then
            ConsolePrint("Epic Version Detected")
            game_version = 1
            canExecute = true
        end
        if ReadByte(IsSteamGLVersion) == 0xF0 then
            ConsolePrint("Steam Version Detected")
            game_version = 2
            canExecute = true
        end
    end
end

function _OnFrame()
    if canExecute then
        overwrite_combo_master()
    end
end