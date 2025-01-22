-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------              by Gicu           -----
-------------------------------------------

LUAGUI_NAME = "1fmAPInstantGummi"
LUAGUI_AUTH = "denhonator with edits from Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Instantly arrive at Gummi Destination"

game_version = 1 --1 for EGS 1.0.0.10, 2 for Steam 1.0.0.10
local worldWarpBase = {0x50F9D0, 0x50AB90}
local cutsceneFlagBase = {0x2DEA760, 0x2DE9D60} --changed for EGS 1.0.0.10

local canExecute = false

function _OnInit()
    IsEpicGLVersion  = 0x3A2B86
    IsSteamGLVersion = 0x3A29A6
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        if ReadByte(IsEpicGLVersion) == 0xF0 then
            ConsolePrint("Epic Version Detected")
            game_version = 1
        end
        if ReadByte(IsSteamGLVersion) == 0xF0 then
            ConsolePrint("Steam Version Detected")
            game_version = 2
        end
        canExecute = true
    end
end

function _OnFrame()
    if not canExecute then
        goto done
    end
    
    selection_address = {0x507D7C, 0x50707C}
    local selection = ReadInt(selection_address[game_version])
    local realSelection = selection
    
    local neverlandState = ReadByte(cutsceneFlagBase[game_version]+0xB0D) < 0x14
    local deepJungleState = ReadByte(cutsceneFlagBase[game_version]+0xB05) < 0x10

    WriteByte(worldWarpBase[game_version]+0x2A, deepJungleState and 0 or 0xE)
    WriteByte(worldWarpBase[game_version]+0x2C, deepJungleState and 0 or 0x2D)
    WriteByte(worldWarpBase[game_version]+0x9A, neverlandState and 6 or 0x7)
    WriteByte(worldWarpBase[game_version]+0x9C, neverlandState and 0x18 or 0x25)

    -- Change warp to Hollow Bastion
    if selection == 25 then 
        selection = 1
        WriteInt(selection_address[game_version], selection)
    end
    -- Change warp to Agrabah
    if selection == 21 then
        selection = 1
        WriteInt(selection_address[game_version], selection)
    end
    
    -- Go directly to location
    current_destination_address = {0x508280, 0x507580}
    local curDest = ReadInt(current_destination_address[game_version])
    if curDest < 40 then
        selection = selection > 20 and 0 or selection
        WriteInt(current_destination_address[game_version], selection)
        selection_address_other = {0x507C90, 0x506F90}
        WriteInt(selection_address_other[game_version], selection)
        other_address = {0x268A26C, 0x268986C} --changed for EGS 1.0.0.10 (may need to look again for Steam)
        WriteInt(other_address[game_version], 0)
    else
        selection_address_other = {0x507C90, 0x506F90}
        WriteInt(selection_address_other[game_version], realSelection)
    end
    
    ::done::
end