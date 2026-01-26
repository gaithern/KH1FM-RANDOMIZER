local revertCode = false
local removeWhite = 0
local lastDeathPointer = 0
local soraHP = {0x2D5D64C, 0x2D5CC4C} --changed for EGS 1.0.0.10
local stateFlag = {0x2867CD8, 0x2867364} --changed for EGS 1.0.0.10 (may need to look into steam)
local deathCheck = {0x299F20, 0x29C0B0} --changed BOTH 1.0.0.10
local whiteFade = {0x234081C, 0x233FE1C} --changed for EGS 1.0.0.10
local deathPointer = {0x2398838, 0x2382568} --changed for EGS 1.0.0.10

local donald_death_link = false
local goofy_death_link = false
local sora_hp_address_base = {0x2DE9D60, 0x2DE9360} --changed for EGS 1.0.0.10
local soras_hp_address = {0x2DE9D60 + 0x5, 0x2DE9360 + 0x5} --changed for EGS 1.0.0.10
local donalds_hp_address = {0x2DE9D60 + 0x5 + 0x74, 0x2DE9360 + 0x5 + 0x74} --changed for EGS 1.0.0.10
local goofys_hp_address = {0x2DE9D60 + 0x5 + 0x74 + 0x74, 0x2DE9360 + 0x5 + 0x74 + 0x74} --changed for EGS 1.0.0.10

function ko_sora()
    if not sora_koed() then
        WriteByte(soraHP[game_version], 0)
        WriteByte(soras_hp_address[game_version], 0)
        WriteByte(stateFlag[game_version], 1)
        WriteShort(deathCheck[game_version], 0x9090)
        revertCode = true
    end
end

function heartless_angel_sora()
    if not sora_koed() then
        WriteByte(soraHP[game_version], 1)
        WriteByte(soras_hp_address[game_version], 1)
        WriteByte(soraHP[game_version] + 0x8, 0)
        WriteByte(soras_hp_address[game_version] + 2, 0)
    end
end

function sora_koed()
    return ReadByte(soras_hp_address[game_version]) == 0
end

function death_link_init()
    lastDeathPointer = ReadLong(deathPointer[game_version])
    soras_last_hp = ReadByte(soraHP[game_version])
end

function death_link_frame()
    if removeWhite > 0 then
        removeWhite = removeWhite - 1
        if ReadByte(whiteFade[game_version]) == 128 then
            WriteByte(whiteFade[game_version], 0)
        end
    end
    -- Reverts disabling death condition check (or it crashes)
    if revertCode and ReadLong(deathPointer[game_version]) ~= lastDeathPointer then
        WriteShort(deathCheck[game_version], 0x2E74)
        removeWhite = 1000
        revertCode = false
    end
    
    if goofy_death_link then
        if ReadByte(goofys_hp_address[game_version]) == 0 and ReadByte(soras_hp_address[game_version]) > 0 then
            ConsolePrint("Goofy was defeated!")
            kill_sora()
        end
    end
    if donald_death_link then
        if ReadByte(donalds_hp_address[game_version]) == 0 and ReadByte(soras_hp_address[game_version]) > 0 then
            ConsolePrint("Donald was defeated!")
            kill_sora()
        end
    end
end