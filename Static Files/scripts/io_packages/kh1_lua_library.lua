-- ################################################################################################### --
-- #  ____  __.___ ___  ____  .____                   .____    ._____.                               # --
-- # |    |/ _/   |   \/_   | |    |    __ _______    |    |   |__\_ |______________ _______ ___.__. # --
-- # |      </    ~    \|   | |    |   |  |  \__  \   |    |   |  || __ \_  __ \__  \\_  __ <   |  | # --
-- # |    |  \    Y    /|   | |    |___|  |  // __ \_ |    |___|  || \_\ \  | \// __ \|  | \/\___  | # --
-- # |____|__ \___|_  / |___| |_______ \____/(____  / |_______ \__||___  /__|  (____  /__|   / ____| # --
-- #         \/     \/                \/          \/          \/       \/           \/       \/      # --
-- ################################################################################################### --

--[[
    This is a package that provides helpful functions for working in KH1 memory.
    Tries to use io_packages from 
    https://github.com/Denhonator/KHPCSpeedrunTools/tree/main/1FMMods/scripts/io_packages as much as 
    possible, but some additional memory addresses may need to added.
--]]

-- ########### --
-- # Helpers # --
-- ########### --
function byte_to_bits(byte)
    local bits = {}
    for i = 0, 7 do
        bits[i + 1] = (byte >> i) & 1  -- LSB first
    end
    return bits
end

