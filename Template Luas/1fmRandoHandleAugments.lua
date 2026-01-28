LUAGUI_NAME = "1fmRandoHandleAugments"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Handle Accessory Augments"

canExecute = false

aug_scan_acc = 256
aug_sonic_blade_acc = 256
aug_ars_arcanum_acc = 256
aug_strike_raid_acc = 256
aug_ragnarok_acc = 256
aug_trinity_limit_acc = 256
aug_cheer_acc = 256
aug_vortex_acc = 256
aug_aerial_sweep_acc = 256
aug_counterattack_acc = 256
aug_blitz_acc = 256
aug_guard_acc = 256
aug_dodge_roll_acc = 256
aug_mp_haste_acc = 256
aug_mp_rage_acc = 256
aug_second_chance_acc = 256
aug_berserk_acc = 256
aug_slapshot_acc = 256
aug_sliding_dash_acc = 256
aug_hurricane_blast_acc = 256
aug_ripple_drive_acc = 256
aug_stun_impact_acc = 256
aug_gravity_break_acc = 256
aug_zantetsuken_acc = 256
aug_leaf_bracer_acc = 256
aug_combo_master_acc = 256
aug_finisher_lock_acc = 256
aug_air_finisher_lock_acc = 256
aug_haste_acc = 256
aug_hastera_acc = 256
aug_hastega_acc = 256
aug_slow_acc = 256
aug_slowra_acc = 256
aug_slowga_acc = 256
aug_air_guard_dodge_roll_acc = 256
aug_air_items_acc = 256
aug_fire_cost_up_acc = 256
aug_blizzard_cost_up_acc = 256
aug_thunder_cost_up_acc = 256
aug_cure_cost_up_acc = 256
aug_gravity_cost_up_acc = 256
aug_stop_cost_up_acc = 256
aug_aero_cost_up_acc = 256
aug_fire_cost_down_acc = 256
aug_blizzard_cost_down_acc = 256
aug_thunder_cost_down_acc = 256
aug_cure_cost_down_acc = 256
aug_gravity_cost_down_acc = 256
aug_stop_cost_down_acc = 256
aug_aero_cost_down_acc = 256
aug_fire_boost_acc = 256
aug_blizzard_boost_acc = 256
aug_thunder_boost_acc = 256
aug_cure_boost_acc = 256
aug_gravity_boost_acc = 256
aug_stop_boost_acc = 256
aug_aero_boost_acc = 256
aug_fire_down_acc = 256
aug_blizzard_down_acc = 256
aug_thunder_down_acc = 256
aug_cure_down_acc = 256
aug_gravity_down_acc = 256
aug_stop_down_acc = 256
aug_aero_down_acc = 256
aug_summon_anywhere_acc = 256
aug_summon_boost_acc = 256

function contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

function tobits(n)
    local bits = {}
    for i = 1, 8 do
        bits[i] = (n >> (i - 1)) & 1
    end
    return bits
end

function frombits(bits)
    local n = 0
    for i = 1, 8 do
        n = n | (bits[i] << (i - 1))
    end
    return n
end

function ReadBit(memory_address, bit_number)
    bits = tobits(ReadByte(memory_address))
    return bits[bit_number]
end

function WriteBit(memory_address, value, bit_number)
    bits = tobits(ReadByte(memory_address))
    bits[bit_number] = value
    WriteByte(memory_address, frombits(bits))
end

function handle_context_abilities(acc_equipped)
    context_abilities_acc_to_bits_0 = {
        [1] = aug_vortex_acc,
        [2] = aug_aerial_sweep_acc,
        [3] = aug_counterattack_acc,
        [4] = aug_blitz_acc,
        [5] = aug_guard_acc,
        [6] = aug_dodge_roll_acc
    }
    context_abilities_acc_to_bits_1 = {
        [3] = aug_cheer_acc
    }
    context_abilities_acc_to_bits_2 = {
        [8] = aug_slapshot_acc
    }
    context_abilities_acc_to_bits_3 = {
        [1] = aug_sliding_dash_acc,
        [2] = aug_hurricane_blast_acc,
        [3] = aug_ripple_drive_acc,
        [4] = aug_stun_impact_acc,
        [5] = aug_gravity_break_acc,
        [6] = aug_zantetsuken_acc
    }

    context_abilities_acc_to_bits = {context_abilities_acc_to_bits_0, context_abilities_acc_to_bits_1, context_abilities_acc_to_bits_2, context_abilities_acc_to_bits_3}
    for context_abilities_byte, context_abilities_bits in pairs(context_abilities_acc_to_bits) do
        for bit_num, acc in pairs(context_abilities_bits) do
            if contains(acc_equipped, acc) then
                WriteBit(soraHP + 0x1FC4 + (context_abilities_byte - 1), 1, bit_num)
            end
        end
    end
