LUAGUI_NAME = "1fmRandoEotWFlagFixes"
LUAGUI_AUTH = "Sonicshadowsilver2 with edits from Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Fix EotW Flags"

game_version = 1 --1 for EGS 1.0.0.10, 2 for Steam 1.0.0.10
RoomFlags = {0x2DEBE3E, 0x2DEB43E} --changed for EGS 1.0.0.10
CutsceneFlags = {0x2DEA760, 0x2DE9D60} --changed for EGS 1.0.0.10
canExecute = false

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
        if ReadByte(CutsceneFlags[game_version]+0x0B0F) == 0x08 and ReadByte(CutsceneFlags[game_version]+0x020D) == 0x00 then
            WriteByte(CutsceneFlags[game_version]+0x020D, 0x01)
            WriteByte(RoomFlags[game_version]+0x55, 0x0D)
            WriteByte(RoomFlags[game_version]+0x58, 0x0D)
            WriteByte(RoomFlags[game_version]+0x5B, 0x0D)
            WriteByte(RoomFlags[game_version]+0x5F, 0x0D)
            WriteInt(RoomFlags[game_version]+0x61, 0x0D0D0D0D)
            WriteInt(RoomFlags[game_version]+0x65, 0x0D0D0D0D)
        end
    end
end