function bits_to_byte(bits)
    assert(#bits == 8, "bits_to_byte expects exactly 8 bits")
    local byte = 0
    for i = 1, 8 do
        byte = byte | ((bits[i] & 1) << (i - 1)) -- LSB first
    end
    return byte
end

function ReadBits(address, absolute)
    if absolute == nil then absolute = false end
    return byte_to_bits(ReadByte(address, absolute))
end

function ReadBit(address, bit_num, absolute)
    if absolute == nil then absolute = false end
    return byte_to_bits(ReadByte(address, absolute))[bit_num]
end

function WriteBit(address, bit_num, value, absolute)
    if absolute == nil then absolute = false end
    local bits = ReadBits(address, absolute)
    bits[bit_num] = (value ~= 0) and 1 or 0
    WriteByte(address, bits_to_byte(bits), absolute)
end

function contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

function index(tbl, val)
    for k, v in ipairs(tbl) do
        if v == val then
            return k
        end
    end
    return nil
end

-- ########### --
-- # Getters # --
-- ########### --
function get_world()
    return ReadByte(world)
end

function get_room()
    return ReadByte(room)
end

function get_animation_speed()
    return ReadFloat(GetPointer(soraHUD - 0xA94) + 0x284, true)
end

function get_current_animation()
    return ReadByte(ReadLong(soraPointer)+0x164, true)
end

function get_ground_combo_length_limit()
    return ReadByte(soraHP + 0x98)
end

function get_air_combo_length_limit()
    return ReadByte(soraHP + 0x99)
end

function get_animation_time()
    return ReadFloat(ReadLong(soraPointer)+0x16C, true)
end

function get_stock()
    return ReadArray(inventory, 255)
end

function get_stock_at_index(index)
    return ReadByte(inventory + index - 1)
end

function get_sora_abilities()
    local abilities = {}
    local i = 0
    while ReadByte(soraCurAbilities + i) ~= 0 and i <= 48 do
        local ability_value_bits = byte_to_bits(ReadByte(soraCurAbilities + i))
        ability_value_bits[8] = 0
        local ability_value = bits_to_byte(ability_value_bits)
        abilities[#abilities + 1] = ability_value
        i = i + 1
    end
    return abilities
end

function get_shared_abilities()
    shared_abilities = {}
    local i = 0
    while ReadByte(sharedAbilities + i) ~= 0 and i <= 8 do
        local shared_ability_value_bits = byte_to_bits(ReadByte(sharedAbilities + i))
        shared_ability_value_bits[8] = 0
        local shared_ability_value = bits_to_byte(shared_ability_value_bits)
        shared_abilities[#shared_abilities + 1] = shared_ability_value
        i = i + 1
    end
    return shared_abilities
end

function get_equipped_sora_abilities()
    local abilities = {}
    local i = 0
    while ReadByte(soraCurAbilities + i) ~= 0 and i <= 48 do
        local ability_value_bits = byte_to_bits(ReadByte(soraCurAbilities + i))
        if ability_value_bits[8] == 0 then
            ability_value_bits[8] = 0
            local ability_value = bits_to_byte(ability_value_bits)
            abilities[#abilities + 1] = ability_value
        end
        i = i + 1
    end
    return abilities
end

function get_equipped_shared_abilities()
    local shared_abilities = {}
    local i = 0
    while ReadByte(sharedAbilities + i) ~= 0 and i <= 48 do
        local shared_ability_value_bits = byte_to_bits(ReadByte(sharedAbilities + i))
        if shared_ability_value_bits[8] ~= 0 then
            shared_ability_value_bits[8] = 0
            local shared_ability_value = bits_to_byte(shared_ability_value_bits)
            shared_abilities[#shared_abilities + 1] = shared_ability_value
        end
        i = i + 1
    end
    return shared_abilities
end

function get_soras_accessory_slots()
    return ReadByte(maxHP + 0x16)
end

function get_soras_equipped_accessories()
    return ReadArray(maxHP + 0x17, get_soras_accessory_slots())
end

function get_inputs()
    return ReadArray(inputAddress, 4)
end

function get_spell_effectiveness(spell)
    local memory_location = nil
        if spell == "Fire"     then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x00
    elseif spell == "Fira"     then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x01
    elseif spell == "Firaga"   then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x02
    elseif spell == "Blizzard" then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x03
    elseif spell == "Blizzara" then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x04
    elseif spell == "Blizzaga" then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x05
    elseif spell == "Thunder"  then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x06
    elseif spell == "Thundara" then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x07
    elseif spell == "Thundaga" then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x08
    elseif spell == "Cure"     then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x09
    elseif spell == "Cura"     then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x0A
    elseif spell == "Curaga"   then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x0B
    elseif spell == "Gravity"  then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x0C
    elseif spell == "Gravira"  then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x0D
    elseif spell == "Graviga"  then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x0E
    elseif spell == "Stop"     then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x0F
    elseif spell == "Stopra"   then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x10
    elseif spell == "Stopga"   then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x11
    elseif spell == "Aero"     then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x12
    elseif spell == "Aerora"   then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x13
    elseif spell == "Aeroga"   then memory_location = jumpHeights - 0xAC + 0x5F70 + 0x14 end
    if memory_location then
        return ReadByte(memory_location)
    else
        return 0
    end
end

function get_current_hits()
    return ReadByte(currentHits)
end

-- ########### --
-- # Setters # --
-- ########### --
function set_animation_speed(animation_speed)
    WriteFloat(GetPointer(soraHUD - 0xA94) + 0x284, animation_speed, true)
end

function set_ground_combo_length_limit(ground_combo_length_limit)
    WriteByte(soraHP + 0x98, ground_combo_length_limit)
end

function set_air_combo_length_limit(air_combo_length_limit)
    WriteByte(soraHP + 0x99, air_combo_length_limit)
end

function set_stock_at_index(index, qty)
    WriteByte(inventory + index - 1, qty)
end

function set_sora_walk_speed(walk_speed)
    WriteFloat(zantHack - 0x2862, walk_speed)
end

function set_sora_run_speed(run_speed)
    WriteFloat(zantHack - 0x285B, run_speed)
end

function set_spell_effectiveness(spell, value)
    local memory_location = nil
        if spell == "Fire"     then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x00 * 0x70)
    elseif spell == "Fira"     then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x01 * 0x70)
    elseif spell == "Firaga"   then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x02 * 0x70)
    elseif spell == "Blizzard" then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x03 * 0x70)
    elseif spell == "Blizzara" then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x04 * 0x70)
    elseif spell == "Blizzaga" then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x05 * 0x70)
    elseif spell == "Thunder"  then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x06 * 0x70)
    elseif spell == "Thundara" then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x07 * 0x70)
    elseif spell == "Thundaga" then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x08 * 0x70)
    elseif spell == "Cure"     then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x09 * 0x70)
    elseif spell == "Cura"     then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x0A * 0x70)
    elseif spell == "Curaga"   then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x0B * 0x70)
    elseif spell == "Gravity"  then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x0C * 0x70)
    elseif spell == "Gravira"  then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x0D * 0x70)
    elseif spell == "Graviga"  then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x0E * 0x70)
    elseif spell == "Stop"     then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x0F * 0x70)
    elseif spell == "Stopra"   then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x10 * 0x70)
    elseif spell == "Stopga"   then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x11 * 0x70)
    elseif spell == "Aero"     then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x12 * 0x70)
    elseif spell == "Aerora"   then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x13 * 0x70)
    elseif spell == "Aeroga"   then memory_location = jumpHeights - 0xAC + 0x5F70 + (0x14 * 0x70) end
    if memory_location then
        WriteByte(memory_location, value)
    end