end

function handle_limit_abilities(acc_equipped)
    limit_abilities_acc_to_bits = {
        [1] = aug_sonic_blade_acc,
        [2] = aug_ars_arcanum_acc,
        [3] = aug_strike_raid_acc,
        [4] = aug_ragnarok_acc,
        [5] = aug_trinity_limit_acc
    }
    
    for bit_num, acc in pairs(limit_abilities_acc_to_bits) do
        if contains(acc_equipped, acc) then
            WriteBit(dialog + 0x738, 1, bit_num)
        end
    end
end

function handle_passive_abilities(acc_equipped)
    passive_abilities_acc_to_bits = {
        [1] = aug_mp_haste_acc,
        [2] = aug_mp_rage_acc,
        [5] = aug_second_chance_acc,
        [6] = aug_berserk_acc,
        [7] = aug_leaf_bracer_acc
    }
    
    for bit_num, acc in pairs(passive_abilities_acc_to_bits) do
        if contains(acc_equipped, acc) then
            WriteBit(experienceMult - 0x94DC, 1, bit_num)
        end
    end
end

function handle_combo_length(acc_equipped)
    if contains(acc_equipped, aug_finisher_lock_acc) then
        WriteByte(soraHP + 0x98, 1)
    end
    if contains(acc_equipped, aug_air_finisher_lock_acc) then
        WriteByte(soraHP + 0x99, 1)
    end
end

function handle_walk_and_animation_speed(acc_equipped)
    haste_acc = {
        [1] = aug_haste_acc,
        [2] = aug_hastera_acc,
        [3] = aug_hastega_acc
    }
    slow_acc = {
        [1] = aug_slow_acc,
        [2] = aug_slowra_acc,
        [3] = aug_slowga_acc
    }
    
    haste_mod = 1.0
    
    if contains(acc_equipped, haste_acc[3]) then
        haste_mod = haste_mod + 0.3
    elseif contains(acc_equipped, haste_acc[2]) then
        haste_mod = haste_mod + 0.2
    elseif contains(acc_equipped, haste_acc[1]) then
        haste_mod = haste_mod + 0.1
    end
    if contains(acc_equipped, slow_acc[3]) then
        haste_mod = haste_mod - 0.3
    elseif contains(acc_equipped, slow_acc[2]) then
        haste_mod = haste_mod - 0.2
    elseif contains(acc_equipped, slow_acc[1]) then
        haste_mod = haste_mod - 0.1
    end
    
    run_speed = 8.0 * haste_mod
    walk_speed = 2.0 * haste_mod
    WriteFloat(zantHack - 0x285B, run_speed)
    WriteFloat(zantHack - 0x2862, walk_speed)
    WriteFloat(GetPointer(soraHUD - 0xA94) + 0x284, haste_mod, true)
end

function handle_scan(acc_equipped)
    if contains(acc_equipped, aug_scan_acc) then
        WriteArray(zantHack - 0x227C, {0x90,0x90,0x90,0x90,0x90,0x90})
    else
        WriteArray(zantHack - 0x227C, {0x0F,0x8E,0xD5,0x00,0x00,0x00})
    end
end

function handle_combo_master(acc_equipped)
    if contains(acc_equipped, aug_combo_master_acc) then
        WriteByte(zantHack + 0x6FB, 0x71)
        WriteByte(zantHack + 0x6FB + 0x18, 0x82)
    else
        WriteByte(zantHack + 0x6FB, 0x72)
        WriteByte(zantHack + 0x6FB + 0x18, 0x84)
    end
