-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "1fmAPStackableGrowth"
LUAGUI_AUTH = "Denhonator with edits by Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

game_version = 1 --1 for EGS 1.0.0.10, 2 for Steam 1.0.0.10

canExecute = false
dodgeDataAddr = 0

function CountSharedAbilities()
    sharedAbilities = {0x2DEA2F9, 0x2DE98F9} --changed for EGS 1.0.0.10
    local shared = {0,0,0}
    for i=0,9 do
        local ab = ReadByte(sharedAbilities[game_version]+i)
        if ab == 3 or ab == 4 then
            shared[3] = shared[3]+1
        elseif ab > 0 and ab <= 4 then
            shared[ab] = shared[ab]+1
        end
    end
    return shared
end

function StackAbilities()
    jumpHeights         = {0x2D237EC, 0x2D22DEC} --changed for EGS 1.0.0.10
    world               = {0x2340E5C, 0x233FE84} --changed for EGS 1.0.0.10
    room                = {0x2340E5C + 0x68, 0x233FE84 + 0x8} --changed for EGS 1.0.0.10
    soraHUD             = {0x2812E9C, 0x281249C} --changed for EGS 1.0.0.10
    cutsceneFlags       = {0x2DEA760, 0x2DE9D60} --changed for EGS 1.0.0.10
    sharedAbilities     = {0x2DEA2F9, 0x2DE98F9} --changed for EGS 1.0.0.10
    superglideSpeedHack = {0x2B08F4, 0x2B2A84} --changed BOTH 1.0.0.10
    mermaidKickSpeed    = {0x3F088C, 0x3EFA4C} --changed BOTH 1.0.0.10
    stateFlag           = {0x2867CD8, 0x2867364} --changed for EGS 1.0.0.10
    local countedAbilities = CountSharedAbilities()
    local jumpHeight = math.max(290, 190+(countedAbilities[1]*100))
    stackAbilities = 2

    WriteShort(jumpHeights[game_version]+2, jumpHeight)
    if ReadByte(world[game_version]) == 0x10 and countedAbilities[3] == 0 and stackAbilities == 3 and (ReadByte(room[game_version]) == 0x21 or 
            (ReadByte(cutsceneFlags[game_version]+0xB0F) >= 0x6E) and ReadFloat(soraHUD[game_version]) > 0) then
        WriteShort(jumpHeights[game_version], 390)
        WriteShort(jumpHeights[game_version]+2, math.max(390, jumpHeight))
    end

    if stackAbilities > 1 then
        local glides = false
        for i=0,9 do
            local ab = ReadByte(sharedAbilities[game_version]+i)
            if ab % 0x80 >= 3 and not glides then
                WriteByte(sharedAbilities[game_version]+i, (ab % 0x80 == 4) and ab-1 or ab)
                glides = true
            elseif ab % 0x80 == 3 and glides then
                WriteByte(sharedAbilities[game_version]+i, ab+1)
            end
        end
        if game_version == 1 then
            if ReadShort(superglideSpeedHack[game_version]+1) == 0x17FF then
                WriteInt(superglideSpeedHack[game_version], 0x17FFBC + math.max(countedAbilities[3]-2, 0)*4)
            end
        elseif game_version == 2 then
            if ReadShort(superglideSpeedHack[game_version]+1) == 0x17CE then
                WriteInt(superglideSpeedHack[game_version], 0x17CEDC + math.max(countedAbilities[3]-2, 0)*4)
            end
        end
        
        WriteFloat(mermaidKickSpeed[game_version], 10+(8*countedAbilities[2]))
        
        -- Allow early flight in Neverland if glide equipped
        if countedAbilities[3] > 0 and ReadByte(world[game_version]) == 0xD then
            if (ReadByte(stateFlag[game_version]) // 0x20) % 2 == 0 then
                WriteByte(stateFlag[game_version], ReadByte(stateFlag[game_version]) + 0x20)
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
        end
        if ReadByte(IsSteamGLVersion) == 0xF0 then
            ConsolePrint("Steam Version Detected")
            game_version = 2
        end
        canExecute = true
    end
end
function _OnFrame()
    if canExecute then
        StackAbilities()
    end
end