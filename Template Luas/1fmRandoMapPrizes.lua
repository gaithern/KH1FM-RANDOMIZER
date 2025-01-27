-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------              by Gicu           -----
-------------------------------------------

LUAGUI_NAME = "1fmRandoMapPrizes"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Map Prizes"

canExecute = false
map_prize_array = {
    [2656600] = {0xE64, 7, replace_2656600}, --Traverse Town 1st District Blue Trinity by Exit Door
    [2656601] = {0xEAB, 4, replace_2656601}, --Traverse Town 3rd District Blue Trinity
    [2656602] = {0xEA9, 1, replace_2656602}, --Traverse Town Magician's Study Blue Trinity
    [2656603] = {0xE66, 7, replace_2656603}, --Wonderland Lotus Forest Blue Trinity in Alcove
    [2656604] = {0xE66, 6, replace_2656604}, --Wonderland Lotus Forest Blue Trinity by Moving Boulder
    [2656605] = {0xE6C, 7, replace_2656605}, --Agrabah Bazaar Blue Trinity
    [2656606] = {0xE6E, 6, replace_2656606}, --Monstro Mouth Blue Trinity
    [2656607] = {0xE6E, 4, replace_2656607}, --Monstro Chamber 5 Blue Trinity
    [2656608] = {0xE73, 7, replace_2656608}, --Hollow Bastion Great Crest Blue Trinity
    [2656609] = {0xE73, 6, replace_2656609}, --Hollow Bastion Dungeon Blue Trinity
    [2656610] = {0xE6A, 4, replace_2656610}, --Deep Jungle Treetop Green Trinity
    [2656611] = {0xE6C, 4, replace_2656611}, --Agrabah Treasure Room Red Trinity
}

function restart_map_prizes()
    EventFlags = {0x2DEAB68, 0x2DEA168}
    for offset,chest_short in pairs(chests) do
        WriteShort(chest_table_address[game_version] + offset, chest_short)
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
        if chests[0] ~= nil then
            randomize_chests()
        end
    end
end