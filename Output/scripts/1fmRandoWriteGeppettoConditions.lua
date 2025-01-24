-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------              by Gicu           -----
-------------------------------------------

LUAGUI_NAME = "1fmRandoWriteGeppettoConditions"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Handle Making the Items Received in Geppetto's House Simpler"

canExecute = false

function write_geppetto_conditions()
    darkball_defeated_address =             {0x2DEA56E, 0x2DE9B6E} --changed for EGS 1.0.0.10
    all_summons_address =                   {0x2DEAA8F, 0x2DEA08F} --changed for EGS 1.0.0.10
    times_entered_geppettos_house_address = {0x2DEAA97, 0x2DEA097} --changed for EGS 1.0.0.10
    obtained_cid_address =                  {0x2DEAA90, 0x2DEA090} --changed for EGS 1.0.0.10
    
    if ReadByte(times_entered_geppettos_house_address[game_version]) > 0 then
        WriteByte(times_entered_geppettos_house_address[game_version], 30)
        WriteShort(darkball_defeated_address[game_version], 5000)
        WriteByte(obtained_cid_address[game_version], 1)
    end
    
    summons_address = {0x2DEA530, 0x2DE9B30}
    summons_array = ReadArray(summons_address[game_version], 6)
    number_of_summons_obtained = 0
    for k,v in pairs(summons_array) do
        if v < 255 then
            number_of_summons_obtained = number_of_summons_obtained + 1
        end
    end
    if number_of_summons_obtained == 6 then
        WriteByte(all_summons_address[game_version], 1)
    end
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
        write_geppetto_conditions()
    end
end