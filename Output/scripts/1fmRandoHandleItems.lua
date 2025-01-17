-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------              by Gicu           -----
-------------------------------------------

LUAGUI_NAME = "1fmRandoHandleItems"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Handle Special Cases with Key Items"

canExecute = false
stock_address = {0x2DEA1FA, 0x2DE97FA}

function handle_slides(stock)
    if stock[217] > 0 and stock[218] == 0 then
        WriteByte(stock_address[game_version] + 218, 1)
        WriteByte(stock_address[game_version] + 219, 1)
        WriteByte(stock_address[game_version] + 220, 1)
        WriteByte(stock_address[game_version] + 221, 1)
        WriteByte(stock_address[game_version] + 222, 1)
    end
end

function handle_magic(stock)
    magic_unlocked_address = {0x2DE9DD4, 0x2DE93D4}
    donald_magic_unlocked_bits_offset = 0x74
    magic_levels_offset = 0x41E
    magic_levels_array = {}
    magic_levels_array[1] = stock[175]
    magic_levels_array[2] = stock[176]
    magic_levels_array[3] = stock[177]
    magic_levels_array[4] = stock[178]
    magic_levels_array[5] = stock[179]
    magic_levels_array[6] = stock[180]
    magic_levels_array[7] = stock[181]
    magic_unlocked_bits = {0,0,0,0,0,0,0}
    for k,v in pairs(magic_levels_array) do
        if v > 0 then
            magic_unlocked_bits[k] = 1
        end
        if v == 0 then
            magic_levels_array[k] = 1
        end
    end
    WriteByte(magic_unlocked_address[game_version],
        (1 * magic_unlocked_bits[1]) + (2 * magic_unlocked_bits[2]) + (4 * magic_unlocked_bits[3]) + (8 * magic_unlocked_bits[4])
        + (16 * magic_unlocked_bits[5]) + (32 * magic_unlocked_bits[6]) + (64 * magic_unlocked_bits[7]))
    WriteByte(magic_unlocked_address[game_version] + donald_magic_unlocked_bits_offset,
        (1 * magic_unlocked_bits[1]) + (2 * magic_unlocked_bits[2]) + (4 * magic_unlocked_bits[3]) + (8 * magic_unlocked_bits[4])
        + (16 * magic_unlocked_bits[5]) + (32 * magic_unlocked_bits[6]) + (64 * magic_unlocked_bits[7]))
    WriteArray(magic_unlocked_address[game_version] + magic_levels_offset, magic_levels_array)
end

function handle_worlds(stock)
    --[[Writes unlocked worlds.  Array of 11 values, one for each world
    TT, WL, OC, DJ, AG, AT, HT, NL, HB, EW, MS
    00 is invisible
    01 is visible/unvisited
    02 is selectable/unvisited
    03 is incomplete
    04 is complete]]
    worlds_unlocked_items = {}
    worlds_unlocked_items[1] = 1
    worlds_unlocked_items[2] = stock[149]
    worlds_unlocked_items[3] = stock[150]
    worlds_unlocked_items[4] = stock[151]
    worlds_unlocked_items[5] = stock[155]
    worlds_unlocked_items[6] = stock[166]
    worlds_unlocked_items[7] = stock[157]
    worlds_unlocked_items[8] = stock[165]
    worlds_unlocked_items[9] = stock[168]
    worlds_unlocked_items[10] = stock[169]
    monstro_unlocked_item = stock[156]
    unlocked_worlds_array = {3,0,0,0,0,0,0,0,0,0}
    monstro_unlocked = 0
    if monstro_unlocked_item > 0 then
        monstro_unlocked = 3
    end
    for k,v in pairs(worlds_unlocked_items) do
        if v > 0 then
            unlocked_worlds_array[k] = 3
        end
    end
    world_status_address = {0x2DEBC50, 0x2DEB250}
    monstro_status_addresss = world_status_address[game_version] + 0xA
    WriteArray(world_status_address[game_version], unlocked_worlds_array)
    WriteByte(monstro_status_addresss, monstro_unlocked)
end

function handle_trinities(stock)
    --[[Writes the players unlocked trinities]]
    trinities_unlocked_address = {0x2DEB97B, 0x2DEAF7B}
    trinity_items = {}
    trinity_items[1] = stock[170]
    trinity_items[2] = stock[171]
    trinity_items[3] = stock[172]
    trinity_items[4] = stock[173]
    trinity_items[5] = stock[174]
    trinity_bits = {0,0,0,0,0}
    for k,v in pairs(trinity_items) do
        if v > 0 then
            trinity_bits[k] = 1
        end
    end
    WriteByte(trinities_unlocked_address[game_version], (1 * trinity_bits[1]) + (2 * trinity_bits[2]) + (4 * trinity_bits[3]) + (8 * trinity_bits[4]) + (16 * trinity_bits[5]))
end

function handle_summons(stock)
    --[[Writes the player's unlocked summons]]
    summons_array = {0xFF,0xFF,0xFF,0xFF,0xFF,0xFF}
    summons_items = {}
    summons_items[1] = stock[231]
    summons_items[2] = stock[233]
    summons_items[3] = stock[234]
    summons_items[4] = stock[235]
    summons_items[5] = stock[236]
    summons_items[6] = stock[237]
    summon_index = 1
    for k,v in pairs(summons_items) do
        if v > 0 then
            summons_array[summon_index] = k-1
            summon_index = summon_index + 1
        end
    end
    summons_address = {0x2DEA530, 0x2DE9B30}
    WriteArray(summons_address[game_version], summons_array)
end

function handle_puppies(stock)
    puppy_array_address = {0x2DEB463, 0x2DEAA63}
    puppies_item = stock[167] * 3
    puppies_array = {0x0}
    i = 0
    j = 1
    k = 7
    while i < puppies_item do
        if puppies_array[j] == nil then
            puppies_array[j] = 0x0
        end
        puppies_array[j] = puppies_array[j] + 2^k
        if k == 0 then
            k = 7
        else
            k = k - 1
        end
        if puppies_array[j] == 255 then
            j = j + 1
        end
        i = i + 1
    end
    WriteArray(puppy_array_address[game_version], puppies_array)
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
        stock = ReadArray(stock_address[game_version], 255)
        handle_slides(stock)
        handle_magic(stock)
        handle_worlds(stock)
        handle_trinities(stock)
        handle_summons(stock)
        handle_puppies(stock)
    end
end