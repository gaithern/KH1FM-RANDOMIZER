local helpers = require("server.helpers")

local world = {0x2340E5C, 0x233FE84}
local room  = {0x2340E5C + 0x68, 0x233FE84 + 0x8}
local spawn = {0x2DEBDA8, 0x2DEB3A8}

local world_flags_address = {0x2DEAA6D, 0x2DEA06D}

function get_synth_shop_hints()
    return synth_hints
end

function synth_hints_update(synth_hints, updated_synth_hints, hint_location_id)
    if not contains_item(synth_hints, hint_location_id) then
        table.insert(synth_hints, hint_location_id)
    end
    return synth_hints
end

function update_synth_hints_table(synth_hints)
    synth_level_offset = 0xCC3
    synth_level = ReadByte(world_flags_address[game_version] + synth_level_offset)
    local i = 1
    while i <= 6 * (math.min(synth_level, 4) + 1) do
        synth_hints_update(synth_hints, 2656400 + i)
        i = i + 1
    end
    if synth_level == 5 then
        synth_hints_update(synth_hints, 2656431)
        synth_hints_update(synth_hints, 2656432)
        synth_hints_update(synth_hints, 2656433)
    end
end

function check_for_synth_shop_hints(synth_hints)
    if ReadByte(world[game_version]) == 0x03 and ReadByte(room[game_version]) == 0x0B and (ReadByte(spawn[game_version]) == 0x36 or ReadByte(spawn[game_version]) == 0x34) then
        update_synth_hints_table(synth_hints)
    end
end