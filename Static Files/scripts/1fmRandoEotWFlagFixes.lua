LUAGUI_NAME = "1fmRandoEotWFlagFixes"
LUAGUI_AUTH = "Sonicshadowsilver2 with edits from Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Fix EotW Flags"

canExecute = false

function _OnInit()
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        require("VersionCheck")
    else
        ConsolePrint("KH1 not detected, not running script")
    end
end

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return t
end

function _OnFrame()
    if canExecute then
        --Sonicshadowsilver2 block
        if ReadByte(enableRC+0xC9B) == 0x08 and ReadByte(enableRC+0x399) == 0x00 then
            WriteByte(enableRC+0x399, 0x01)
            WriteByte(worldFlagBase-0x1D, 0x0D)
            WriteByte(worldFlagBase-0x1A, 0x0D)
            WriteByte(worldFlagBase-0x17, 0x0D)
            WriteByte(worldFlagBase-0x13, 0x0D)
            WriteInt(worldFlagBase-0x11, 0x0D0D0D0D)
            WriteInt(worldFlagBase-0xD, 0x0D0D0D0D)
        end
        
        --End of the World World Terminus Hollow Bastion Chest Unmissable
        eotw_wt_hb_chest_bit = toBits(ReadByte(chestsOpened+0x190))[1]
        eotw_hb_portal_changed_to_chernabog_pit_byte = ReadByte(gummiFlagBase-0x8)
        eotw_hb_portal_changed_to_chernabog_pit = toBits(eotw_hb_portal_changed_to_chernabog_pit_byte)[7]
        if eotw_wt_hb_chest_bit == nil then
            eotw_wt_hb_chest_bit = 0
        end
        if eotw_hb_portal_changed_to_chernabog_pit == nil then
            eotw_hb_portal_changed_to_chernabog_pit = 0
        end
        if eotw_wt_hb_chest_bit == 0 and eotw_hb_portal_changed_to_chernabog_pit == 1 then
            if ReadByte(world) ~= 0x10 then
                WriteByte(gummiFlagBase-0x8, eotw_hb_portal_changed_to_chernabog_pit_byte + 0x40)
            end
        end
    end
end