end

function set_spell_cost(spell, value)
    local possible_magic_costs = {15,30,100,200,300}
    if possible_magic_costs[value] then
        local memory_location = nil
            if spell == "Fire"     then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x00 * 0x70)
        elseif spell == "Fira"     then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x01 * 0x70)
        elseif spell == "Firaga"   then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x02 * 0x70)
        elseif spell == "Blizzard" then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x03 * 0x70)
        elseif spell == "Blizzara" then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x04 * 0x70)
        elseif spell == "Blizzaga" then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x05 * 0x70)
        elseif spell == "Thunder"  then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x06 * 0x70)
        elseif spell == "Thundara" then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x07 * 0x70)
        elseif spell == "Thundaga" then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x08 * 0x70)
        elseif spell == "Cure"     then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x09 * 0x70)
        elseif spell == "Cura"     then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x0A * 0x70)
        elseif spell == "Curaga"   then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x0B * 0x70)
        elseif spell == "Gravity"  then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x0C * 0x70)
        elseif spell == "Gravira"  then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x0D * 0x70)
        elseif spell == "Graviga"  then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x0E * 0x70)
        elseif spell == "Stop"     then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x0F * 0x70)
        elseif spell == "Stopra"   then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x10 * 0x70)
        elseif spell == "Stopga"   then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x11 * 0x70)
        elseif spell == "Aero"     then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x12 * 0x70)
        elseif spell == "Aerora"   then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x13 * 0x70)
        elseif spell == "Aeroga"   then memory_location = jumpHeights - 0xAC + 0x5F58 + (0x14 * 0x70) end
        if memory_location then
            WriteByte(memory_location, possible_magic_costs[value])
        end
    end
end    

function set_attack_animation_data(index, animation_data)
    WriteArray(anims + (index * 20), animation_data)
end

function set_command_data(index, command_data)
    WriteArray(ReadLong(commandMenuPointer) + 16 * (index - 1), command_data, true)
end

-- ############ --
-- # Advanced # --
-- ############ --
function make_sora_actionable()
    -- Sets a flag on Sora's object that makes him actionable
    sora_flags = byte_to_bits(ReadByte(ReadLong(soraPointer), true))
    sora_flags[3] = 0
    WriteByte(ReadLong(soraPointer), bits_to_byte(sora_flags), true)
end

function calculate_ground_combo_limit()
    -- Calculates what Sora's ground combo limit should be, based on his abilities equipped
    local ground_combo_length = 3
    local equipped_abilities = get_equipped_sora_abilities()
    for k,v in pairs(equipped_abilities) do
        if v == 0x6 then
            ground_combo_length = ground_combo_length + 1
        end
    end
    return ground_combo_length
end

function calculate_air_combo_limit()
    -- Calculates what Sora's air combo limit should be, based on his abilities equipped
    local air_combo_length_limit = 3
    local equipped_abilities = get_equipped_sora_abilities()
    for k,v in pairs(equipped_abilities) do
        if v == 0x7 then
            air_combo_length_limit = air_combo_length_limit + 1
        end
    end
    return air_combo_length_limit
end

