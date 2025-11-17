LUAGUI_NAME = "1fmRandoAutoCutsceneSkip"
LUAGUI_AUTH = "KSX"
LUAGUI_DESC = "Auto Cutscene Skip"

IsEpicGLVersion = 0x3B3379
IsSteamGLVersion = 0x3B2271
IsSteamJPVersion = 0x3B2221

---------------------------
-------------------------------------------------------------------------
function _OnInit()
	if ENGINE_TYPE == "BACKEND" then
	epicgames = 0
	stmgames = 0
	stmjpgames = 0
	end
end
-------------------------------------------------------------------------
function _OnFrame()

	if ReadLong(IsEpicGLVersion) == 0x7265737563697065 and epicgames == 0 then
		epicgames = 1
		ConsolePrint("Auto Cutscene Skip (EPIC GL) - installed")
	end
	
	if ReadLong(IsSteamGLVersion) == 0x7265737563697065 and stmgames == 0 then
		stmgames = 1
		ConsolePrint("Auto Cutscene Skip (Steam GL) - installed")
	end
	
	if ReadLong(IsSteamJPVersion) == 0x7265737563697065 and stmjpgames == 0 then
		stmjpgames = 1
		ConsolePrint("Auto Cutscene Skip (Steam JP) - installed")
	end

---------- Epic Games Version
if epicgames == 1 then
WriteShort(0x1A0728, 0x9090)
end


---------- Steam Version
if stmgames == 1 then
WriteShort(0x1A2878, 0x9090)
end

---------- Steam JP Version
if stmjpgames == 1 then
WriteShort(0x1A25F8, 0x9090)
end


end