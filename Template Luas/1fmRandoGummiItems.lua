LUAGUI_NAME = "1fmRandoGummiItems"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Gummi Items"

canExecute = false
gummi_item_count = 0
gummi_address = {0x2DF5BD8, 0x2DF51D8}
exclude_items = {0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C}

function contains(tbl, targetInt)
    for _, value in ipairs(tbl) do
        if value == targetInt then
            return true
        end
    end
    return false
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
        if ReadByte(gummi_address[game_version] + 0x7C) == 0 then
            i = 0
            while i < 160 do
                if i < gummi_item_count then
                    if ReadByte(gummi_address[game_version] + i) ~= 1 then
                        WriteByte(gummi_address[game_version] + i, 1)
                    end
                elseif not contains(exclude_items, i) then
                     WriteByte(gummi_address[game_version] + i, 0)
                end
                i = i + 1
            end
            WriteByte(gummi_address[game_version] + 0x7C, 1)
        end
    end
end