LUAGUI_NAME = "1fmRandoFixWarps"
LUAGUI_AUTH = "Sonicshadowsilver2 and Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Fix World States when Warping Out"

local StoryProgress = {0x2DEB261, 0x2DEA861}
local stateFlag = {0x2867CD8, 0x2867364}
local DockPoints = {0x2DEBC5F, 0x2DEB25F}
local worldWarps = {0x50F9D0, 0x50AB90}
local PuppyFlag = {0x2DEAB90, 0x2DEA190}
local world = {0x2340E5C, 0x233FE84}
local room = {0x2340E5C + 0x68, 0x233FE84 + 0x8}
local party1 = {0x2DEA1EF, 0x2DE97EF}
local SephirothFlag = {0x2DEACCA, 0x2DEA2CA}
local roomFlags = {0x2DEBDE8, 0x2DEB3E8}
local EventFlag = {0x2DEBBB6, 0x2DEB1B6}
local soraHUD = {0x2812E9C, 0x281249C}
local spawn = {0x2DEBDA8, 0x2DEB3A8}

function BitOr(Address,Bit,Abs)
    WriteByte(Address,ReadByte(Address)|Bit,Abs and OnPC)
end

function BitNot(Address,Bit,Abs)
    WriteByte(Address,ReadByte(Address)&~Bit,Abs and OnPC)
end


