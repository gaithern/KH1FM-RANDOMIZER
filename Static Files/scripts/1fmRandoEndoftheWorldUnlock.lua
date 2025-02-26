LUAGUI_NAME = "1fmRandoEndoftheWorldUnlock"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Unlock End of the World with enough lucky emblems"

canExecute = false
stock_address = {0x2DEA1F9, 0x2DE97F9}

function unlock_eotw()
    if ReadByte(stock_address[game_version] + 239) >= 7 and ReadByte(stock_address[game_version] + 169) == 0 then
        WriteByte(stock_address[game_version] + 169, 1)
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
        unlock_eotw()
    end
end