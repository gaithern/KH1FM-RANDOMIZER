LUAGUI_NAME = "1fmRandoAutoSave"
LUAGUI_AUTH = "denhonator (edited by deathofall84 and Gicu)"
LUAGUI_DESC = "Read readme for button combinations"

local lastInput = 0
local prevHUD = 0
local bossRush = false

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
end

function _OnFrame()
	if canExecute then
		if ReadByte(titlescreenpicture) == 0 then
			WriteByte(title, 1)
		end

		local input = ReadInt(inputAddress)

		if input == 3968 and lastInput ~= 3968 and ReadLong(closeMenu) == 0 then
			InstantContinue()
		end

		if input == 3872 and lastInput ~= 3872 and ReadLong(closeMenu) == 0 then
			local f = io.open("autosave.dat", "rb")
			if f ~= nil then
				WriteString(continue, f:read("*a"))
				f:close()
				ConsolePrint("Loaded autosave")
				WriteByte(closeMenu, 0)
				InstantContinue()
				WriteFloat(cam, -1.0 + ReadByte(config + 20) * 2)
				WriteFloat(cam + 4, 1.0 - ReadByte(config + 24) * 2)
			end
		end

		if input == 3848 and lastInput ~= 3848 then
			SoftReset()
		end

		lastInput = input

		-- For boss rush comment this if block out as it writes to the auto save files as well
		if ReadFloat(soraHUD) == 1 and prevHUD < 1  and not bossRush then
			local f = io.open("autosave.dat", "wb")
			f:write(ReadString(continue, 93184))
			f:close()
			ConsolePrint("Wrote autosave")
		end
		prevHUD = ReadFloat(soraHUD)
	end
end

