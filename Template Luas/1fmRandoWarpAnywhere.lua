LUAGUI_NAME = "1fmRandoWarpAnywhere"
LUAGUI_AUTH = "denhonator (edited by deathofall84)"
LUAGUI_DESC = "Read readme for button combinations"

local addgummi = 0
local lastInput = 0

function _OnInit()
	if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
		require("VersionCheck")
	else
		ConsolePrint("KH1 not detected, not running script")
	end
end

function _OnFrame()
	if canExecute then
		if ReadByte(titlescreenpicture) == 0 then
			WriteByte(title, 1)
		end

		local input = ReadInt(inputAddress)
		local savemenuopen = ReadByte(saveOpenAddress)

		if input == 1793 and lastInput ~= 1793 and savemenuopen ~=4 and ReadByte(saveAnywhere) == 0 then
			WriteByte(saveAnywhere, 1)
			addgummi = 5
		elseif input == 1793 and ReadByte(saveAnywhere) == 1 then
			WriteLong(closeMenu, 0)
		end

		if savemenuopen == 4 and addgummi==1 then
			WriteByte(menuFunction, 3) --Unlock gummi
			WriteByte(menuButtonCount, 5) --Set 5 buttons to save menu
			WriteByte(menuMaxButtonCount, 5) --Set 5 buttons to save menu
			WriteByte(menuItemSlotCount, 5) --Set 5 buttons to save menu
			for i=0,4 do
				WriteByte(buttonTypes + i * 4, i) --Set button types
			end
		end

		addgummi = addgummi > 0 and addgummi-1 or addgummi

		lastInput = input
	end
end

