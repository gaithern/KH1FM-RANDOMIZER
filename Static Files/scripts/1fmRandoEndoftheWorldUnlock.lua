LUAGUI_NAME = "1fmRandoEndoftheWorldUnlock"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Unlock End of the World with enough lucky emblems"

require("globals")

function unlock_eotw()
    if ReadByte(inventory + 238) >= eotw_lucky_emblems and ReadByte(inventory + 168) == 0 then
        WriteByte(inventory + 168, 1)
    end
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
        unlock_eotw()
    end
end