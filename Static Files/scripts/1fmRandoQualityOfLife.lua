-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------              by Gicu           -----
-------------------------------------------

LUAGUI_NAME = "1fmAPQualityOfLife"
LUAGUI_AUTH = "Gicu & Sonicshadowsilver2"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Bugfixes and QOL things"

game_version = 1 --1 for EGS 1.0.0.10, 2 for Steam 1.0.0.10

local canExecute = false

Now = {0x2340E5C, 0x233FE84} --changed for EGS 1.0.0.10
Items = {0x2DEA1FA, 0x2DE97FA} --changed for EGS 1.0.0.10
ChestFlags = {0x2DEA45C, 0x2DE9A5C} --changed for EGS 1.0.0.10
EventFlags = {0x2DEAB68, 0x2DEA168} --changed for EGS 1.0.0.10
RoomFlags = {0x2DEBE3E, 0x2DEB43E} --changed for EGS 1.0.0.10
CutsceneFlags = {0x2DEA760, 0x2DE9D60} --changed for EGS 1.0.0.10
KeybladeExplanation = {0x2DEAA6E, 0x2DEA06E} --changed for EGS 1.0.0.10

function BitOr(Address,Bit,Abs)
    WriteByte(Address,ReadByte(Address)|Bit,Abs and OnPC)
end

function BitNot(Address,Bit,Abs)
    WriteByte(Address,ReadByte(Address)&~Bit,Abs and OnPC)
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
       if ReadByte(EventFlags[game_version]+0x0E60) == 0x00 then --No Red Trinities Activated
           WriteByte(EventFlags[game_version]+0x0E60, 0x01) --Activated 1 Red Trinity because Secret Waterway Entrance
       end
       if ReadByte(EventFlags[game_version]+0x0EB5) == 0x01 then --Stepped on All 3 Switches in Gizmo Shop
           WriteByte(EventFlags[game_version]+0x0EB5, 0x03) --No Wait Time for the 2 Postcards
       end
       if ReadByte(Now[game_version]+0x00) == 0x04 and ReadByte(EventFlags[game_version]+0x0F06) == 0x00 then
           WriteByte(EventFlags[game_version]+0x0F06, 0xFF) --All Evidence Boxes Opened
       end
       if ReadByte(Items[game_version]+0xDE) == 0x01 and ReadByte(EventFlags[game_version]+0x00) == 0x00 then
           WriteByte(EventFlags[game_version]+0x00, 0x01) --Found Footprints
       end
       if ReadShort(EventFlags[game_version]+0x1001) == 0x0100 then --Only Shiva Belt Chest spawned
           WriteByte(EventFlags[game_version]+0x100A, 0x02)
       end
       if ReadByte(CutsceneFlags[game_version]+0x0B06) < 0x32 and ReadByte(EventFlags[game_version]+0x1008) == 0x00 and ReadByte(EventFlags[game_version]+0x0125) == 0x00 then
           WriteByte(EventFlags[game_version]+0x1008, 0x01) --Remove Olympus Coliseum Yellow Trinity before End of 1st Visit
       elseif ReadByte(CutsceneFlags[game_version]+0x0B06) >= 0x32 and ReadByte(EventFlags[game_version]+0x1008) == 0x01 and ReadByte(EventFlags[game_version]+0x0125) == 0x00 then
           WriteByte(EventFlags[game_version]+0x1008, 0x00) --Restore Olympus Coliseum Yellow Trinity after End of 1st Visit
       end
       if ReadByte(Now[game_version]+0x00) == 0x05 and ReadByte(Now[game_version]+0x68) == 0x09 and ReadByte(CutsceneFlags[game_version]+0x0B05) == 0x53 then
           WriteByte(CutsceneFlags[game_version]+0x0B05, 0x50) --Deep Jungle Clayton Softlock Fix
           WriteInt(EventFlags[game_version]+0x0F24, 0x00010101)
       end
       if ReadByte(Now[game_version]+0x00) ~= 0x0C or ReadByte(Now[game_version]+0x00) == 0x0C and ReadByte(Now[game_version]+0x68) ~= 0x0A then --Not in Monstro: Chamber 6
           if ReadByte(ChestFlags[game_version]+0xCC) == 0x00 and ReadByte(EventFlags[game_version]+0x0E6E) > 0x7F then --Activated White Trinity, Didn't Open Chest
               WriteByte(EventFlags[game_version]+0x0E63,ReadByte(EventFlags[game_version]+0x0E63)-1) --Subtract Activated White Trinities by 1
               BitNot(EventFlags[game_version]+0x0E6E, 0x80) --Respawn White Trinity in Monstro: Chamber 6
           end
       end
       if ReadByte(Items[game_version]+0xE3) > 0x00 and ReadByte(CutsceneFlags[game_version]+0x0B0C) == 0x2B and ReadByte(ChestFlags[game_version]+0x00) == 0x02 then
           WriteByte(CutsceneFlags[game_version]+0x0B0C, 0x32) --HT Story Progression after finding Jack-in-the-Box
           WriteByte(RoomFlags[game_version]+0x19, 0x05) --Boneyard Room Flag
           WriteByte(RoomFlags[game_version]+0x1E, 0x03) --Research Lab Room Flag
       end
       if ReadByte(KeybladeExplanation[game_version]) ~= 0x01 then
           WriteByte(KeybladeExplanation[game_version], 0x01)
       end
    end
end