LUAGUI_NAME = "1fmRandoMapPrizes"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Map Prizes"

require("globals")

canExecute = false

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