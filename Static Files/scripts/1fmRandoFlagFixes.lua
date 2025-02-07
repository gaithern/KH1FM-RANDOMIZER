LUAGUI_NAME = "1fmAPFlagFixes"
LUAGUI_AUTH = "denhonator with edits from Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Flag Fixes"

game_version = 1 --1 for EGS 1.0.0.10, 2 for Steam 1.0.0.10
debug_on = true

local chestsOpened = {0x2DEA190, 0x2DE9790} --changed for EGS 1.0.0.10
local summonsReturned = {0x2DEAA8C, 0x2DEA08C} --changed for EGS 1.0.0.10
local summons = {0x2DEA530, 0x2DE9B30} --changed for EGS 1.0.0.10
local inventory = {0x2DEA1FA, 0x2DE97FA} --changed for EGS 1.0.0.10
local poohProgress = {0x2DEBAA8, 0x2DEB0A8} --changed for EGS 1.0.0.10
local poohProgress2 = {0x2DEB180, 0x2DEA780} --changed for EGS 1.0.0.10
local emblemCount = {0x2DEBC0D, 0x2DEB20D} --changed for EGS 1.0.0.10
local slideActive = {0x2D40DF0, 0x2D403F0} --changed for EGS 1.0.0.10
local evidence = {0x2DEAB68, 0x2DEA168} --changed for EGS 1.0.0.10
local evidenceActiveForest = {0x2D3DF10, 0x2D3D510} --changed for EGS 1.0.0.10
local evidenceActiveBizarre = {0x2D3D5B0, 0x2D3CBB0} --changed for EGS 1.0.0.10
local theonActive = {0x2D3A220, 0x2D39820} --changed for EGS 1.0.0.10
local emblemDoor = {0x2DEBC1C, 0x2DEB21C} --changed for EGS 1.0.0.10
local reports = {0x2DEB720, 0x2DEAD20} --changed for EGS 1.0.0.10

local worldFlagBase = {0x2DEBDCC, 0x2DEB3CC} --changed for EGS 1.0.0.10
local gummiFlagBase = {0x2DEBC50, 0x2DEB250} --changed for EGS 1.0.0.10
local gummiselect = {0x507D7C, 0x50707C}
local inGummi = {0x5082AD, 0x5075A8} --may need to revist
local battleLevel = {0x2DEB724, 0x2DEAD24} --changed for EGS 1.0.0.10
local unlockedWarps = {0x2DEBC66, 0x2DEB266} --changed for EGS 1.0.0.10
local cutsceneFlags = {0x2DEA760, 0x2DE9D60} --changed for EGS 1.0.0.10
local libraryFlag = {0x2DEBE83, 0x2DEB483} --changed for EGS 1.0.0.10
local scriptPointer = {0x2398838, 0x2382568} --changed for EGS 1.0.0.10
local cupCurrentSeed = {0x238D800, 0x23BBBF0} --changed for EGS 1.0.0.10
local waterwayGate = {0x2DEB9CD, 0x2DEAFCD} --changed for EGS 1.0.0.10
local waterwayTrinity = {0x2DEBA11, 0x2DEB011} --changed for EGS 1.0.0.10
local sliderProgress = {0x2DEBA99, 0x2DEB099} --changed for EGS 1.0.0.10
local savedFruits = {0x2DEBA9E, 0x2DEB09E} --changed for EGS 1.0.0.10
local minigameTimer = {0x232EA04, 0x232E000} --changed BOTH 1.0.0.10
local collectedFruits = {0x232EA04 + 4, 0x232E000 + 4} --changed BOTH 1.0.0.10
local unequipBlacklist = {0x546020, 0x545330}
local tutorialFlag = {0x2DEB724, 0x2DEAD24} --changed for EGS 1.0.0.10
local oppositeState = {0x2DEBA18, 0x2DEB018} --changed for EGS 1.0.0.10
local oppositeTrigger = {0x2DEAA7D,0x2DEA07D} --changed for EGS 1.0.0.10

