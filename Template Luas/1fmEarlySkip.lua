LUAGUI_NAME = "1fmEarlySkip"
LUAGUI_AUTH = "denhonator/TopazTK (edited by deathofall84)"
LUAGUI_DESC = "Allows skipping cutscenes without waiting for them."

local lastFade = 0

function _OnInit()
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        require("VersionCheck")
        if canExecute then
            WriteInt(skipArray1 - 0x04, 0xFF)
            WriteArray(skipArray1, { 0x0F, 0x9E, 0xC0, 0xC3 })

            WriteInt(skipArray2 - 0x04, 0xFF)
            WriteArray(skipArray2, { 0x0F, 0x9E, 0xC0, 0xC3 })

            WriteArray(skipArray3, { 0xEB, 0x10 })
        end
    else
        ConsolePrint("KH1 not detected, not running script")
    end
end

function _OnFrame()
end

