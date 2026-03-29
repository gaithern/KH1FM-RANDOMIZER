LUAGUI_NAME = "1fmRandoFixComboMaster"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Fix Combo Master"

require("globals")

function overwrite_combo_master()
    --[[
    The game automatically overwrites the battle table 
    read from files to write Combo Master.
    Level 50 for Warrior
    Level 55 for Guardian
    Level 55 for Mystic
    ]]
    battle_table_address = jumpHeights - 0xAC
    abilities_1_table_offset = 0x3BF8
    abilities_2_table_offset = 0x3BF8 - 0xD0
    abilities_3_table_offset = 0x3BF8 - 0x68
    WriteByte(battle_table_address + abilities_1_table_offset + 48, level_50_overwrite_value)
    WriteByte(battle_table_address + abilities_2_table_offset + 48, level_50_overwrite_value)
    WriteByte(battle_table_address + abilities_3_table_offset + 48, level_50_overwrite_value)
    WriteByte(battle_table_address + abilities_1_table_offset + 53, level_55_overwrite_value)
    WriteByte(battle_table_address + abilities_2_table_offset + 53, level_55_overwrite_value)
    WriteByte(battle_table_address + abilities_3_table_offset + 53, level_55_overwrite_value)
end

function _OnInit()
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        require("VersionCheck")
    else
        ConsolePrint("KH1 not detected, not running script")
    end
end


function _OnFrame()
    if canExecute then
        overwrite_combo_master()
    end
end