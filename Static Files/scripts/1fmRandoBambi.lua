LUAGUI_NAME = "1fmRandoBambi"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Handle Bambi Rewards"

local bambi_string = {0x65, 0x78, 0x5F, 0x34, 0x30, 0x33, 0x30, 0x2E, 0x62, 0x64}

function bambi_loaded()
    local byte_string = ReadArray(bambi, 10)
    for byte_num, byte_val in pairs(bambi_string) do
        if byte_val ~= byte_string[byte_num] then
            return false
        end
    end
    return true
end

function remove_drops()
    local i = 0
    while i <= 0x1D do
        working_address = bambi + 0xB0 + (0x34 * i)
        WriteInt(working_address + 0x1C, 0)
        WriteInt(working_address + 0x20, 0)
        WriteInt(working_address + 0x24, 0)
        WriteInt(working_address + 0x28, 0)
        WriteInt(working_address + 0x2C, 0)
        WriteInt(working_address + 0x30, 0)
        i = i + 1
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
        if bambi_loaded() then
            remove_drops()
        end
    end
end