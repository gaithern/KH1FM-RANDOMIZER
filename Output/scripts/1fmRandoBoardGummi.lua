LUAGUI_NAME = "1fmAPBoardGummi"
LUAGUI_AUTH = "denhonator with slight edits from Gicu"
LUAGUI_DESC = "Read readme for button combinations.  Modified for AP by Gicu"

game_version = 1 --1 for EGS 1.0.0.10, 2 for Steam 1.0.0.10

local addgummi = 0

local canExecute = false
local lastsavemenuopen = 0

function _OnInit()
    IsEpicGLVersion  = 0x3A2B86
    IsSteamGLVersion = 0x3A29A6
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        if ReadByte(IsEpicGLVersion) == 0xF0 then
            ConsolePrint("Epic Version Detected")
            game_version = 1
        end
        if ReadByte(IsSteamGLVersion) == 0xF0 then
            ConsolePrint("Steam Version Detected")
            game_version = 2
        end
        canExecute = true
    end
end

function _OnFrame()
    if not canExecute then
        goto done
    end
    save_menu_open_address = {0x232E984, 0x232DFA4}
    local savemenuopen = ReadByte(save_menu_open_address[game_version])
    
    if savemenuopen == 4 and lastsavemenuopen ~= 4 then
        addgummi = 5
    end
    if savemenuopen == 4 and addgummi==1 then
        unlock_gummi_address        = {0x2E20FA8, 0x2E204F8}
        save_menu_buttons_1_address = {0x2E20F1C, 0x2E2055C}
        save_menu_buttons_2_address = {0x2E937D0, 0x2E92DF0}
        save_menu_buttons_3_address = {0x2E937D2, 0x2E92DF2}
        button_types_address        = {0x2E20F20, 0x2E20548}
        WriteByte(unlock_gummi_address[game_version], 3) --Unlock gummi
        WriteByte(save_menu_buttons_1_address[game_version], 5) --Set 5 buttons to save menu
        WriteByte(save_menu_buttons_2_address[game_version], 5) --Set 5 buttons to save menu
        WriteByte(save_menu_buttons_3_address[game_version], 5) --Set 5 buttons to save menu
        for i=0,4 do
            WriteByte(button_types_address[game_version]+i*4, i) --Set button types
        end
    end
    
    addgummi = addgummi > 0 and addgummi-1 or addgummi
    
    lastsavemenuopen = savemenuopen
    ::done::
end