function fix_world_states()
    if ReadByte(StoryProgress[game_version]+3) == 0x01 and ReadShort(stateFlag[game_version]) == 0x04 then --During Start of TT1
        WriteByte(StoryProgress[game_version]+3, 0x00)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x04 and ReadByte(DockPoints[game_version]+0) == 0x00 then --Start Early TT1 Tracking
        WriteByte(DockPoints[game_version]+0, 0x01)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x04 and ReadShort(stateFlag[game_version]) == 0x04 then --After Sora's Introduction to TT
        WriteInt(worldWarps[game_version]+2, 0x00050000)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x07 and ReadShort(stateFlag[game_version]) == 0x04 then --After Meeting Cid
        WriteInt(worldWarps[game_version]+2, 0x0044000A)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x0A and ReadShort(stateFlag[game_version]) == 0x04 then --Start of Heartless Attack
        WriteInt(worldWarps[game_version]+2, 0x00050000)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x14 and ReadShort(stateFlag[game_version]) == 0x04 then --After Meeting Cid
        WriteInt(worldWarps[game_version]+2, 0x0044000A)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x17 and ReadShort(stateFlag[game_version]) == 0x04 then --During Leon
        WriteInt(worldWarps[game_version]+2, 0x00050000)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x1A and ReadShort(stateFlag[game_version]) == 0x04 then --Rising Falls/Alleyway Cutscenes
        WriteInt(worldWarps[game_version]+2, 0x00210004)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x1D and ReadShort(stateFlag[game_version]) == 0x04 then --Green room Cutscene After Leon
        WriteInt(worldWarps[game_version]+2, 0x00260005)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x20 and ReadShort(stateFlag[game_version]) == 0x04 then --Green room After Leon
        WriteInt(worldWarps[game_version]+2, 0x00260005)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x23 and ReadShort(stateFlag[game_version]) == 0x04 then --Before Guard Armor
        WriteInt(worldWarps[game_version]+2, 0x00150002)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x28 and ReadShort(stateFlag[game_version]) == 0x04 then --During Guard Armor
        WriteByte(StoryProgress[game_version]+3, 0x023)
        WriteInt(worldWarps[game_version]+2, 0x00150002)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x2B and ReadShort(stateFlag[game_version]) == 0x04 then --Cutscene After Guard Armor 1
        WriteInt(worldWarps[game_version]+2, 0x00110002)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x2E and ReadShort(stateFlag[game_version]) == 0x04 then --Start of Post TT1
        WriteInt(worldWarps[game_version]+2, 0x00040000)
    end
    if ReadByte(StoryProgress[game_version]+3) == 0x31 and ReadInt(worldWarps[game_version]+2) ~= 0 then --Post TT1
        WriteInt(worldWarps[game_version]+2, 0)
    end
    if ReadByte(PuppyFlag[game_version]+0x01) == 1 and ReadByte(PuppyFlag[game_version]+0x17) == 0 then --Returned 10 Puppies
        if ReadByte(PuppyFlag[game_version]+0x0C) == 0 then --10 Puppies Reward
            WriteInt(PuppyFlag[game_version]+0x17, 1)
        end
    end
    if ReadByte(PuppyFlag[game_version]+0x02) == 1 and ReadByte(PuppyFlag[game_version]+0x17) == 0 then --Returned 20 Puppies
        if ReadByte(PuppyFlag[game_version]+0x0D) == 0 then --20 Puppies Reward
            WriteInt(PuppyFlag[game_version]+0x17, 1)
        end
    end
    if ReadByte(PuppyFlag[game_version]+0x03) == 1 and ReadByte(PuppyFlag[game_version]+0x17) == 0 then --Returned 30 Puppies
        if ReadByte(PuppyFlag[game_version]+0x0E) == 0 then --30 Puppies Reward
            WriteInt(PuppyFlag[game_version]+0x17, 1)
        end
    end
    if ReadByte(PuppyFlag[game_version]+0x04) == 1 and ReadByte(PuppyFlag[game_version]+0x17) == 0 then --Returned 40 Puppies
        if ReadByte(PuppyFlag[game_version]+0x0F) == 0 then --40 Puppies Reward
            WriteInt(PuppyFlag[game_version]+0x17, 1)
        end
    end
    if ReadByte(PuppyFlag[game_version]+0x05) == 1 and ReadByte(PuppyFlag[game_version]+0x17) == 0 then --Returned 50 Puppies
        if ReadByte(PuppyFlag[game_version]+0x10) == 0 then --50 Puppies Rewards
            WriteInt(PuppyFlag[game_version]+0x17, 1)
        end
    end
    if ReadByte(PuppyFlag[game_version]+0x06) == 1 and ReadByte(PuppyFlag[game_version]+0x17) == 0 then --Returned 60 Puppies
        if ReadByte(PuppyFlag[game_version]+0x11) == 0 then --60 Puppies Reward
            WriteInt(PuppyFlag[game_version]+0x17, 1)
        end
    end
    if ReadByte(PuppyFlag[game_version]+0x07) == 1 and ReadByte(PuppyFlag[game_version]+0x17) == 0 then --Returned 70 Puppies
        if ReadByte(PuppyFlag[game_version]+0x12) == 0 then --70 Puppies Reward
            WriteInt(PuppyFlag[game_version]+0x17, 1)
        end
    end
    if ReadByte(PuppyFlag[game_version]+0x08) == 1 and ReadByte(PuppyFlag[game_version]+0x17) == 0 then --Returned 80 Puppies
        if ReadByte(PuppyFlag[game_version]+0x13) == 0 then --80 Puppies Reward
            WriteInt(PuppyFlag[game_version]+0x17, 1)
        end
    end
    if ReadByte(PuppyFlag[game_version]+0x09) == 1 and ReadByte(PuppyFlag[game_version]+0x17) == 0 then --Returned 90 Puppies
        if ReadByte(PuppyFlag[game_version]+0x14) == 0 then --90 Puppies Reward
            WriteInt(PuppyFlag[game_version]+0x17, 1)
        end
    end
    if ReadByte(PuppyFlag[game_version]+0x0A) == 1 and ReadByte(PuppyFlag[game_version]+0x17) == 0 then --Returned 99 Puppies
        if ReadByte(PuppyFlag[game_version]+0x15) == 0 then --99 Puppies Reward
            WriteInt(PuppyFlag[game_version]+0x17, 1)
        end
    end
    if ReadByte(world[game_version]) == 0x0B and ReadShort(stateFlag[game_version]) == 0x04 then --During OC if Sora is Alone
        WriteShort(party1[game_version], 0x0201)
    end
    if ReadByte(SephirothFlag[game_version]+0x00) == 0x01 and ReadByte(SephirothFlag[game_version]+0x48) == 0x00 then --After Sephiroth Cutscene
        if ReadByte(roomFlags[game_version]+0x7D) == 0x06 and ReadShort(stateFlag[game_version]) == 0x04 then
            WriteByte(SephirothFlag[game_version]+0x00, 0x00)
        end
    end
    if ReadByte(SephirothFlag[game_version]+0x48) == 0x01 and ReadShort(stateFlag[game_version]) == 0x04 then --Cloud vs Sephiroth Cutscene
        WriteByte(SephirothFlag[game_version]+0x48, 0x00)
    end
    if ReadByte(StoryProgress[game_version]+4) < 0x0D and ReadShort(stateFlag[game_version]) == 0x04 then --During Sabor I
        WriteByte(StoryProgress[game_version]+4, 0x00)
    end
    if ReadByte(StoryProgress[game_version]+4) == 0x0D and ReadShort(stateFlag[game_version]) == 0x04 then --After Sabor I
        WriteByte(StoryProgress[game_version]+4, 0x12)
        WriteByte(DockPoints[game_version]+3, 0x01)
    end
    if ReadByte(StoryProgress[game_version]+4) == 0x12 then --After Sabor I Cutscene 2
        WriteInt(worldWarps[game_version]+0x2A, 0x00060002)
    end
    if ReadByte(StoryProgress[game_version]+4) == 0x28 then --Before Powerwilds Cutscene
        WriteInt(worldWarps[game_version]+0x2A, 0x00260001)
    end
    if ReadByte(StoryProgress[game_version]+4) == 0x2B then --Before Powerwilds
        WriteInt(worldWarps[game_version]+0x2A, 0x002D000E)
    end
    if ReadByte(StoryProgress[game_version]+4) == 0x3C and ReadShort(stateFlag[game_version]) == 0x04 then --Pre-Final Sabor Cutscene
        WriteByte(StoryProgress[game_version]+4, 0x39)
    end
    if ReadByte(StoryProgress[game_version]+4) == 0x42 and ReadShort(stateFlag[game_version]) == 0x04 then --Post Final Sabor Cutscene
        WriteByte(StoryProgress[game_version]+4, 0x3F)
        WriteShort(roomFlags[game_version]+0x25, 0x0100)
        WriteByte(roomFlags[game_version]+0x2A, 0x0D)
    end
    if ReadByte(StoryProgress[game_version]+4) == 0x53 and ReadShort(stateFlag[game_version]) == 0x04 then --During Clayton & Stealth Sneak
        WriteByte(StoryProgress[game_version]+4, 0x50)
    end
    if ReadByte(StoryProgress[game_version]+4) == 0x56 and ReadShort(stateFlag[game_version]) == 0x04 then --Post Clayton & Stealth Sneak Cutscene 1
        WriteByte(StoryProgress[game_version]+4, 0x50)
        WriteByte(roomFlags[game_version]+0x24, 0x0D)
        WriteByte(roomFlags[game_version]+0x26, 0x0D)
        WriteShort(roomFlags[game_version]+0x2F, 0x0E01)
    end
    if ReadByte(StoryProgress[game_version]+4) == 0x5C and ReadShort(stateFlag[game_version]) == 0x04 then --End of Deep Jungle
        WriteByte(StoryProgress[game_version]+4, 0x59)
    end
    if ReadByte(StoryProgress[game_version]+7) == 0x46 and ReadShort(stateFlag[game_version]) == 0x04 then --During Jafar
        WriteByte(StoryProgress[game_version]+7, 0x3F)
    end
    if ReadByte(StoryProgress[game_version]+7) == 0x53 and ReadShort(stateFlag[game_version]) == 0x04 then --After Genie Jafar Cutscene
        WriteByte(StoryProgress[game_version]+7, 0x50)
    end
    if ReadByte(StoryProgress[game_version]+8) == 0x1E and ReadShort(stateFlag[game_version]) == 0x04 then --Before Parasite Cage I
        WriteByte(StoryProgress[game_version]+8, 0x28)
    end
    if ReadByte(StoryProgress[game_version]+8) == 0x2B and ReadShort(stateFlag[game_version]) == 0x04 then --During Parasite Cage I
        WriteByte(StoryProgress[game_version]+8, 0x28)
    end
    if ReadByte(StoryProgress[game_version]+8) == 0x2E and ReadShort(stateFlag[game_version]) == 0x04 then --After Parasite Cage I
        WriteByte(StoryProgress[game_version]+8, 0x32)
        WriteInt(roomFlags[game_version]+0x81, 0x0E0E0E0E)
        WriteInt(roomFlags[game_version]+0x85, 0x0E0E000E)
        BitOr(EventFlag[game_version]+8, 0xC0)
    end
    if ReadByte(StoryProgress[game_version]+8) == 0x3C and ReadShort(stateFlag[game_version]) == 0x04 then --During Parasite Cage II
        WriteByte(StoryProgress[game_version]+8, 0x32)
    end
    if ReadByte(StoryProgress[game_version]+9) == 0x01 and ReadShort(stateFlag[game_version]) == 0x04 then --During Atlantica Tutorial
        WriteByte(StoryProgress[game_version]+9, 0x00)
    end
    if ReadByte(StoryProgress[game_version]+9) == 0x04 and ReadShort(stateFlag[game_version]) == 0x04 then --During 1st Atlantica Fight
        WriteByte(StoryProgress[game_version]+9, 0x00)
    end
    if ReadByte(StoryProgress[game_version]+9) == 0x07 and ReadShort(stateFlag[game_version]) == 0x04 then --After 1st Atlantica Fight
        WriteByte(StoryProgress[game_version]+9, 0x00)
    end
    if ReadByte(StoryProgress[game_version]+9) == 0x1E and ReadShort(stateFlag[game_version]) == 0x04 then --During Ariel's Grotto 1st Visit
        WriteByte(StoryProgress[game_version]+9, 0x14)
    end
    if ReadByte(StoryProgress[game_version]+9) == 0x50 and ReadShort(stateFlag[game_version]) == 0x04 then --During Ursula I
        WriteByte(StoryProgress[game_version]+9, 0x49)
    end
    if ReadByte(StoryProgress[game_version]+9) == 0x5A and ReadShort(stateFlag[game_version]) == 0x04 then --During Ursula II
        WriteByte(StoryProgress[game_version]+9, 0x53)
    end
    if ReadByte(StoryProgress[game_version]+9) == 0x5D and ReadShort(stateFlag[game_version]) == 0x04 then --During Ursula II's Death Cutscene
        WriteByte(StoryProgress[game_version]+9, 0x60)
        WriteByte(DockPoints[game_version]+0x46,ReadByte(DockPoints[game_version]+0x06))
        WriteByte(DockPoints[game_version]+6, 0x04)
        WriteByte(roomFlags[game_version]+0x59, 0x17)
        WriteInt(roomFlags[game_version]+0x5B, 0x17171717)
        WriteShort(roomFlags[game_version]+0x5F, 0x1717)
        WriteByte(roomFlags[game_version]+0x62, 0x17)
        WriteInt(roomFlags[game_version]+0x64, 0x06031717)
    end
    if ReadByte(world[game_version]) == 0x09 and ReadByte(room[game_version]) == 0x0F then
        if ReadByte(StoryProgress[game_version]+9) == 0x60 and ReadShort(DockPoints[game_version]+6) == 0x04 then --Triton's Palace After Ursula II
            WriteByte(DockPoints[game_version]+0x06,ReadByte(DockPoints[game_version]+0x46))
            WriteByte(DockPoints[game_version]+0x46, 0x00)
        end
    end
    if ReadByte(StoryProgress[game_version]+11) == 0x0A and ReadShort(stateFlag[game_version]) == 0x04 then --Research Lab 1st Visit
        WriteByte(StoryProgress[game_version]+11, 0x07)
    end
    if ReadByte(StoryProgress[game_version]+11) == 0x1E and ReadShort(stateFlag[game_version]) == 0x04 then --Forget-Me-Not Cutscene
        WriteByte(StoryProgress[game_version]+11, 0x21)
        WriteByte(roomFlags[game_version]+0x6D, 0x0E)
        WriteByte(roomFlags[game_version]+0x6F, 0x05)
    end
    if ReadByte(StoryProgress[game_version]+11) == 0x28 and ReadShort(stateFlag[game_version]) == 0x04 then --Research Lab 1st Visit
        WriteByte(StoryProgress[game_version]+11, 0x2B)
    end
    if ReadByte(StoryProgress[game_version]+11) == 0x50 and ReadShort(stateFlag[game_version]) == 0x04 then --During Lock, Shock, & Barrel
        WriteByte(StoryProgress[game_version]+11, 0x46)
    end
    if ReadByte(StoryProgress[game_version]+11) == 0x5C and ReadShort(stateFlag[game_version]) == 0x04 then --During Oogie Boogie
        WriteByte(StoryProgress[game_version]+11, 0x53)
    end
    if ReadByte(StoryProgress[game_version]+12) <= 0x0A and ReadShort(stateFlag[game_version]) == 0x04 then --Start of Neverland 1
        WriteByte(StoryProgress[game_version]+12, 0x00)
    end
    if ReadByte(world[game_version]) == 0x0D and ReadByte(room[game_version]) == 0x07 then --Start of Neverland 2
        if ReadByte(StoryProgress[game_version]+12) == 0x14 and ReadByte(spawn[game_version]) == 0x1C then
            if ReadShort(stateFlag[game_version]) == 0x04 and ReadInt(soraHUD[game_version]) == 0 then
                WriteByte(StoryProgress[game_version]+12, 0x00)
            elseif ReadInt(soraHUD[game_version]) > 0 then
                WriteByte(spawn[game_version], 0x25)
            end
        end
    end
    if ReadByte(StoryProgress[game_version]+12) == 0x17 or ReadByte(StoryProgress[game_version]+12) == 0x1E then --Before Anti-Sora Cutscenes
        if ReadShort(stateFlag[game_version]) == 0x04 then
            WriteByte(StoryProgress[game_version]+12, 0x14)
        end
    end
    if ReadByte(StoryProgress[game_version]+12) == 0x32 and ReadShort(stateFlag[game_version]) == 0x04 then --During Anti-Sora
        WriteByte(StoryProgress[game_version]+12, 0x28)
    end
    if ReadByte(StoryProgress[game_version]+12) == 0x3C and ReadShort(stateFlag[game_version]) == 0x04 then --Before Peter Pan Rejoins Party
        WriteByte(StoryProgress[game_version]+12, 0x38)
    end
    if ReadByte(StoryProgress[game_version]+12) == 0x46 and ReadShort(stateFlag[game_version]) == 0x04 then --Immediately After Forced Fight
        WriteByte(StoryProgress[game_version]+12, 0x3F)
    end
    if ReadByte(StoryProgress[game_version]+12) == 0x50 and ReadShort(party1[game_version]) == 0xFF08 then --Before Captain Hook
        WriteShort(party1[game_version]+1, 0x0102)
    end
    if ReadByte(StoryProgress[game_version]+12) == 0x53 and ReadShort(stateFlag[game_version]) == 0x04 then --After Captain Hook
        WriteByte(StoryProgress[game_version]+12, 0x50)
    end
    if ReadByte(StoryProgress[game_version]+12) == 0x56 and ReadByte(DockPoints[game_version]+7) < 4 then --Before Clock Tower
        BitOr(DockPoints[game_version]+7, 4)
    end
    if ReadByte(StoryProgress[game_version]+12) == 0x64 or ReadByte(StoryProgress[game_version]+12) == 0x6A then --After Clock Tower Keyhole
        if ReadShort(stateFlag[game_version]) == 0x04 then
            WriteByte(StoryProgress[game_version]+12, 0x5A)
        end
    end
    if ReadByte(stateFlag[game_version]) == 0x04 then --Hollow Bastion Waterway Switches
        if ReadByte(EventFlag[game_version]+0x43) == 0x04 then
            BitNot(EventFlag[game_version]+0x43, 0x04)
        elseif ReadByte(EventFlag[game_version]+0x43) == 0x08 then
            BitNot(EventFlag[game_version]+0x43, 0x08)
        elseif ReadByte(EventFlag[game_version]+0x43) == 0x0C then
            BitNot(EventFlag[game_version]+0x43, 0x0C)
        elseif ReadByte(EventFlag[game_version]+0x43) == 0x40 then
            BitNot(EventFlag[game_version]+0x43, 0x40)
        elseif ReadByte(EventFlag[game_version]+0x43) == 0x4C then
            BitNot(EventFlag[game_version]+0x43, 0x8C)
        elseif ReadByte(EventFlag[game_version]+0x43) == 0x4C then
            BitNot(EventFlag[game_version]+0x43, 0x8C)
        elseif ReadByte(EventFlag[game_version]+0x43) == 0x84 then
            BitNot(EventFlag[game_version]+0x43, 0x84)
        elseif ReadByte(EventFlag[game_version]+0x43) == 0x8C then
            BitNot(EventFlag[game_version]+0x43, 0x8C)
        elseif ReadByte(EventFlag[game_version]+0x43) == 0xC4 then
            BitNot(EventFlag[game_version]+0x43, 0xC4)
        elseif ReadByte(EventFlag[game_version]+0x43) == 0xCC then
            BitNot(EventFlag[game_version]+0x43, 0xCC)
        end
    end
    if ReadByte(StoryProgress[game_version]+13) == 0x28 and ReadShort(stateFlag[game_version]) == 0x04 then --During Riku
        WriteByte(StoryProgress[game_version]+13, 0x1E)
    end
    if ReadByte(world[game_version]) == 0x0F and ReadByte(room[game_version]) == 0x0B then --Ansem Possesses Riku Cutscene
        if ReadByte(StoryProgress[game_version]+13) == 0x32 and ReadShort(stateFlag[game_version]) == 0x04 then
            WriteByte(StoryProgress[game_version]+13, 0x46)
            WriteByte(roomFlags[game_version]+0xA4, 0x03)
        end
    end
    if ReadByte(world[game_version]) == 0x0F and ReadByte(room[game_version]) == 0x0E then --Maleficent & Riku/Ansem Cutscene
        if ReadByte(StoryProgress[game_version]+13) == 0x46 and ReadShort(stateFlag[game_version]) == 0x04 then
            WriteByte(StoryProgress[game_version]+13, 0x50)
        end
    end
    if ReadByte(StoryProgress[game_version]+13) == 0x50 and ReadShort(worldWarps[game_version]+0xCC) == 0x3C then --Before Maleficent
        WriteByte(worldWarps[game_version]+0xCC, 0x32)
        BitOr(DockPoints[game_version]+8, 0x08)
    end
    if ReadByte(StoryProgress[game_version]+13) == 0x5A and ReadShort(worldWarps[game_version]+0xCC) == 0x32 then --Before Dragon Maleficent
        WriteByte(worldWarps[game_version]+0xCC, 0x3C)
    end
    if ReadByte(StoryProgress[game_version]+13) == 0x82 and ReadShort(stateFlag[game_version]) == 0x04 then --After Riku/Ansem
        WriteByte(StoryProgress[game_version]+13, 0x8C)
        WriteInt(roomFlags[game_version]+0x96, 0x0A0A0A0A)
        WriteInt(roomFlags[game_version]+0x9A, 0x0A0A0A0A)
        WriteInt(roomFlags[game_version]+0x9E, 0x0A0A0A0A)
        WriteInt(roomFlags[game_version]+0xA2, 0x0A0A000A)
    end
    if ReadByte(StoryProgress[game_version]+14) == 0x32 and ReadShort(stateFlag[game_version]) == 0x04 then --During Chernabog
        WriteByte(StoryProgress[game_version]+14, 0x08)
    end
    if ReadByte(StoryProgress[game_version]+14) > 0x33 and ReadShort(stateFlag[game_version]) == 0x04 then --During Final Fights
        WriteByte(StoryProgress[game_version]+14, 0x33)
        WriteByte(roomFlags[game_version]+0xC8, 0x00)
        WriteShort(party1[game_version], 0x0201)
    end
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
        fix_world_states()
    end
end
