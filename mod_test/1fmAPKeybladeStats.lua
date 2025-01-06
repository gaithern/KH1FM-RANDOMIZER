-----------------------------------
------ Kingdom Hearts 1 FM AP -----
------         by Gicu        -----
-----------------------------------

LUAGUI_NAME = "1fmAPKeybladeStats"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

game_version = 1 --1 for EGS 1.0.0.10, 2 for Steam 1.0.0.10

local keyblade_stats_base_address = {0x2D2CC38, 0x2D2C238} --changed for EGS 1.0.0.10

local canExecute = false
local finished = false
frame_count = 0

if os.getenv('LOCALAPPDATA') ~= nil then
    client_communication_path = os.getenv('LOCALAPPDATA') .. "\\KH1FM\\"
else
    client_communication_path = os.getenv('HOME') .. "/KH1FM/"
    ok, err, code = os.rename(client_communication_path, client_communication_path)
    if not ok and code ~= 13 then
        os.execute("mkdir " .. path)
    end
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function read_keyblade_stats()
    if file_exists(client_communication_path .. "keyblade_stats.cfg") then
        file = io.open(client_communication_path .. "keyblade_stats.cfg", "r")
        io.input(file)
        keyblade_stats = split(io.read(),",")
        io.close(file)
        return keyblade_stats
    elseif file_exists(client_communication_path .. "Keyblade Stats.cfg") then
        file = io.open(client_communication_path .. "Keyblade Stats.cfg", "r")
        io.input(file)
        keyblade_stats = split(io.read(),",")
        io.close(file)
        return keyblade_stats
    else
        return nil
    end
end

function write_keyblade_stats(keyblade_stats)
    i = 1
    j = 0
    while i <= #keyblade_stats do
        str = tonumber(keyblade_stats[i])
        mp  = tonumber(keyblade_stats[i+1])
        WriteByte(keyblade_stats_base_address[game_version] + (0x58 * j) + 0x30, str)
        WriteByte(keyblade_stats_base_address[game_version] + (0x58 * j) + 0x38, mp)
        i = i + 2
        j = j + 1
    end
end

function give_dream_weapons()
    inventory_address = {0x2DEA1F9, 0x2DE97F9} --changed for EGS 1.0.0.10
    WriteArray(inventory_address[game_version] + 82, {1,1,1})
end

function main()
    keyblade_stats = read_keyblade_stats()
    if keyblade_stats ~= nil and not finished then
        write_keyblade_stats(keyblade_stats)
        finished = true
    end
    give_dream_weapons()
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
    if frame_count == 0 and canExecute then
        main()
    end
    frame_count = (frame_count + 1) % 30
end