LUAGUI_NAME = "1fmRandoHandleAugments"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Handle Accessory Augments"

require("kh1_lua_library")
require("globals")

canExecute = false

local ground_starter_attack_data = {}
ground_starter_attack_data[9]  = {0xD0, 0x00, 0x05, 0xFF, 0xB8, 0x50, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x05, 0x06, 0x04, 0x00, 0x00, 0x00, 0x00}
ground_starter_attack_data[10] = {0xD3, 0x00, 0x05, 0xFF, 0x58, 0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x05, 0x06, 0xFF, 0x00, 0x00, 0x00, 0x00}
ground_starter_attack_data[12] = {0xCF, 0x00, 0x05, 0xFF, 0x28, 0x51, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x06, 0x04, 0x00, 0x00, 0x00, 0x00}
ground_starter_attack_data[13] = {0xC8, 0x00, 0x05, 0xFF, 0x78, 0x4B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x06, 0x04, 0x00, 0x00, 0x00, 0x00}
ground_starter_attack_data[14] = {0xCA, 0x00, 0x05, 0xFF, 0x78, 0x4B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x05, 0x06, 0x04, 0x00, 0x00, 0x00, 0x00}
ground_starter_attack_data[27] = {0xC9, 0x00, 0xFF, 0xFF, 0x18, 0x5C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x05, 0x06, 0xFF, 0x00, 0x00, 0x00, 0x00}

local ground_standard_finisher_attack_data = {0xCB, 0x00, 0x05, 0xFF, 0x58, 0x4C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x05, 0x06, 0x05, 0x00, 0x00, 0x00, 0x00}
local ground_finisher_animations = {0xCB, 0xD0, 0xD2, 0xD3, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA}
local ground_attack_animations = {0xC8, 0xC9, 0xCA, 0xCB, 0xCF, 0xD0, 0xD2, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA}

local ground_buffed_animations = {0xCB, 0xD0, 0xD2, 0xD3, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA}
local ground_buffed_bonuses    = {0.4,  1.0,  0.4,  0.75, 0.4,  0.5 , 0.5,  0.5,  0.4}
local air_nerfed_animations    = {0xCC, 0xCD, 0xCE, 0xD1}

function handle_abilities(acc_equipped)
    local ability_names = {
        ["Vortex"]          = aug_acc["aug_vortex_acc"],
        ["Aerial Sweep"]    = aug_acc["aug_aerial_sweep_acc"],
        ["Counterattack"]   = aug_acc["aug_counterattack_acc"],
        ["Blitz"]           = aug_acc["aug_blitz_acc"],
        ["Guard"]           = aug_acc["aug_guard_acc"],
        ["Dodge Roll"]      = aug_acc["aug_dodge_roll_acc"],
        ["Cheer"]           = aug_acc["aug_cheer_acc"],
        ["Slapshot"]        = aug_acc["aug_slapshot_acc"],
        ["Sliding Dash"]    = aug_acc["aug_sliding_dash_acc"],
        ["Hurricane Blast"] = aug_acc["aug_hurricane_blast_acc"],
        ["Ripple Drive"]    = aug_acc["aug_ripple_drive_acc"],
        ["Stun Impact"]     = aug_acc["aug_stun_impact_acc"],
        ["Gravity Break"]   = aug_acc["aug_gravity_break_acc"],
        ["Zantetsuken"]     = aug_acc["aug_zantetsuken_acc"],
        ["Sonic Blade"]     = aug_acc["aug_sonic_blade_acc"],
        ["Ars Arcanum"]     = aug_acc["aug_ars_arcanum_acc"],
        ["Strike Raid"]     = aug_acc["aug_strike_raid_acc"],
        ["Ragnarok"]        = aug_acc["aug_ragnarok_acc"],
        ["Trinity Limit"]   = aug_acc["aug_trinity_limit_acc"],
        ["MP Haste"]        = aug_acc["aug_mp_haste_acc"],
        ["MP Rage"]         = aug_acc["aug_mp_rage_acc"],
        ["Second Chance"]   = aug_acc["aug_second_chance_acc"],
        ["Berserk"]         = aug_acc["aug_berserk_acc"],
        ["Leaf Bracer"]     = aug_acc["aug_leaf_bracer_acc"]
    }

    for ability_name, acc_value in pairs(ability_names) do
        if contains(acc_equipped, acc_value) then
            enable_ability(ability_name)
        end
    end
