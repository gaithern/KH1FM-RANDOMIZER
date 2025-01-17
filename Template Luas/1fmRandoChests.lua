-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------              by Gicu           -----
-------------------------------------------

LUAGUI_NAME = "1fmRandoChests"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Chests"

canExecute = false
chests = {}
chests_written = false

function randomize_chests()
    chest_table_address = {0x529A60, 0x528D60}
    for offset,chest_short in pairs(chests) do
        WriteShort(chest_table_address[game_version] + offset, chest_short)
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
        if chests[0] ~= nil and not chests_written then
            randomize_chests()
        end
    end
end