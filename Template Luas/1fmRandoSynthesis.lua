-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------              by Gicu           -----
-------------------------------------------

LUAGUI_NAME = "1fmRandoSynthesis"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Synthesis"

canExecute = false
synth_items = {}
synth_written = false
synth_address = {0x5483A0, 0x5476C0}

function write_synth_items()
    synth_items_offset = 0x1E0
    for k,item_value in pairs(synth_items) do
        base_address = synth_address[game_version] + synth_items_offset + ((k-1)*10)
        WriteByte(base_address, item_value) --Item
        if k % 2 == 1 then
            WriteByte(base_address + 0x2, 0x0) --Requirements Offset
        else
            WriteByte(base_address + 0x2, 0x1) --Requirements Offset
        end
        WriteByte(base_address + 0x3, 0x1) --Number of Requirements
        WriteByte(base_address + 0x4, 0x1) --Unique Synth
    end
    i = #synth_items + 1
    while i <= 33 do
        base_address = synth_address[game_version] + synth_items_offset + ((i-1)*10)
        WriteByte(base_address, 0x0) --Item
        WriteByte(base_address + 0x2, 0x0) --Requirements Offset
        WriteByte(base_address + 0x3, 0x0) --Number of Requirements
        WriteByte(base_address + 0x4, 0x0) --Unique Synth
        i = i + 1
    end
end

function write_synth_requirements()
    WriteByte(synth_address[game_version], 0xFF)
    WriteByte(synth_address[game_version] + 4, 0xFE)
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
        if synth_items[1] ~= nil and not synth_written then
            write_synth_items()
            write_synth_requirements()
            synth_written = true
        end
    end
end