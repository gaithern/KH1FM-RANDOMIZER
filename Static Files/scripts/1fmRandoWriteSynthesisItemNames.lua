LUAGUI_NAME = "1fmRandoWriteSynthesisItemNames"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Write Synthesis Item Names"

require("globals")

canExecute = false

function write_synth_item_name()
    synth_item_selected_index = ReadByte(synthItemSelected)
    for k,v in pairs(synth_item_bytes[synth_item_selected_index+1]) do
        WriteByte(language + 0x2593 + k - 1, v)
    end
    WriteByte(language + 0x2593 + #synth_item_bytes[synth_item_selected_index+1], 0)
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
        if ReadByte(world) == 0x03 and ReadByte(room) == 0x0B and (ReadByte(unlockedWarps + 0x149) == 0x36 or ReadByte(unlockedWarps + 0x149) == 0x34) then
            write_synth_item_name()
        end
    end
end