local blackfade = {0x4DD3F8, 0x4DC718}
local enableRC = {0x2DEA5D4, 0x2DE9BD4} --changed for EGS 1.0.0.10
local lockMenu = {0x232E98C, 0x232DF80} --changed for EGS 1.0.0.10
local party1 = {0x2DEA1EF, 0x2DE97EF} --changed for EGS 1.0.0.10
local party2 = {0x2E20F65, 0x2E205A5} --changed for EGS 1.0.0.10 (+0x60 for EGS?)
local soraHUD = {0x2812E9C, 0x281249C} --changed for EGS 1.0.0.10
local world = {0x2340E5C, 0x233FE84} --changed for EGS 1.0.0.10
local room = {0x2340E5C + 0x68, 0x233FE84 + 0x8} --changed for EGS 1.0.0.10

local soraStats = {0x2DE9D60, 0x2DE9360} --changed for EGS 1.0.0.10

local worldWarp = {0x2340EF0, 0x233FEB8} --MAYBE? changed for EGS 1.0.0.10
local roomWarp = {0x2340EF0 + 4, 0x233FEB8 + 4} --MAYBE? changed for EGS 1.0.0.10
local roomWarpRead = {0x232E908, 0x232DF18} --changed for EGS 1.0.0.10
local warpTrigger = {0x22ECA8C, 0x22EC0AC} --changed BOTH 1.0.0.10
local warpType1 = {0x23405C0, 0x233FBC0} --changed for EGS 1.0.0.10
local warpType2 = {0x22ECA90, 0x22EC0B0} --changed BOTH 1.0.0.10
local warpDefinitions = {0x232E900, 0x232DF10} --changed for EGS 1.0.0.10

local worldFlagsAddress = {0x2DEAA6D, 0x2DEA06D}
local world_progress_array_address = {0x2DEB264, 0x2DEA864}
local worldWarps = {0x50FA68, 0x50ABA8}
local warpCount = {0x50FB4C, 0x50AC8C}

local prevTTFlag = 0

local canExecute = false

debug_statements = {}