end


function handle_ground_combo_length(acc_equipped)
    ground_combo_length = calculate_ground_combo_limit()
    if contains(acc_equipped, aug_acc["aug_finisher_lock_acc"]) then
        ground_combo_length = 1
    end
    set_ground_combo_length_limit(ground_combo_length)
    return ground_combo_length
end

function handle_air_combo_length(acc_equipped)
    air_combo_length = calculate_air_combo_limit()
    if contains(acc_equipped, aug_acc["aug_air_finisher_lock_acc"]) then
        air_combo_length = 1
    end
    set_air_combo_length_limit(air_combo_length)
    return air_combo_length
end

function handle_walk_and_animation_speed(acc_equipped)
    haste_acc = {
        [1] = aug_acc["aug_haste_acc"],
        [2] = aug_acc["aug_hastera_acc"],
        [3] = aug_acc["aug_hastega_acc"]
    }
    slow_acc = {
        [1] = aug_acc["aug_slow_acc"],
        [2] = aug_acc["aug_slowra_acc"],
        [3] = aug_acc["aug_slowga_acc"]
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
    set_sora_run_speed(run_speed)
    set_sora_walk_speed(walk_speed)
    set_animation_speed(haste_mod)
    
    return haste_mod
end

function handle_scan(acc_equipped)
    if contains(acc_equipped, aug_acc["aug_scan_acc"]) then
        force_scan(true)
    else
        force_scan(false)
    end
end

function handle_combo_master(acc_equipped)
    if contains(acc_equipped, aug_acc["aug_combo_master_acc"]) then
        force_combo_master(true)
    else
        force_combo_master(false)
    end
end

function handle_summon_anywhere(acc_equipped)
    if contains(acc_equipped, aug_acc["aug_summon_anywhere_acc"]) then
        allow_summon_anywhere(true)
    else
        allow_summon_anywhere(false)
    end
end

function handle_midair_dodge_roll_guard(acc_equipped)
    if contains(acc_equipped, aug_acc["aug_air_guard_dodge_roll_acc"]) then
        allow_midair_dodge_roll_guard(true)
    else
        allow_midair_dodge_roll_guard(false)
    end
end

function handle_midair_items(acc_equipped)
    if contains(acc_equipped, aug_acc["aug_air_items_acc"]) then
        allow_air_items(true)
    else
        allow_air_items(false)
    end
end

function handle_magic_boosts(acc_equipped)
    local acc_values_lib = {
        ["Fire"]     = {aug_acc["aug_fire_boost_acc"],     aug_acc["aug_fire_down_acc"]},
        ["Fira"]     = {aug_acc["aug_fire_boost_acc"],     aug_acc["aug_fire_down_acc"]},
        ["Firaga"]   = {aug_acc["aug_fire_boost_acc"],     aug_acc["aug_fire_down_acc"]},
        ["Blizzard"] = {aug_acc["aug_blizzard_boost_acc"], aug_acc["aug_blizzard_down_acc"]},
        ["Blizzara"] = {aug_acc["aug_blizzard_boost_acc"], aug_acc["aug_blizzard_down_acc"]},
        ["Blizzaga"] = {aug_acc["aug_blizzard_boost_acc"], aug_acc["aug_blizzard_down_acc"]},
        ["Thunder"]  = {aug_acc["aug_thunder_boost_acc"],  aug_acc["aug_thunder_down_acc"]},
        ["Thundara"] = {aug_acc["aug_thunder_boost_acc"],  aug_acc["aug_thunder_down_acc"]},
        ["Thundaga"] = {aug_acc["aug_thunder_boost_acc"],  aug_acc["aug_thunder_down_acc"]},
        ["Cure"]     = {aug_acc["aug_cure_boost_acc"],     aug_acc["aug_cure_down_acc"]},
        ["Cura"]     = {aug_acc["aug_cure_boost_acc"],     aug_acc["aug_cure_down_acc"]},
        ["Curaga"]   = {aug_acc["aug_cure_boost_acc"],     aug_acc["aug_cure_down_acc"]},
        ["Gravity"]  = {aug_acc["aug_gravity_boost_acc"],  aug_acc["aug_gravity_down_acc"]},
        ["Gravira"]  = {aug_acc["aug_gravity_boost_acc"],  aug_acc["aug_gravity_down_acc"]},
        ["Graviga"]  = {aug_acc["aug_gravity_boost_acc"],  aug_acc["aug_gravity_down_acc"]},
        ["Stop"]     = {aug_acc["aug_stop_boost_acc"],     aug_acc["aug_stop_down_acc"]},
        ["Stopra"]   = {aug_acc["aug_stop_boost_acc"],     aug_acc["aug_stop_down_acc"]},
        ["Stopga"]   = {aug_acc["aug_stop_boost_acc"],     aug_acc["aug_stop_down_acc"]},
        ["Aero"]     = {aug_acc["aug_aero_boost_acc"],     aug_acc["aug_aero_down_acc"]},
        ["Aerora"]   = {aug_acc["aug_aero_boost_acc"],     aug_acc["aug_aero_down_acc"]},
        ["Aeroga"]   = {aug_acc["aug_aero_boost_acc"],     aug_acc["aug_aero_down_acc"]}
    }
    local mag_mods = {
        ["Fire"]     = 1.0,
        ["Fira"]     = 1.0,
        ["Firaga"]   = 1.0,
        ["Blizzard"] = 1.0,
        ["Blizzara"] = 1.0,
        ["Blizzaga"] = 1.0,
        ["Thunder"]  = 1.0,
        ["Thundara"] = 1.0,
        ["Thundaga"] = 1.0,
        ["Cure"]     = 1.0,
        ["Cura"]     = 1.0,
        ["Curaga"]   = 1.0,
        ["Gravity"]  = 1.0,
        ["Gravira"]  = 1.0,
        ["Graviga"]  = 1.0,
        ["Stop"]     = 1.0,
        ["Stopra"]   = 1.0,
        ["Stopga"]   = 1.0,
        ["Aero"]     = 1.0,
        ["Aerora"]   = 1.0,
        ["Aeroga"]   = 1.0
    }
    for spell, acc_values in pairs(acc_values_lib) do
        if contains(acc_equipped, acc_values[1]) then
            mag_mods[spell] = mag_mods[spell] + 0.3
        end
        if contains(acc_equipped, acc_values[2]) then
            mag_mods[spell] = mag_mods[spell] - 0.3
        end
    end
    local new_effectiveness_values = {}
    for spell, mod in pairs(mag_mods) do
        new_effectiveness_values[spell] = effectiveness_values[spell] * mod
    end
    for spell, effectiveness_value in pairs(new_effectiveness_values) do
        set_spell_effectiveness(spell, effectiveness_value)
    end
end

function handle_magic_costs(acc_equipped)
    local acc_values_lib = {
        ["Fire"]     = {aug_acc["aug_fire_cost_up_acc"],     aug_acc["aug_fire_cost_down_acc"]},
        ["Fira"]     = {aug_acc["aug_fire_cost_up_acc"],     aug_acc["aug_fire_cost_down_acc"]},
        ["Firaga"]   = {aug_acc["aug_fire_cost_up_acc"],     aug_acc["aug_fire_cost_down_acc"]},
        ["Blizzard"] = {aug_acc["aug_blizzard_cost_up_acc"], aug_acc["aug_blizzard_cost_down_acc"]},
        ["Blizzara"] = {aug_acc["aug_blizzard_cost_up_acc"], aug_acc["aug_blizzard_cost_down_acc"]},
        ["Blizzaga"] = {aug_acc["aug_blizzard_cost_up_acc"], aug_acc["aug_blizzard_cost_down_acc"]},
        ["Thunder"]  = {aug_acc["aug_thunder_cost_up_acc"],  aug_acc["aug_thunder_cost_down_acc"]},
        ["Thundara"] = {aug_acc["aug_thunder_cost_up_acc"],  aug_acc["aug_thunder_cost_down_acc"]},
        ["Thundaga"] = {aug_acc["aug_thunder_cost_up_acc"],  aug_acc["aug_thunder_cost_down_acc"]},
        ["Cure"]     = {aug_acc["aug_cure_cost_up_acc"],     aug_acc["aug_cure_cost_down_acc"]},
        ["Cura"]     = {aug_acc["aug_cure_cost_up_acc"],     aug_acc["aug_cure_cost_down_acc"]},
        ["Curaga"]   = {aug_acc["aug_cure_cost_up_acc"],     aug_acc["aug_cure_cost_down_acc"]},
        ["Gravity"]  = {aug_acc["aug_gravity_cost_up_acc"],  aug_acc["aug_gravity_cost_down_acc"]},
        ["Gravira"]  = {aug_acc["aug_gravity_cost_up_acc"],  aug_acc["aug_gravity_cost_down_acc"]},
        ["Graviga"]  = {aug_acc["aug_gravity_cost_up_acc"],  aug_acc["aug_gravity_cost_down_acc"]},
        ["Stop"]     = {aug_acc["aug_stop_cost_up_acc"],     aug_acc["aug_stop_cost_down_acc"]},
        ["Stopra"]   = {aug_acc["aug_stop_cost_up_acc"],     aug_acc["aug_stop_cost_down_acc"]},
        ["Stopga"]   = {aug_acc["aug_stop_cost_up_acc"],     aug_acc["aug_stop_cost_down_acc"]},
        ["Aero"]     = {aug_acc["aug_aero_cost_up_acc"],     aug_acc["aug_aero_cost_down_acc"]},
        ["Aerora"]   = {aug_acc["aug_aero_cost_up_acc"],     aug_acc["aug_aero_cost_down_acc"]},
        ["Aeroga"]   = {aug_acc["aug_aero_cost_up_acc"],     aug_acc["aug_aero_cost_down_acc"]}
    }
    
    for spell, acc_values in pairs(acc_values_lib) do
        local new_spell_cost = spell_costs[spell]
        if contains(acc_equipped, acc_values[1]) then
            new_spell_cost = math.min(new_spell_cost + 1, 5)
        end
        if contains(acc_equipped, acc_values[2]) then
            new_spell_cost = math.max(new_spell_cost - 1, 1)
        end
        set_spell_cost(spell, new_spell_cost)
    end
end

function handle_grounded(acc_equipped, haste_mod)
    if contains(acc_equipped, aug_acc["aug_grounded_acc"]) then
        currSpeed = haste_mod
        currAnim = get_current_animation()
        i = index(ground_buffed_animations, currAnim)
        if i ~= nil then
            set_animation_speed(currSpeed + ground_buffed_bonuses[i])
        else
            set_animation_speed(haste_mod)
        end
    else
        set_animation_speed(haste_mod)
    end
end

function handle_finishing_plus(acc_equipped, ground_combo_length)
    if contains(acc_equipped, aug_acc["aug_finishing_plus_acc"]) then
        starters = {}
        current_hits = get_current_hits()
        currAnim = get_current_animation()
        
        if contains(ground_finisher_animations, currAnim) and current_hits > 1 and get_inputs()[3] == 0 and get_animation_time() > 40 then
            set_ground_combo_length_limit(1)
            for k,v in pairs(ground_starter_attack_data) do
                set_attack_animation_data(k, ground_standard_finisher_attack_data)
            end
            make_sora_actionable()
        elseif not contains(ground_attack_animations, currAnim) then
            for k,v in pairs(ground_starter_attack_data) do
                set_attack_animation_data(k, v)
            end
            set_ground_combo_length_limit(ground_combo_length)
        end
    else
        set_ground_combo_length_limit(ground_combo_length)
    end
end

function handle_summon_boost(acc_equipped)
    if contains(acc_equipped, aug_acc["aug_summon_boost_acc"]) then
        multiply_summon_time(1.5)
    else
        multiply_summon_time(1.0)
    end
end

function _OnInit()
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        require("VersionCheck")
    else
        ConsolePrint("KH1 not detected, not running script")
    end
end

function _OnFrame()
    if canExecute then
        stock = get_stock()
        acc_equipped = get_soras_equipped_accessories()
        haste_mod = handle_walk_and_animation_speed(acc_equipped)
        ground_combo_length = handle_ground_combo_length(acc_equipped)
        air_combo_length = handle_air_combo_length(acc_equipped)
        handle_abilities(acc_equipped)
        handle_scan(acc_equipped)
        handle_combo_master(acc_equipped)
        handle_summon_anywhere(acc_equipped)
        handle_midair_dodge_roll_guard(acc_equipped)
        handle_midair_items(acc_equipped)
        handle_magic_boosts(acc_equipped)
        handle_magic_costs(acc_equipped)
        handle_grounded(acc_equipped, haste_mod)
        handle_finishing_plus(acc_equipped, ground_combo_length)
        handle_summon_boost(acc_equipped)
    end
end