end

function handle_summon_anywhere(acc_equipped)
    if contains(acc_equipped, aug_summon_anywhere_acc) then
        WriteByte(summonanywhere1, 0x72)
        WriteByte(summonanywhere2, 0x72)
        WriteByte(summonanywhere3, 0x72)
    else
        WriteByte(summonanywhere1, 0x74)
        WriteByte(summonanywhere2, 0x74)
        WriteByte(summonanywhere3, 0x75)
    end
end

function handle_midair_dodge_roll_guard(acc_equipped)
    if contains(acc_equipped, aug_air_guard_dodge_roll_acc) then
        WriteByte(zantHack + 0xC08, 0x82)
    else
        WriteByte(zantHack + 0xC08, 0x85)
    end
end

function handle_midair_items(acc_equipped)
    if contains(acc_equipped, aug_air_items_acc) then
        WriteByte(airitems1, 0x73)
        WriteByte(airitems2, 0x73)
    else
        WriteByte(airitems1, 0x75)
        WriteByte(airitems2, 0x74)
    end
end

function handle_magic_boosts(acc_equipped)
    magic_boosts_acc = {
        [1] = aug_fire_boost_acc,
        [2] = aug_blizzard_boost_acc,
        [3] = aug_thunder_boost_acc,
        [4] = aug_cure_boost_acc,
        [5] = aug_gravity_boost_acc,
        [6] = aug_stop_boost_acc,
        [7] = aug_aero_boost_acc
    }
    magic_downs_acc = {
        [1] = aug_fire_down_acc,
        [2] = aug_blizzard_down_acc,
        [3] = aug_thunder_down_acc,
        [4] = aug_cure_down_acc,
        [5] = aug_gravity_down_acc,
        [6] = aug_stop_down_acc,
        [7] = aug_aero_down_acc
    }
    effectiveness_values = {20,28,36,22,27,34,16,20,26,15,27,36,40,55,70,2,2,2,18,18,18}
    mag_mods = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0}
    for spell_type, acc in pairs(magic_boosts_acc) do
        if contains(acc_equipped, acc) then
            mag_mods[(spell_type)] = mag_mods[(spell_type)] + 0.3
        end
    end
    for spell_type, acc in pairs(magic_downs_acc) do
        if contains(acc_equipped, acc) then
            mag_mods[(spell_type)] = mag_mods[(spell_type)] - 0.3
        end
    end
    effectiveness_address = btltbl + 0x5F70
    for spell_index, effectiveness_value in pairs(effectiveness_values) do
        WriteByte(effectiveness_address + ((1-spell_index) * 0x70), math.ceil(effectiveness_value * mag_mods[math.ceil(spell_index/3)]))
    end
end

function handle_magic_costs(acc_equipped)
    magic_costs_up_acc = {
        [1] = aug_fire_cost_up_acc,
        [2] = aug_blizzard_cost_up_acc,
        [3] = aug_thunder_cost_up_acc,
        [4] = aug_cure_cost_up_acc,
        [5] = aug_gravity_cost_up_acc,
        [6] = aug_stop_cost_up_acc,
        [7] = aug_aero_cost_up_acc
    }
    magic_costs_down_acc = {
        [1] = aug_fire_cost_down_acc,
        [2] = aug_blizzard_cost_down_acc,
        [3] = aug_thunder_cost_down_acc,
        [4] = aug_cure_cost_down_acc,
        [5] = aug_gravity_cost_down_acc,
        [6] = aug_stop_cost_down_acc,
        [7] = aug_aero_cost_down_acc
    }
    magic_costs = {2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4}
    possible_magic_costs = {15,30,100,200,300}
    for spell_type, acc in pairs(magic_costs_up_acc) do
        if contains(acc_equipped, acc) then
            magic_costs[((spell_type-1)*3)+1] = math.min(magic_costs[((spell_type-1)*3)+1] + 1, 4)
            magic_costs[((spell_type-1)*3)+2] = math.min(magic_costs[((spell_type-1)*3)+2] + 1, 4)
            magic_costs[((spell_type-1)*3)+3] = math.min(magic_costs[((spell_type-1)*3)+3] + 1, 4)
        end
    end
    for spell_type, acc in pairs(magic_costs_down_acc) do
        if contains(acc_equipped, acc) then
            magic_costs[((spell_type-1)*3)+1] = math.max(magic_costs[((spell_type-1)*3)+1] - 1, 1)
            magic_costs[((spell_type-1)*3)+2] = math.max(magic_costs[((spell_type-1)*3)+2] - 1, 1)
            magic_costs[((spell_type-1)*3)+3] = math.max(magic_costs[((spell_type-1)*3)+3] - 1, 1)
        end
    end
    for spell_index, spell_cost_index in pairs(magic_costs) do
        WriteByte(btltbl + 0x5F58 + (0x70 * (spell_index - 1)), possible_magic_costs[spell_cost_index])
    end
