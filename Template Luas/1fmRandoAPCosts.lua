LUAGUI_NAME = "1fmRandoAPCosts"
LUAGUI_AUTH = "KSX and Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Randomize AP Costs"

require("globals")

canExecute = false
costsWritten = false

function write_ap_costs()
    treasureMagnetAddress = soraAbilityTable - 0x7F0
    for k,v in pairs(ability_costs) do
        WriteByte(treasureMagnetAddress + (12 * (k-1)), v)
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
        if not costsWritten then
            write_ap_costs()
            costsWritten = true
        end
    end
end