function enable_ability(ability)
    -- Enables an ability even if Sora doesn't have it or it isn't equipped
    local memory_location = nil
    
        if ability == "Vortex"          then memory_location = {soraHP + 0x1FC4,          1}
    elseif ability == "Aerial Sweep"    then memory_location = {soraHP + 0x1FC4,          2}
    elseif ability == "Counterattack"   then memory_location = {soraHP + 0x1FC4,          3}
    elseif ability == "Blitz"           then memory_location = {soraHP + 0x1FC4,          4}
    elseif ability == "Guard"           then memory_location = {soraHP + 0x1FC4,          5}
    elseif ability == "Dodge Roll"      then memory_location = {soraHP + 0x1FC4,          6}
    elseif ability == "Cheer"           then memory_location = {soraHP + 0x1FC5,          3}
    elseif ability == "Slapshot"        then memory_location = {soraHP + 0x1FC6,          8}
    elseif ability == "Sliding Dash"    then memory_location = {soraHP + 0x1FC7,          1}
    elseif ability == "Hurricane Blast" then memory_location = {soraHP + 0x1FC7,          2}
    elseif ability == "Ripple Drive"    then memory_location = {soraHP + 0x1FC7,          3}
    elseif ability == "Stun Impact"     then memory_location = {soraHP + 0x1FC7,          4}
    elseif ability == "Gravity Break"   then memory_location = {soraHP + 0x1FC7,          5}
    elseif ability == "Zantetsuken"     then memory_location = {soraHP + 0x1FC7,          6}
    elseif ability == "Sonic Blade"     then memory_location = {dialog + 0x738,           1}
    elseif ability == "Ars Arcanum"     then memory_location = {dialog + 0x738,           2}
    elseif ability == "Strike Raid"     then memory_location = {dialog + 0x738,           3}
    elseif ability == "Ragnarok"        then memory_location = {dialog + 0x738,           4}
    elseif ability == "Trinity Limit"   then memory_location = {dialog + 0x738,           5}
    elseif ability == "MP Haste"        then memory_location = {experienceMult - 0x94DC,  1}
    elseif ability == "MP Rage"         then memory_location = {experienceMult - 0x94DC,  2}
    elseif ability == "Second Chance"   then memory_location = {experienceMult - 0x94DC,  5}
    elseif ability == "Berserk"         then memory_location = {experienceMult - 0x94DC,  6}
    elseif ability == "Leaf Bracer"     then memory_location = {experienceMult - 0x94DC,  7} end
    
    if memory_location then
        WriteBit(memory_location[1], memory_location[2], 1)
    end
end    

function force_scan(on)
    if on then
        WriteArray(zantHack - 0x227C, {0x90,0x90,0x90,0x90,0x90,0x90})
    else
        WriteArray(zantHack - 0x227C, {0x0F,0x8E,0xD5,0x00,0x00,0x00})
    end
end

function force_combo_master(on)
    if on then
        WriteByte(zantHack + 0x6FB, 0x71)
        WriteByte(zantHack + 0x6FB + 0x18, 0x82)
    else
        WriteByte(zantHack + 0x6FB, 0x72)
        WriteByte(zantHack + 0x6FB + 0x18, 0x84)
    end
end

function allow_summon_anywhere(on)
    if on then
        WriteByte(summonanywhere1, 0x72)
        WriteByte(summonanywhere2, 0x72)
        WriteByte(summonanywhere3, 0x72)
    else
        WriteByte(summonanywhere1, 0x74)
        WriteByte(summonanywhere2, 0x74)
        WriteByte(summonanywhere3, 0x75)
    end
end

function allow_midair_dodge_roll_guard(on)
    if on then
        WriteByte(zantHack + 0xC08, 0x82)
    else
        WriteByte(zantHack + 0xC08, 0x85)
    end
end

function allow_air_items(on)
    if on then
        WriteByte(airitems1, 0x73)
        WriteByte(airitems2, 0x73)
    else
        WriteByte(airitems1, 0x75)
        WriteByte(airitems2, 0x74)
    end
end

function multiply_summon_time(mult)
    vanilla_value = 3000
    new_value = math.floor(vanilla_value * mult)
    WriteInt(summonTime, new_value)
end
