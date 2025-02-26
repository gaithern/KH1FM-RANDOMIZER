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
    [2656612] = {0xE6E, 5, replace_2656612}, --Monstro Throat Blue Trinity
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
        restart_map_prizes()
    end
end