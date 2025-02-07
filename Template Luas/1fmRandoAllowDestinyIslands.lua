LUAGUI_NAME = "1fmRandoAllowDestinyIslands"
LUAGUI_AUTH = "denho, Gicu"
LUAGUI_DESC = "Kingdom Hearts Rando Allow Landing in Destiny Islands"

canExecute = false

local inGummi = {0x50832D, 0x5075A8}
local gummiSelect = {0x507D7C, 0x50707C}
local worldWarps = {0x50F9E8, 0x50ABA8}
local unlockedWarps = {0x2DEBC5F, 0x2DEB25F}
local warpCount = {0x50FACC, 0x50AC8C}
local world = {0x2340E5C, 0x233FE84}
local room = {0x2340E5C + 0x68, 0x233FE84 + 0x8}
local stock_address = {0x2DEA1F9, 0x2DE97F9}
local room_flags_address = {0x2DEBDCC, 0x2DEB3CC}
local world_flags_address = {0x2DEAA6D, 0x2DEA06D}

function enable_di_landing()
    if ReadInt(inGummi[game_version]) > 0 then
        if ReadByte(gummiSelect[game_version]) == 3 then
            WriteShort(worldWarps[game_version], 1) -- Add DI warp
            if (ReadByte(unlockedWarps[game_version]) // 8) % 2 == 0 then
                WriteByte(unlockedWarps[game_version], math.max(ReadByte(unlockedWarps[game_version]) + 8, 9))
            end
            WriteByte(warpCount[game_version], 4)
        else
            WriteShort(worldWarps[game_version], 4) -- Revert to Wonderland
        end
    end
end

function revert_day2()
    if ReadByte(world[game_version]) ~= 1 and ReadByte(room_flags_address[game_version]+7) ~= 0 then --Not in Destiny Islands and Seashore not on Day 1
        WriteByte(room_flags_address[game_version]+7, 0)
    end
end

function kairi_gift_unmissable()
    kairi_lists_supplies_needed = world_flags_address[game_version] + 0x305
    kairi_gives_hint = world_flags_address[game_version] + 0x337
    kairi_says_youre_hopeless = world_flags_address[game_version] + 0x338
    if ReadByte(kairi_lists_supplies_needed) ~= 0 then
        WriteByte(kairi_lists_supplies_needed, 0)
    end
    if ReadByte(kairi_gives_hint) ~= 0 then
        WriteByte(kairi_gives_hint, 0)
    end
    if ReadByte(kairi_says_youre_hopeless) ~= 0 then
        WriteByte(kairi_says_youre_hopeless, 0)
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
        enable_di_landing()
        revert_day2()
        kairi_gift_unmissable()
    end
end