end

function handle_summon_time_up(acc_equipped):
    if contains(acc_equipped, aug_summon_boost_acc) then
        WriteInt(summonanywhere1 + 0x317, 4000)
    else
        WriteInt(summonanywhere1 + 0x317, 3000)
    end
end

function handle_grounded()
    --ground_animations = {0xC8, 0xC9, 0xCA, 0xCB, 0xCF, 0xD0, 0xD2, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA}
    ground_animations = {0xCB, 0xD0, 0xD2, 0xD3, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA}
    ground_bonuses    = {0.4,  0.75, 0.4,  0.75, 0.4,  0.5 , 0.5,  0.5,  0.4}
    air_animations = {0xCC, 0xCD, 0xCE, 0xD1}
    currSpeed = ReadFloat(GetPointer(soraHUD - 0xA94) + 0x284, true)
    currAnim = ReadByte(ReadLong(soraPointer)+0x164, true)
    i = index(ground_animations, currAnim)
    if i ~= nil then
        WriteFloat(GetPointer(soraHUD - 0xA94) + 0x284, currSpeed + ground_bonuses[i], true)
    elseif contains(air_animations, currAnim) then
        WriteFloat(GetPointer(soraHUD - 0xA94) + 0x284, currSpeed - 0.25, true)
    else
        WriteFloat(GetPointer(soraHUD - 0xA94) + 0x284, currSpeed, true)
    end
end

function handle_finishing_plus()
    ground_finishers = {0xCB, 0xD0, 0xD2, 0xD3, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA}
    ground_animations = {0xC8, 0xC9, 0xCA, 0xCB, 0xCF, 0xD0, 0xD2, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA}
    current_hits = ReadByte(0x296B221)
    animation_time = ReadFloat(ReadLong(soraPointer)+0x16C, true)
    currAnim = ReadByte(ReadLong(soraPointer)+0x164, true)
    
    if contains(ground_finishers, currAnim) and current_hits > 1 and ReadByte(inputAddress + 0x3) == 0 and animation_time > 40 then
        WriteByte(soraHP + 0x98, 1)
        WriteByte(ReadLong(soraPointer), 0x3, true)
    elseif not contains(ground_animations, currAnim) then
        WriteByte(soraHP + 0x98, 3)
    end
end

function _OnInit()
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        require("VersionCheck")
        if canExecute then
            btltbl = jumpHeights - 0xAC
        end
    else
        ConsolePrint("KH1 not detected, not running script")
    end
end

function _OnFrame()
    if canExecute then
        stock = ReadArray(inventory, 255)
        acc_slots = ReadByte(maxHP + 0x16)
        acc_equipped = ReadArray(maxHP + 0x17, acc_slots)
        handle_context_abilities(acc_equipped)
        handle_limit_abilities(acc_equipped)
        handle_passive_abilities(acc_equipped)
        handle_combo_length(acc_equipped)
        handle_walk_and_animation_speed(acc_equipped)
        handle_scan(acc_equipped)
        handle_combo_master(acc_equipped)
        handle_summon_anywhere(acc_equipped)
        handle_midair_dodge_roll_guard(acc_equipped)
        handle_midair_items(acc_equipped)
        handle_magic_boosts(acc_equipped)
        handle_magic_costs(acc_equipped)
    end
end