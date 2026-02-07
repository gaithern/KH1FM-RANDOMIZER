LUAGUI_NAME = "1fmRandoSendSynthShopHints"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Send Synth Shop Hints"

canExecute = false
game_version = 1

local world = {0x2340E5C, 0x233FE84}
local room  = {0x2340E5C + 0x68, 0x233FE84 + 0x8}
local spawn = {0x2DEBDA8, 0x2DEB3A8}

world_flags_address = {0x2DEAA6D, 0x2DEA06D}

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

function send_synth_shop_hints()
    synth_level_offset = 0xCC3
    synth_hints = {}
    synth_level = ReadByte(world_flags_address[game_version] + synth_level_offset)
    local i = 1
    while i <= 6 * (math.min(synth_level, 4) + 1) do
        table.insert(synth_hints, 2656400 + i)
        i = i + 1
    end
    if synth_level == 5 then
        table.insert(synth_hints, 2656431)
        table.insert(synth_hints, 2656432)
        table.insert(synth_hints, 2656433)
    end
    for k,v in pairs(synth_hints) do
        send_hint(v)
    end
end

function send_hint(location_id)
    if not file_exists(client_communication_path .. "hint" .. tostring(location_id)) then
        file = io.open(client_communication_path .. "hint" .. tostring(location_id), "w")
        io.output(file)
        io.write("")
        io.close(file)
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
        if ReadByte(world[game_version]) == 0x03 and ReadByte(room[game_version]) == 0x0B and (ReadByte(spawn[game_version]) == 0x36 or ReadByte(spawn[game_version]) == 0x34) then
            send_synth_shop_hints()
        end
    end
end