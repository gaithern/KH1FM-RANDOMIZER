LUAGUI_NAME = "1fmRandoMapPrizes"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Map Prizes"

canExecute = false
map_prize_array = {
    [2656600] = {0x0E64, 7, replace_2656600}, --Traverse Town 1st District Blue Trinity by Exit Door
    [2656601] = {0x0EAB, 4, replace_2656601}, --Traverse Town 3rd District Blue Trinity
    [2656602] = {0x0EA9, 1, replace_2656602}, --Traverse Town Magician's Study Blue Trinity
    [2656603] = {0x0E66, 7, replace_2656603}, --Wonderland Lotus Forest Blue Trinity in Alcove
    [2656604] = {0x0E66, 6, replace_2656604}, --Wonderland Lotus Forest Blue Trinity by Moving Boulder
    [2656605] = {0x0E6C, 7, replace_2656605}, --Agrabah Bazaar Blue Trinity
    [2656606] = {0x0E6E, 6, replace_2656606}, --Monstro Mouth Blue Trinity
    [2656607] = {0x0E6E, 4, replace_2656607}, --Monstro Chamber 5 Blue Trinity
    [2656608] = {0x0E73, 7, replace_2656608}, --Hollow Bastion Great Crest Blue Trinity
    [2656609] = {0x0E73, 6, replace_2656609}, --Hollow Bastion Dungeon Blue Trinity
    [2656610] = {0x0E6A, 4, replace_2656610}, --Deep Jungle Treetop Green Trinity
    [2656611] = {0x0E6C, 4, replace_2656611}, --Agrabah Treasure Room Red Trinity
    [2656612] = {0x0E6E, 5, replace_2656612}, --Monstro Throat Blue Trinity
    [2656613] = {0x0EDA, 8, replace_2656613}, --Wonderland Bizarre Room Examine Flower Pot
    [2656614] = {0x0EE0, 5, replace_2656614}, --Wonderland Lotus Forest Red Flowers on the Main Path (Also accessible with bit 2 for the other flower)
    [2656615] = {0x0EE0, 8, replace_2656615}, --Wonderland Lotus Forest Yellow Flowers in Middle Clearing and Through Painting (Also accessible with bit 6 for the other flower)
    [2656616] = {0x0EE0, 7, replace_2656616}, --Wonderland Lotus Forest Yellow Elixir Flower Through Painting
    [2656617] = {0x0EE0, 3, replace_2656617}, --Wonderland Lotus Forest Red Flower Raise Lily Pads
    [2656618] = {0x0EE9, 7, replace_2656618}, --Wonderland Tea Party Garden Left Cushioned Chair
    [2656619] = {0x0EE9, 6, replace_2656619}, --Wonderland Tea Party Garden Left Pink Chair
    [2656620] = {0x0EE9, 2, replace_2656620}, --Wonderland Tea Party Garden Right Yellow Chair
    [2656621] = {0x0EE9, 5, replace_2656621}, --Wonderland Tea Party Garden Left Gray Chair
    [2656622] = {0x0EE9, 4, replace_2656622}, --Wonderland Tea Party Garden Right Brown Chair
    [2656623] = {0x108D, 7, replace_2656623}  --Hollow Bastion Lift Stop from Dungeon Examine Node
}

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return t
end

function bitstonum(bits)
    val = 0
    for k,v in pairs(bits) do
        if v > 0 then
            val = val + 2^(k-1)
        end
    end
    return val
end

function restart_map_prizes()
    event_flags = {0x2DEAB68, 0x2DEA168}
    stock_address = {0x2DEA1FA, 0x2DE97FA}
    stock = ReadArray(stock_address[game_version], 255)
    for ap_location_id,map_prize_data in pairs(map_prize_array) do
        if map_prize_data[3] ~= 0 then
            offset = map_prize_data[1]
            bit_num = map_prize_data[2]
            item_index = map_prize_data[3]
            bits = toBits(ReadByte(event_flags[game_version] + offset))
            i = 1
            while i <= 8 do
                if bits[i] == nil then
                    bits[i] = 0
                end
                i = i + 1
            end
            if stock[item_index] == 0 and bits[bit_num] == 1 then
                bits[bit_num] = 0
                WriteByte(event_flags[game_version] + offset, bitstonum(bits))
            end
            if stock[item_index] > 0 and bits[bit_num] == 0 then
                bits[bit_num] = 1
                WriteByte(event_flags[game_version] + offset, bitstonum(bits))
            end
        end
    end
end

function consolidate_lotus_forest_flowers()
    event_flags = {0x2DEAB68, 0x2DEA168}
    lotus_forest_flower_bits = toBits(ReadByte(event_flags[game_version] + map_prize_array[2656614][1]))
    i = 1
    while i <= 8 do
        if lotus_forest_flower_bits[i] == nil then
            lotus_forest_flower_bits[i] = 0
        end
        i = i + 1
    end
    if lotus_forest_flower_bits[2] == 1 or lotus_forest_flower_bits[5] == 1 then
        lotus_forest_flower_bits[2] = 1
        lotus_forest_flower_bits[5] = 1
    end
    if lotus_forest_flower_bits[6] == 1 or lotus_forest_flower_bits[8] == 1 then
        lotus_forest_flower_bits[6] = 1
        lotus_forest_flower_bits[8] = 1
    end
    WriteByte(event_flags[game_version] + map_prize_array[2656614][1], bitstonum(lotus_forest_flower_bits))
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
        consolidate_lotus_forest_flowers()
        --restart_map_prizes()
    end
end