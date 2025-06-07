LUAGUI_NAME = "1fmRandoClockTowerDoors"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Make Clock Tower Doors Accessible"

canExecute = false

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    while #t < 8 do
        t[#t+1] = 0
    end
    return t
end

function _OnInit()
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        require("VersionCheck")
    else
        ConsolePrint("KH1 not detected, not running script")
    end
end

function _OnFrame()
    if canExecute then
        if ReadByte(world) == 0xD and ReadByte(room) == 0x9 then
            if ReadByte(terminusTeleUsable + 0x10) == 0x0 then
                WriteByte(terminusTeleUsable + 0x10, 0x1)
            end
            clock_tower_doors_opened_bytes = ReadArray(worldFlagBase - 0x2EF, 2)
            clock_tower_doors_bits_1 = toBits(clock_tower_doors_opened_bytes[1])
            clock_tower_doors_bits_2 = toBits(clock_tower_doors_opened_bytes[2])
            clock_tower_doors_bits = {
                clock_tower_doors_bits_1[8],
                clock_tower_doors_bits_1[7],
                clock_tower_doors_bits_1[6],
                clock_tower_doors_bits_1[5],
                clock_tower_doors_bits_1[4],
                clock_tower_doors_bits_1[3],
                clock_tower_doors_bits_1[2],
                clock_tower_doors_bits_1[1],
                clock_tower_doors_bits_2[8],
                clock_tower_doors_bits_2[7],
                clock_tower_doors_bits_2[6],
                clock_tower_doors_bits_2[5]}
            for door_num, door_opened in pairs(clock_tower_doors_bits) do
                if door_opened == 0 then
                    WriteByte(terminusTeleUsable - 0x10, door_num % 12)
                    break
                end
            end
        end
    end
end