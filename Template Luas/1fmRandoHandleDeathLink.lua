-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------             by Gicu            -----
-------------------------------------------

LUAGUI_NAME = "1fmRandoHandleDeathLink"
LUAGUI_AUTH = "Denho and Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Handle Death Link"

game_version = 1 --1 for EGS 1.0.0.10, 2 for Steam 1.0.0.10

if os.getenv('LOCALAPPDATA') ~= nil then
    client_communication_path = os.getenv('LOCALAPPDATA') .. "\\KH1FM\\"
else
    client_communication_path = os.getenv('HOME') .. "/KH1FM/"
    ok, err, code = os.rename(client_communication_path, client_communication_path)
    if not ok and code ~= 13 then
        os.execute("mkdir " .. path)
    end
end



local extraSafety = false
local revertCode = false
local removeWhite = 0
local lastDeathPointer = 0
local soraHUD = {0x2812E9C, 0x281249C} --changed for EGS 1.0.0.10
local soraHP = {0x2D5D64C, 0x2D5CC4C} --changed for EGS 1.0.0.10
local stateFlag = {0x2867CD8, 0x2867364} --changed for EGS 1.0.0.10 (may need to look into steam)
local deathCheck = {0x299F20, 0x29C0B0} --changed BOTH 1.0.0.10
local whiteFade = {0x234081C, 0x233FE1C} --changed for EGS 1.0.0.10
local blackFade = {0x4DD3F8, 0x4DC718}
local deathPointer = {0x2398838, 0x2382568} --changed for EGS 1.0.0.10

local canExecute = false
local donald_death_link = false
local goofy_death_link = false
local death_link = false
last_death_time = 0
sora_hp_address_base = {0x2DE9D60, 0x2DE9360} --changed for EGS 1.0.0.10
soras_hp_address = {0x2DE9D60 + 0x5, 0x2DE9360 + 0x5} --changed for EGS 1.0.0.10
donalds_hp_address = {0x2DE9D60 + 0x5 + 0x74, 0x2DE9360 + 0x5 + 0x74} --changed for EGS 1.0.0.10
goofys_hp_address = {0x2DE9D60 + 0x5 + 0x74 + 0x74, 0x2DE9360 + 0x5 + 0x74 + 0x74} --changed for EGS 1.0.0.10
soras_last_hp = 100

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
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
    else
        ConsolePrint("KH1 not detected, not running script")
    end
    lastDeathPointer = ReadLong(deathPointer[game_version])
    if file_exists(client_communication_path .. "dlreceive") then
        file = io.open(client_communication_path .. "dlreceive")
        io.input(file)
        death_time = tonumber(io.read())
        if death_time ~= nil then
            last_death_time = death_time
        end
        io.close(file)
    end
    soras_last_hp = ReadByte(soraHP[game_version])
end

function _OnFrame()
    if not canExecute then
        goto done
    end
    -- Remove white screen on death (it bugs out this way normally)
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
            WriteByte(soraHP[game_version], 0)
            WriteByte(soras_hp_address[game_version], 0)
            WriteByte(stateFlag[game_version], 1)
            WriteShort(deathCheck[game_version], 0x9090)
            revertCode = true
        end
    end
    if donald_death_link then
        if ReadByte(donalds_hp_address[game_version]) == 0 and ReadByte(soras_hp_address[game_version]) > 0 then
            ConsolePrint("Donald was defeated!")
            WriteByte(soraHP[game_version], 0)
            WriteByte(soras_hp_address[game_version], 0)
            WriteByte(stateFlag[game_version], 1)
            WriteShort(deathCheck[game_version], 0x9090)
            revertCode = true
        end
    end
    
    if death_link then
        if file_exists(client_communication_path .. "dlreceive") then
            file = io.open(client_communication_path .. "dlreceive")
            io.input(file)
            death_time = tonumber(io.read())
            io.close(file)
            if death_time ~= nil and last_death_time ~= nil then
                if ReadFloat(soraHUD[game_version]) > 0 and ReadByte(soraHP[game_version]) > 0 and ReadByte(blackFade[game_version])==128 and ReadShort(deathCheck[game_version]) == 0x2E74 and death_time >= last_death_time + 3 then
                    WriteByte(soraHP[game_version], 0)
                    WriteByte(stateFlag[game_version], 1)
                    WriteShort(deathCheck[game_version], 0x9090)
                    revertCode = true
                    last_death_time = death_time
                    soras_last_hp = 0
                end
            end
        end
    
        if ReadByte(soras_hp_address[game_version]) == 0 and soras_last_hp > 0 then
            ConsolePrint("Sending death")
            ConsolePrint("Sora's HP: " .. tostring(ReadByte(soras_hp_address[game_version])))
            ConsolePrint("Sora's Last HP: " .. tostring(soras_last_hp))
            death_date = os.date("!%Y%m%d%H%M%S")
            if not file_exists(client_communication_path .. "dlsend" .. tostring(death_date)) then
                file = io.open(client_communication_path .. "dlsend" .. tostring(death_date), "w")
                io.output(file)
                io.write("")
                io.close(file)
            end
        end
    end
    soras_last_hp = ReadByte(soras_hp_address[game_version])
    ::done::
end