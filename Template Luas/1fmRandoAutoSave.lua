LUAGUI_NAME = "1fmRandoAutoSave"
LUAGUI_AUTH = "denhonator (edited by deathofall84 and Gicu)"
LUAGUI_DESC = "Read readme for button combinations"

local lastInput = 0
local prevHUD = 0
local autosave_count = 9
local bossRush = false
local skip_save = false

local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local function CycleAutoSaves()
    local i = autosave_count
    while i ~= 0 do
        autosave_filename = "autosave_" .. tostring(i) .. ".dat"
        rename_autosave_filename = "autosave_" .. tostring(i+1) .. ".dat"
        if i == autosave_count then
            if file_exists(autosave_filename) then
                os.remove(autosave_filename)
                ConsolePrint("Oldest autosave " .. autosave_filename .. " deleted")
            end
        else
            if file_exists(autosave_filename) then
                os.rename(autosave_filename, rename_autosave_filename)
                ConsolePrint(autosave_filename .. " renamed to " .. rename_autosave_filename)
            end
        end
        i = i - 1
    end
end

function _OnInit()
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        require("VersionCheck")
    else
        ConsolePrint("KH1 not detected, not running script")
    end
end

local function InstantContinue()
    if ReadByte(warpTrigger) == 0 then
        ConsolePrint("Instant continue trigger")
        WriteByte(warpType1, 5)
        WriteByte(warpType2, 12)
        WriteByte(warpTrigger, 2)
    end
end

local function LoadAutoSave(autosave_num)
    local f = io.open("autosave_" .. tostring(autosave_num) .. ".dat", "rb")
    if f ~= nil then
        WriteString(continue, f:read("*a"))
        f:close()
        ConsolePrint("Loaded autosave_" .. tostring(autosave_num) .. ".dat")
        WriteByte(closeMenu, 0)
        InstantContinue()
        WriteFloat(cam, -1.0 + ReadByte(config + 20) * 2)
        WriteFloat(cam + 4, 1.0 - ReadByte(config + 24) * 2)
        skip_save = true
    else
        ConsolePrint("autosave_" .. tostring(autosave_num) .. ".dat does not exist!")
    end
end

local function SoftReset()
    ConsolePrint("Soft reset")
    WriteByte(warpType1, 0)
    WriteByte(warpType2, 0)
    WriteByte(cutSceneAspect, 127)
    if ReadByte(title) == 0 then
        WriteByte(title, 1)
        WriteInt(titlescreenamvtimer, 0)
    end
    WriteByte(warpTrigger, 2)
    WriteLong(closeMenu, 0)
    WriteInt(titlescreenamvtimer, 0)
    skip_save = true
end

function _OnFrame()
    if canExecute then
        if ReadByte(titlescreenpicture) == 0 then
            WriteByte(title, 1)
        end

        local input = ReadInt(inputAddress)

        if input == 0xF10 and lastInput ~= 0xF10 and ReadLong(closeMenu) == 0 then
            LoadAutoSave(1)
        end
        
        if input == 0xF20 and lastInput ~= 0xF20 and ReadLong(closeMenu) == 0 then
            LoadAutoSave(2)
        end
        
        if input == 0xF40 and lastInput ~= 0xF40 and ReadLong(closeMenu) == 0 then
            LoadAutoSave(3)
        end
        
        if input == 0xF80 and lastInput ~= 0xF80 and ReadLong(closeMenu) == 0 then
            LoadAutoSave(4)
        end

        if input == 3848 and lastInput ~= 3848 then
            SoftReset()
        end

        lastInput = input

        -- For boss rush comment this if block out as it writes to the auto save files as well
        if ReadFloat(soraHUD) == 1 and prevHUD < 1  and not bossRush then
            if not skip_save then
                CycleAutoSaves()
                autosave_filename = "autosave_1.dat"
                local f = io.open(autosave_filename, "wb")
                f:write(ReadString(continue, 93184))
                f:close()
                ConsolePrint("Wrote autosave to " .. autosave_filename)
            else
                skip_save = false
            end
        end
        prevHUD = ReadFloat(soraHUD)
    end
end

