LUAGUI_NAME = "1fmAPSynthShopHint"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM AP Integration"

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

local canExecute = false
local world = {0x2340E5C, 0x233FE84} --changed for EGS 1.0.0.10
local room  = {0x2340E5C + 0x68, 0x233FE84 + 0x8} --changed for EGS 1.0.0.10
local spawn = {0x2DEBDA8, 0x2DEB3A8} --changed for EGS 1.0.0.10

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
    end
end
    
function _OnFrame()
    if canExecute then
        if ReadByte(world[game_version]) == 0x03 and ReadByte(room[game_version]) == 0x0B and (ReadByte(spawn[game_version]) == 0x36 or ReadByte(spawn[game_version]) == 0x34) then --In Item Workshop
            if not file_exists(client_communication_path .. "insynthshop") then
                file = io.open(client_communication_path .. "insynthshop", "w")
                io.output(file)
                io.write("")
                io.close(file)
            end
        end
    end
end