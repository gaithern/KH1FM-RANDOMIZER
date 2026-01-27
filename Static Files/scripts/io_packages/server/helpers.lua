local json = require("json")

function read_world()
    --[[Gets the numeric value of the currently occupied world]]
    world_address = {0x2340E5C, 0x233FE84}
    return ReadByte(world_address[game_version])
end

function check_for_world_update(world)
    game_state.world = read_world()
end

function contains_item(list, item)
    for _, value in ipairs(list) do 
        if value == item then
            return true
        end
    end
    return false
end

function read_first_7_bits(address)
    x = ReadByte(address)
    x = x %  128
    return x
end

function read_abilities()
    abilities_address = {0x2DE9DA4, 0x2DE93A4}
    abilities = {}
    i = 0
    while ReadByte(abilities_address[game_version] + i) ~= 0 and i <= 48 do
        abilities[#abilities + 1] = read_first_7_bits(abilities_address[game_version] + i)
        i = i + 1
    end
    return abilities
end

function read_stock()
    stock_address = {0x2DEA1FA, 0x2DE97FA}
    items = {}
    i = 0
    while i < 256 do
        items[#items + 1] = ReadByte(stock_address[game_version] + i)
        i = i + 1
    end
    return items
end

function read_shared_abilities()
    shared_abilities_address = {0x2DEA2F8, 0x2DE98F8}
    shared_abilities = {}
    i = 0
    while ReadByte(shared_abilities_address[game_version] + i) ~= 0 and i <= 8 do
        shared_abilities[#shared_abilities + 1] = read_first_7_bits(shared_abilities_address[game_version] + i)
        i = i + 1
    end
    return shared_abilities
end