function debugPrint(input)
    print_str = true
    if debug_on then
        for k,v in pairs(debug_statements) do
            if tostring(input) == v then
                print_str = false
            end
        end
        if print_str then
            ConsolePrint(input)
            debug_statements[#debug_statements+1] = tostring(input)
        end
    end
end

function FlagFixes()
    if ReadByte(world[game_version]) == 0 and ReadByte(room[game_version]) == 0 and ReadByte(cutsceneFlags[game_version]+0xB01) == 0xA then
        debugPrint("Section 1")
        WriteByte(cutsceneFlags[game_version]+0xB01, 0xD)
        WriteByte(warpType1[game_version], 7)
        WriteByte(warpType2[game_version], 6)
        WriteByte(warpTrigger[game_version], 2)
        instant_gummi_fix_address = {0x2538A50, 0x2538060} --changed for EGS 1.0.0.10
        WriteLong(instant_gummi_fix_address[game_version], 0) -- Fixes InstantGummi
    end

    if ReadByte(world[game_version]) == 1 and ReadFloat(soraHUD[game_version]) > 0 and ReadInt(inGummi[game_version]) == 0 then
        debugPrint("Section 2")
        WriteByte(party1[game_version], 0xFF)
        WriteByte(party1[game_version]+1, 0xFF)
    end
    
    -- Reset TT to avoid softlocks
    if ReadByte(cutsceneFlags[game_version]+0xB04) < 0x14 and ReadByte(world[game_version]) > 3 then
        debugPrint("Section 3")
        WriteByte(cutsceneFlags[game_version]+0xB04, 0)
        WriteByte(worldFlagBase[game_version]+0x1C, 2)
    end
    
    -- Secret waterway Leon unmissable
    if ReadByte(cutsceneFlags[game_version]+0x312) == 0 and ReadByte(cutsceneFlags[game_version]+0xB04) >= 0x31 then
        debugPrint("Section 4")
        WriteByte(cutsceneFlags[game_version]+0xB04, 0x31)
        WriteByte(worldFlagBase[game_version]+0x32, 2)
    end
    
    -- Skip TT2
    if ReadByte(cutsceneFlags[game_version]+0xB04) == 0x3E then
        debugPrint("Section 5")
        WriteByte(cutsceneFlags[game_version]+0xB04, 0x4E)
        WriteByte(worldFlagBase[game_version]+0x1C, 5)
    end
    
    -- Revert HB1 effect on TT story
    if (ReadByte(cutsceneFlags[game_version]+0xB04) == 0x6E and ReadByte(worldFlagBase[game_version]+0x1C) ~= 5)
                                            or ReadByte(cutsceneFlags[game_version]+0xB04) == 0x96 then
        debugPrint("Section 6")
        WriteByte(cutsceneFlags[game_version]+0xB04, prevTTFlag)
    end
    
    if ReadByte(cutsceneFlags[game_version]+0xB0E) >= 0xA0 and ReadByte(worldFlagBase[game_version]+0x1C) == 5
                                            and ReadByte(cutsceneFlags[game_version]+0xB04) < 0x6E then
        debugPrint("Section 7")
        WriteByte(cutsceneFlags[game_version]+0xB04, 0x6E)
        WriteByte(cutsceneFlags[game_version]+0xB00, math.max(0xBE, ReadByte(cutsceneFlags[game_version]+0xB00)))
        --debugPrint("Post HB TT")
    end
    
    prevTTFlag = ReadByte(cutsceneFlags[game_version]+0xB04)
    
    if ReadByte(oppositeState[game_version]) >= 5 then
        debugPrint("Section 8")
        WriteByte(oppositeTrigger[game_version], 0)
    end
    
    if ReadByte(world[game_version]) == 3 and ReadByte(room[game_version]) == 0x13 then
        debugPrint("Section 9")
        local simbaAddr = ReadLong(scriptPointer[game_version]) + 0x131C8
        local earthshine = -0x423B
        if ReadInt(simbaAddr, true) == 0x53090000 then
            simbaAddr = simbaAddr + 0x460 --Spanish
        elseif ReadInt(simbaAddr, true) == 0x01400500 then
            simbaAddr = simbaAddr + 0x10B0 --German
        elseif ReadInt(simbaAddr, true) == 0x6D090000 then
            simbaAddr = simbaAddr - 0x1F68 --Japanese
            earthshine = -0x4227
        end
        if ReadByte(simbaAddr, true)==5 then
            local hasSummons = {}
            local hasAll = true
            for i=0,5 do
                hasSummons[ReadByte(summons[game_version]+i)] = true
                hasAll = hasAll and ReadByte(summons[game_version]+i) < 0xFF
            end
            
            WriteByte(summonsReturned[game_version], hasSummons[1] and 1 or 0)
            WriteByte(summonsReturned[game_version]+1, hasSummons[0] and 1 or 0)
            WriteByte(summonsReturned[game_version]+2, hasSummons[4] and 1 or 0)
            WriteByte(summonsReturned[game_version]-1, hasSummons[5] and 1 or 0)
            
            local c = ReadByte(inventory[game_version]+0xD0) > 0
            local genie = ReadByte(inventory[game_version]+0x88) > 0
            local tbell = ReadByte(inventory[game_version]+0x8B) > 0
    
            -- Nullify normal simba acqusition
            WriteInt(simbaAddr+4, c and 0x18000238 or 0x18000004, true)
            WriteInt(simbaAddr+12, c and 0x18000233 or 0x18000004, true)
            -- Replace another summon with Simba
            WriteByte(simbaAddr+earthshine, c and 0xD1 or 0xCF, true)
            WriteByte(simbaAddr+0x16FB, c and 0xD1 or 0xCF, true)
            WriteByte(simbaAddr+0x164B, c and 5 or 1, true)
            WriteByte(simbaAddr+0x164B+8, c and 5 or 1, true)
        end
    end
    
    if ReadByte(cutsceneFlags[game_version]+0xB04) >= 0x31 then
        debugPrint("Section 11")
        WriteByte(worldFlagBase[game_version]+0x26, 2) -- Cid in accessory shop
        WriteByte(worldFlagBase[game_version]+0x1D, 3)
    end
    if ReadByte(cutsceneFlags[game_version]+0xB09) < 0x14 then -- Fix monstro DI cutscene softlock
        debugPrint("Section 12")
        WriteByte(cutsceneFlags[game_version]+0xB09, 0x14)
    end
    
    -- Shorten solo and time trial
    if ReadByte(world[game_version]) == 0xB then
        debugPrint("Section 13")
        if (ReadShort(cupCurrentSeed[game_version]) == 0x0101 or ReadShort(cupCurrentSeed[game_version]) == 0x0B0B)
        and ReadFloat(soraHUD[game_version]) > 0 and (ReadByte(party1[game_version]) == 0xFF or ReadInt(minigameTimer[game_version]) > 0) then
            WriteShort(cupCurrentSeed[game_version], ReadShort(cupCurrentSeed[game_version]) == 0x0101 and 0x0909 or 0x1212)
        elseif ReadByte(world[game_version]) == 0xB and ReadByte(room[game_version]) == 1 then
            WriteInt(minigameTimer[game_version], 0)
        end
        
        -- Require Entry Pass
        if ReadByte(cutsceneFlags[game_version]+0xB06) == 0x10 then
            WriteByte(worldFlagBase[game_version]+0x94, ReadByte(inventory[game_version]+0xE4) > 0 and 3 or 2)
        end
    end
    
    if (ReadByte(waterwayGate[game_version]) // 0x80) % 2 == 0 then
        debugPrint("Section 14")
        WriteByte(waterwayGate[game_version], ReadByte(waterwayGate[game_version])+0x80)
    end
    
    if (ReadByte(waterwayTrinity[game_version]) // 0x20) % 2 == 0 then
        debugPrint("Section 15")
        WriteByte(waterwayTrinity[game_version], ReadByte(waterwayTrinity[game_version])+0x20)
    end
    
    if ReadByte(worldFlagBase[game_version]+0x36) >= 0 then
        debugPrint("Section 16")
        if (ReadByte(chestsOpened[game_version]+0x1F8)//2) % 2 == 0 then
            WriteByte(worldFlagBase[game_version]+0x36, 0xD)
        elseif (ReadByte(chestsOpened[game_version]+0x1F8)//4) % 2 == 0 then
            WriteByte(worldFlagBase[game_version]+0x36, 0xE)
        elseif (ReadByte(chestsOpened[game_version]+0x1F8)//8) % 2 == 0 then
            WriteByte(worldFlagBase[game_version]+0x36, 0x10)
        end
    end
    
    if ReadByte(world[game_version]) == 3 and ReadByte(room[game_version]) == 2 and ReadByte(cutsceneFlags[game_version]+0xB04) == 0x23 then
        debugPrint("Section 17")
        WriteByte(unequipBlacklist[game_version], ReadByte(soraStats[game_version]+0x36))
    else
        for i=0,3 do
            WriteByte(unequipBlacklist[game_version] + (i*4), 0)
        end
    end
    
    if ReadInt(inGummi[game_version]) > 0 then
        debugPrint("Section 18")
        if ReadByte(gummiselect[game_version]) == 3 and ReadByte(cutsceneFlags[game_version]+0xB04) < 0x31 then
            WriteByte(party1[game_version], 0xFF)
            WriteByte(party1[game_version]+1, 0xFF)
        elseif ReadByte(gummiselect[game_version]) == 0xF and ReadByte(cutsceneFlags[game_version]+0xB0E) < 0x31
                                            and ReadByte(cutsceneFlags[game_version]+0xB0E) >= 0x1E then
            WriteByte(party1[game_version], 9)
            WriteByte(party1[game_version]+1, 0xFF)
            WriteByte(party2[game_version], 9)
            WriteByte(party2[game_version]+1, 0xFF)
        elseif ReadByte(party1[game_version]) >= 9 then
            for i=0,1 do
                WriteByte(party1[game_version]+i, i+1)
                WriteByte(party2[game_version]+i, i+1)
            end
        end
    
        if ReadByte(lockMenu[game_version]) > 0 then
            WriteByte(lockMenu[game_version], 0) -- Unlock menu
        end
    
        if ReadByte(enableRC[game_version]) ~= 0x0 then
            WriteByte(enableRC[game_version], 0x0)
        end
        
        if ReadByte(reports[game_version]+4) == 0 then
            WriteByte(reports[game_version]+4, 0xE)
        end
        
        if (ReadByte(tutorialFlag[game_version]) // 0x10) % 2 == 0 then
            WriteByte(tutorialFlag[game_version], ReadByte(tutorialFlag[game_version])+0x10)
        end
    end
    
    if ReadByte(world[game_version]) == 1 and ReadByte(blackfade[game_version])>0 and ReadByte(worldFlagBase[game_version]+0xA) == 2 then -- DI Day2 Warp to EotW
        debugPrint("Section 19")
        RoomWarp(0x10, 0x42)
        WriteByte(party1[game_version], 1)
        WriteByte(party1[game_version]+1, 2)
        WriteByte(worldFlagBase[game_version]+0xA, 0)
        if ReadByte(cutsceneFlags[game_version]+0xB0F) >= 0x5A then
            WriteByte(cutsceneFlags[game_version]+0xB0F, 0)
        end
    end
    
    if ReadByte(cutsceneFlags[game_version]+0xB0D) == 0x64 then
        debugPrint("Section 20")
        RoomWarp(0xD, 0x27)
        WriteByte(cutsceneFlags[game_version]+0xB0D, 0x6A)
    end
    
    if ReadByte(cutsceneFlags[game_version]+0xB07) < 0x11 and ReadByte(world[game_version]) == 4 then
        debugPrint("Section 21")
        if ReadByte(room[game_version]) == 4 then
            local o = 0
            while ReadInt(evidenceActiveForest[game_version]+4+o*0x4B0) ~= 0x40013 and ReadInt(evidenceActiveForest[game_version]+4+o*0x4B0) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadLong(evidenceActiveForest[game_version]+o*0x4B0) == 0x0004001300008203 then
                WriteLong(evidenceActiveForest[game_version]+o*0x4B0, 0)
                WriteLong(evidenceActiveForest[game_version]+(o+1)*0x4B0, 0)
            end
        elseif ReadByte(room[game_version]) == 1 then
            local o = 0
            while ReadInt(evidenceActiveBizarre[game_version]+4+o*0x4B0) ~= 0x40013 and ReadInt(evidenceActiveBizarre[game_version]+4+o*0x4B0) ~= 0 and o > -5 do
                o = o-1
            end
            if ReadLong(evidenceActiveBizarre[game_version]+o*0x4B0) == 0x0004001300008003 then
                WriteLong(evidenceActiveBizarre[game_version]+o*0x4B0, 0)
                WriteLong(evidenceActiveBizarre[game_version]+(o+1)*0x4B0, 0)
            end
        end
    end
    
    if ReadByte(world[game_version]) == 5 then
        debugPrint("Section 22")
        if ReadByte(room[game_version]) == 8 and ReadByte(sliderProgress[game_version]) == 1 then
            WriteByte(collectedFruits[game_version], 0)
            WriteByte(savedFruits[game_version], 0)
            local warpsAddr = ReadLong(warpDefinitions[game_version])
            if ReadByte(warpsAddr, true)==0 and ReadByte(warpsAddr+0x40, true)==1 then
                for i=0, 4 do
                    if ReadByte(sliderProgress[game_version]+i) == 1 and ReadByte(warpsAddr+0x9C0) < 0x10+i then
                        WriteArray(warpsAddr+0x9C0, ReadArray(warpsAddr+0x9C0+(0x40*(i+1)), 0x40, true), true)
                    end
                end
            end
        end
        if ReadByte(room[game_version]) > 0xF then
            WriteByte(collectedFruits[game_version], math.max(ReadByte(collectedFruits[game_version]), (ReadByte(room[game_version])-0xF)*10))
        end
        
        if ReadByte(cutsceneFlags[game_version]+0xB05) <= 0x1A then
            if ReadByte(room[game_version]) == 0xC then
                local o = 0
                while ReadInt(slideActive[game_version]+o*0x4B0+4) ~= 0x40018 and ReadInt(slideActive[game_version]+o*0x4B0+4) ~= 0 and o > -5 do
                    o = o-1
                end
                if ReadInt(slideActive[game_version]+o*0x4B0+4) == 0x40018 then
                    for i=0,5 do
                        if ReadInt(slideActive[game_version]+(i+o)*0x4B0+4) == 0x40018+(i>1 and i+4 or i) then
                            WriteLong(slideActive[game_version]+(i+o)*0x4B0, 0)
                        end
                    end
                end
                --end
            end
        end
    end
    
    if ReadByte(world[game_version]) == 6 then
        debugPrint("Section 23")
        if ReadInt(poohProgress[game_version]) == 0 then
            WriteInt(poohProgress[game_version], 1) --Intro cutscene
            WriteInt(poohProgress2[game_version], 0x00020002) --1st and 2nd area
            WriteInt(poohProgress2[game_version]+4, 0x00020005) --3rd area and 4th (4,9 final)
            WriteInt(poohProgress2[game_version]+8, 0x00020002) --5th area and 6th (4,9 final)
        end
        if ReadByte(collectedFruits[game_version]) >= 100 and ReadByte(room[game_version]) == 4 then
            WriteInt(minigameTimer[game_version], 0)
        end
    end
    if ReadInt(inGummi[game_version]) > 0 and ReadByte(unlockedWarps[game_version]+2) < 3 and true then
        debugPrint("Section 24")
        WriteByte(unlockedWarps[game_version]+2, 3)
        WriteByte(cutsceneFlags[game_version]+0xB0F, math.max(ReadByte(cutsceneFlags[game_version]+0xB0F), 8))
        WriteByte(worldFlagBase[game_version]+0xDC, 0xD)
        WriteByte(worldFlagBase[game_version]+0xDF, 0xD)
    end
    
    if ReadByte(battleLevel[game_version]) % 2 == 1 and ReadByte(cutsceneFlags[game_version]+0xB0E) < 0x8C then
        debugPrint("Section 25")
        WriteByte(battleLevel[game_version], ReadByte(battleLevel[game_version])-1)
    end
    
    --Prevent issues in early HB exploration
    if ReadByte(cutsceneFlags[game_version]+0xB0E) <= 1 then
        debugPrint("Section 26")
        WriteByte(cutsceneFlags[game_version]+0xB0E, 0xA)
    end
    
    if ReadByte(world[game_version]) == 0xF then
        debugPrint("Section 27")
        local embCount = 0
        for i=0xBB, 0xBE do
            embCount = embCount + math.min(ReadByte(inventory[game_version]+i), 1)
        end
        
        local canPlace = embCount == 4 or ReadByte(emblemDoor[game_version]) > 0
        
        WriteByte(emblemCount[game_version], canPlace and 4 or 0)
        --Save Emblem Piece Event Progress & Keep Emblem Door Opened if All Emblem Piece Events are done
        if ReadByte(cutsceneFlags[game_version]+0xB0E) > 0x32 and (ReadByte(room[game_version]) ~= 4 or ReadByte(blackfade[game_version])==0) then
            local doorClose = ReadByte(roomWarpRead[game_version]) >= 0x10 and ReadByte(roomWarpRead[game_version]) <= 0x13
            WriteByte(emblemDoor[game_version], doorClose and 3 or 4)
            WriteByte(emblemDoor[game_version]+3, doorClose and 1 or 5)
            --if ReadByte(emblemCount+1) > 1 and ReadByte(emblemCount+2) > 1 and ReadByte(emblemCount+3) > 1 and ReadByte(emblemCount+4) > 1 then
            --    WriteByte(emblemDoor, 4)
            --elseif ReadByte(emblemDoor+3) == 0x05 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x01)
            --elseif ReadByte(emblemDoor+3) == 0x15 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x11)
            --elseif ReadByte(emblemDoor+3) == 0x25 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x21)
            --elseif ReadByte(emblemDoor+3) == 0x35 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x31)
            --elseif ReadByte(emblemDoor+3) == 0x45 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x41)
            --elseif ReadByte(emblemDoor+3) == 0x45 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x41)
            --elseif ReadByte(emblemDoor+3) == 0x55 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x51)
            --elseif ReadByte(emblemDoor+3) == 0x65 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x61)
            --elseif ReadByte(emblemDoor+3) == 0x75 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x71)
            --elseif ReadByte(emblemDoor+3) == 0x85 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x81)
            --elseif ReadByte(emblemDoor+3) == 0x95 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0x91)
            --elseif ReadByte(emblemDoor+3) == 0xA5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xA1)
            --elseif ReadByte(emblemDoor+3) == 0xB5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xB1)
            --elseif ReadByte(emblemDoor+3) == 0xC5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xC1)
            --elseif ReadByte(emblemDoor+3) == 0xD5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xD1)
            --elseif ReadByte(emblemDoor+3) == 0xE5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xE1)
            --elseif ReadByte(emblemDoor+3) == 0xF5 then
            --    WriteByte(emblemDoor, 3)
            --    WriteByte(emblemDoor+3, 0xF1)
            --end
        end
        
        if ReadByte(room[game_version]) == 5 then
            WriteLong(theonActive[game_version], 0)
        end
    end
    
    if ReadByte(cutsceneFlags[game_version]+0xB00) == 0xDC then
        debugPrint("Section 28")
        WriteByte(gummiFlagBase[game_version]+11, 3)
    end
    
    --BEGIN SONIC AND GICU BLOCK---
    
    if ReadByte(world[game_version]) == 0x03 and ReadByte(room[game_version]) > 0x00 and ReadByte(cutsceneFlags[game_version]+0xB04) == 0x01 then --Prevent Start of TT1 Softlock
        debugPrint("Section 29")
        WriteByte(room[game_version], 0x00)
        WriteByte(warpType1[game_version], 5)
        WriteByte(warpType2[game_version], 12)
        WriteByte(warpTrigger[game_version], 0x02)
    end
    if (ReadByte(world[game_version]) ~= 0x03 or ReadByte(room[game_version]) ~= 0x16) and (ReadByte(cutsceneFlags[game_version]+0xB04) >= 0x31 and ReadByte(cutsceneFlags[game_version]+0xB04) < 0x3E) and ReadByte(cutsceneFlags[game_version]+0x312) == 1 then --Prevent Missing Earthshine after talking to Leon only once in Secret Waterway
        debugPrint("Section 30")
        WriteByte(cutsceneFlags[game_version]+0x312,0)
    end
    if ReadByte(cutsceneFlags[game_version]+0xB0A) < 0x21 then --Prevent Atlantica Sunken Ship Softlock
        debugPrint("Section 31")
        WriteByte(worldFlagBase[game_version]+0x7B, 0x0E)
    elseif ReadByte(cutsceneFlags[game_version]+0xB0A) == 0x21 then
        debugPrint("Section 32")
        WriteByte(worldFlagBase[game_version]+0x7B, 0x00)
    end
    if ReadByte(cutsceneFlags[game_version]+0xB0A) == 0x32 then --Require Crystal Trident
        debugPrint("Section 33")
        if ReadByte(inventory[game_version]+0xD1) > 0 then
            WriteByte(worldFlagBase[game_version]+0x82, 2)
        else
            WriteByte(worldFlagBase[game_version]+0x82, 0)
        end
    end
    if ReadByte(cutsceneFlags[game_version]+0xB0C) == 0x21 then --Require Forget-Me-Not
        debugPrint("Section 34")
        lab_room_address = {0x2DEBE5C, 0x2DEB45C} --changed for EGS 1.0.0.10
        if ReadByte(inventory[game_version]+0xE2) > 0 then
            WriteByte(lab_room_address[game_version], 2)
        else
            WriteByte(lab_room_address[game_version], 3)
        end
    end
    if ReadByte(world[game_version]) == 0x09 and ReadByte(room[game_version]) == 0x10 and ReadByte(cutsceneFlags[game_version]+0xB04+0x6) < 0x53 then --Prevent Ursula II Early
        debugPrint("Section 35")
        WriteByte(room[game_version], 0x02)
        WriteByte(warpType1[game_version], 5)
        WriteByte(warpType2[game_version], 12)
        WriteByte(warpTrigger[game_version], 0x02)
    end
    if ReadByte(cutsceneFlags[game_version]+0xB04+0x9) > 0x00 then --Prevent Neverland Ship: Cabin from being missable
        debugPrint("Section 36")
        neverland_warps_address = {0x2DEBC66, 0x2DEB266} --changed for EGS 1.0.0.10
        neverland_warps = ReadByte(neverland_warps_address[game_version])
        if (neverland_warps % 2) < 1 then
            WriteByte(neverland_warps_address[game_version], neverland_warps + 1)
        end
    end
    if ReadByte(world[game_version]) == 0x0F and ReadByte(room[game_version]) == 0x04 then --Prevent HB Entrance Hall Early
        debugPrint("Section 37")
        if ReadByte(unlockedWarps[game_version]+0x0142) > 0x10 and ReadByte(cutsceneFlags[game_version]+0xB0E) < 0x28 then
            WriteByte(room[game_version], 0x06)
            WriteByte(warpType1[game_version], 5)
            WriteByte(warpType2[game_version], 12)
            WriteByte(warpTrigger[game_version], 0x02)
        end
    end
    hb_library_shelves_address = {0x2DEBC0B, 0x2DEB20B} --changed for EGS 1.0.0.10
    if ReadByte(hb_library_shelves_address[game_version]) == 0 then --Fix shelves in HB library
        debugPrint("Section 38")
        WriteByte(hb_library_shelves_address[game_version], 0xF6)
    end
    hb_library_book_address = {0x2DEBC14, 0x2DEB214} --changed for EGS 1.0.0.10
    if ReadByte(hb_library_book_address[game_version]) == 0 then --Fix books in HB library
        debugPrint("Section 39")
        WriteArray(hb_library_book_address[game_version], {0x14,0x14,0x14,0x14,0x14,0x0A,0x14,0x14})
    end
    if ReadByte(cutsceneFlags[game_version]+0xB0E) == 0xA0 and ReadByte(worldFlagBase[game_version]+0xB6) == 0x0A then --Post HB1 Flags -> HB2 Flags
        debugPrint("Section 40")
        WriteInt(worldFlagBase[game_version]+0xB3, 0x0E0E0E0E)
        WriteShort(worldFlagBase[game_version]+0xB8, 0x0E0E)
        WriteShort(worldFlagBase[game_version]+0xBB, 0x0E0E)
        WriteShort(worldFlagBase[game_version]+0xC0, 0x000E)
    end
    hb_library_green_trinity_address   = {0x2DEB9DC, 0x2DEAFDC} --changed for EGS 1.0.0.10
    hb_library_green_trinity_address_2 = {0x2DEB9C9, 0x2DEAFC9} --changed for EGS 1.0.0.10
    if ReadByte(hb_library_green_trinity_address[game_version]) == 0x00 then --Fix HB Library Green Trinity
        debugPrint("Section 41")
        WriteByte(hb_library_green_trinity_address[game_version], 0x40)
        WriteByte(hb_library_green_trinity_address_2[game_version], 0x01)
    end
    if ReadByte(worldFlagsAddress[game_version] + 0x1008) == 0 then --auto grab recipe cards so you can't duplicate items in DJ experiments
        debugPrint("Section 42")
        recipe_card_offsets = {0x1003, 0x1007, 0x1008, 0x100D, 0x100E}
        for k,v in pairs(recipe_card_offsets) do
            WriteByte(worldFlagsAddress[game_version] + v, 1)
        end
    end
    if ReadByte(worldFlagsAddress[game_version]) == 0 then --Leon Gift unmissable
        debugPrint("Section 43")
        WriteByte(worldFlagsAddress[game_version], 1)
    end
end

function RoomWarp(w, r)
    WriteByte(warpType1[game_version], 5)
    WriteByte(warpType2[game_version], 10)
    WriteByte(worldWarp[game_version], w)
    WriteByte(roomWarp[game_version], r)
    WriteByte(warpTrigger[game_version], 2)
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
        --debugPrint(game_version)
        FlagFixes()
    end
end