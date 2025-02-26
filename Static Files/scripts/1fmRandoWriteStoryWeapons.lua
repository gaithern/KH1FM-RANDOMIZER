LUAGUI_NAME = "1fmRandoStoryWeapons"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Give Story Weapons"

canExecute = false

function write_item(item_offset)
    stock_address = {0x2DEA1F9, 0x2DE97F9}
    WriteByte(stock_address[game_version] + item_offset, math.min(ReadByte(stock_address[game_version] + item_offset) + 1, 99))
end

function read_item(item_offset)
    stock_address = {0x2DEA1F9, 0x2DE97F9}
    return ReadByte(stock_address[game_version] + item_offset)
end

function write_story_weapons()
    world_progress_array_address = {0x2DEB264, 0x2DEA864}
    if read_item(81) == 0 then
        write_item(81)
    end
    if read_item(82) == 0 then
        write_item(82)
    end
    if read_item(83) == 0 then
        write_item(83)
    end
    if read_item(84) == 0 then
        write_item(84)
    end
    if read_item(85) == 0 and ReadByte(world_progress_array_address[game_version] + 0xA) >= 0x1E then
        write_item(85)
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
        write_story_weapons()
    end
end