LUAGUI_NAME = "1fmRandoAtlanticaClamsInBattleAndLocking"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Allows opening clams in battle if interact in battle is on and handles keyblade locking of clams."

local open_in_battle = false
local keyblade_locking = false

function getMaxNumericKey(t)
    local maxKey = 0 -- Initialize with 0 or -math.huge if keys can be negative

    -- Iterate over all key-value pairs
    for key, _ in pairs(t) do
        -- Check if the key is a number
        if type(key) == 'number' then
            if key > maxKey then
                maxKey = key
            end
        end
    end
    return maxKey
end

function toHexString(num)
    -- Ensure the input is an integer
    if type(num) ~= 'number' or math.floor(num) ~= num then
        error("Input must be an integer.")
    end

    -- Lua 5.3+ has string.format with %x for hexadecimal conversion
    if _VERSION >= "Lua 5.3" then
        return string.format("0x%x", num)
    else
        -- For older Lua versions (5.1, 5.2), a manual conversion might be needed,
        -- or you can use a bitwise library if available.
        -- This is a simple manual implementation for non-negative integers.
        if num < 0 then
            error("Negative numbers not supported in this manual hex conversion for Lua < 5.3.")
        end

        local hexChars = {
            [0]="0", [1]="1", [2]="2", [3]="3", [4]="4", [5]="5", [6]="6", [7]="7",
            [8]="8", [9]="9", [10]="a", [11]="b", [12]="c", [13]="d", [14]="e", [15]="f"
        }
        local hexString = ""
        if num == 0 then
            hexString = "0"
        end
        while num > 0 do
            local remainder = num % 16
            hexString = hexChars[remainder] .. hexString
            num = math.floor(num / 16)
        end
        return "0x" .. hexString
    end
end

function populate_clam_interaction_dictionary()
    local clam_interaction_dictionary = {}
    
    clam_interaction_dictionary[1] = {
        0x4909,
        0x66cd,
        0x6c99,
        0x6e41,
        0x7429,
        0x75d1,
        0x7bb9,
        0x7d61,
        0x8349,
        0x84f1,
        0x8abd,
        0x8c65,
        0x930d,
        0x48a5,
        0x6669,
        0x6c35,
        0x6ddd,
        0x73c5,
        0x756d,
        0x7b55,
        0x7cfd,
        0x82e5,
        0x848d,
        0x8a59,
        0x8c01,
        0x92a9,
        0x4909,
        0x4ed5,
        0x507d,
        0x5665,
        0x580d,
        0x5df5,
        0x5f9d,
        0x6585,
        0x672d,
        0x6cf9,
        0x6ea1,
        0x7549,
        0x493d,
        0x6701,
        0x6ccd,
        0x6e75,
        0x745d,
        0x7605,
        0x7bed,
        0x7d95,
        0x837d,
        0x8525,
        0x8af1,
        0x8c99,
        0x9341,
        0x4c55,
        0x5221,
        0x53c9,
        0x59b1,
        0x5b59,
        0x6141,
        0x62e9,
        0x68d1,
        0x6a79,
        0x7045,
        0x71ed,
        0x7895,
        0x48a5,
        0x6669,
        0x6c35,
        0x6ddd,
        0x73c5,
        0x756d,
        0x7b55,
        0x7cfd,
        0x82e5,
        0x848d,
        0x8a59,
        0x8c01,
        0x92a9,
        0x48a5,
        0x6669,
        0x6c35,
        0x6ddd,
        0x73c5,
        0x756d,
        0x7b55,
        0x7cfd,
        0x82e5,
        0x848d,
        0x8a59,
        0x8c01,
        0x92a9
    }

    clam_interaction_dictionary[4] = {
        0x4a0d,
        0x4add,
        0x50a9,
        0x5251,
        0x5919,
        0x496d,
        0x4a3d,
        0x5009,
        0x51b1,
        0x5879,
        0x49a9,
        0x4a79,
        0x5045,
        0x51ed,
        0x58b5,
        0x496d,
        0x4a3d,
        0x5009,
        0x51b1,
        0x5879,
        0x49a5,
        0x6289,
        0x6855,
        0x69fd,
        0x70c5,
        0x4971,
        0x6255,
        0x6821,
        0x69c9,
        0x7091,
        0x496d,
        0x4a3d,
        0x5009,
        0x51b1,
        0x5879,
        0x5271,
        0x6b55,
        0x7121,
        0x72c9,
        0x7991,
        0x496d,
        0x4a3d,
        0x5009,
        0x51b1,
        0x5879
    }

    clam_interaction_dictionary[5] = {
        0x4a05,
        0x4ba5,
        0x4ad1,
        0x4c71,
        0x4a9d,
        0x4c3d,
        0x4a05,
        0x4ba5,
        0x4a05,
        0x4ba5,
        0x4a05,
        0x4ba5
    }

    clam_interaction_dictionary[6] = {
        0x494d,
        0x4f19,
        0x4881,
        0x4e4d,
        0x4919,
        0x4ee5,
        0x4881,
        0x4e4d
    }

    clam_interaction_dictionary[7] = {
        0x5881,
        0x4979,
        0x4979,
        0x4a59,
        0x57d9,
        0x49ad,
        0x4dbd,
        0x4979
    }

    clam_interaction_dictionary[8] = {
        0x5945,
        0x59d5,
        0x5fbd,
        0x491d,
        0x49ad,
        0x4f95,
        0x491d,
        0x49ad,
        0x4f95,
        0x491d,
        0x49ad,
        0x4f95,
        0x49d9,
        0x4a69,
        0x5051,
        0x49a5,
        0x4a35,
        0x501d,
        0x491d,
        0x49ad,
        0x4f95,
        0x491d,
        0x49ad,
        0x4f95
    }

    clam_interaction_dictionary[11] = {
        0x4fc9,
        0x55b1,
        0x4f95,
        0x557d,
        0x4efd,
        0x54e5
    }

    clam_interaction_dictionary[13] = {
        0x5b91,
        0x6a59,
        0x49ad,
        0x5875,
        0x4a21,
        0x58e9,
        0x87e5,
        0x96ad,
        0x4af1,
        0x59b9,
        0x49f5,
        0x58bd
    }

    clam_interaction_dictionary[14] = {
        0x64ad,
        0x4ea9,
        0x49b9,
        0x8159,
        0x753d,
        0x4985
    }

    clam_interaction_dictionary[15] = {
        0x49cd,
        0x4a5d,
        0x5045,
        0x51ed,
        0x57b9,
        0x5961,
        0x5f2d,
        0x60d5,
        0x677d,
        0x4a99,
        0x4b29,
        0x5111,
        0x52b9,
        0x5885,
        0x5a2d,
        0x5ff9,
        0x61a1,
        0x6849,
        0x4bcd,
        0x4c5d,
        0x5245,
        0x53ed,
        0x59b9,
        0x5b61,
        0x612d,
        0x62d5,
        0x697d,
        0x49cd,
        0x4a5d,
        0x5045,
        0x51ed,
        0x57b9,
        0x5961,
        0x5f2d,
        0x60d5,
        0x677d,
        0x49cd,
        0x4a5d,
        0x5045,
        0x51ed,
        0x57b9,
        0x5961,
        0x5f2d,
        0x60d5,
        0x677d,
        0x49cd,
        0x4a5d,
        0x5045,
        0x51ed,
        0x57b9,
        0x5961,
        0x5f2d,
        0x60d5,
        0x677d
    }
    return clam_interaction_dictionary
end

local clam_interaction_dictionary = populate_clam_interaction_dictionary()

local normal = {0x36, 0x01, 0x00, 0x18}
local battle = {0x00, 0x00, 0x00, 0x09}
local unable = {0x01, 0x00, 0x00, 0x09}

local scene = nil
local crabclaw_address = nil

local current_world    = 0x0
local current_room     = 0x0
local current_scene    = 0x0
local current_crabclaw = 0x0

function update_bytes()
    current_world = ReadByte(world)
    current_room = ReadByte(room)
    current_scene = ReadByte(scene)
    current_crabclaw = ReadByte(crabclaw_address)
    
    local evdl_address = GetPointer(evdlPointer)
    
    local bytes_to_write = {}
    if keyblade_locking and current_crabclaw == 0 then
        bytes_to_write = unable
    elseif open_in_battle then
        bytes_to_write = battle
    else
        bytes_to_write = normal
    end
    
    local scene_array = clam_interaction_dictionary[current_room + 1]
    if scene_array == nil then
        return
    end
    
    for offset_num, offset in pairs(scene_array) do
        local current_bytes = ReadArray(evdl_address + offset, 4, true)
        if current_bytes[1] == 0x36 and current_bytes[2] == 0x01 and current_bytes[3] == 0x00 and current_bytes[4] == 0x18 then
            WriteArray(evdl_address + offset, bytes_to_write, true)
        elseif current_bytes[1] == 0x00 and current_bytes[2] == 0x00 and current_bytes[3] == 0x00 and current_bytes[4] == 0x09 then
            WriteArray(evdl_address + offset, bytes_to_write, true)
        elseif current_bytes[1] == 0x01 and current_bytes[2] == 0x00 and current_bytes[3] == 0x00 and current_bytes[4] == 0x09 then
            WriteArray(evdl_address + offset, bytes_to_write, true)
        end
    end
end

function _OnInit()
    if GAME_ID == 0xAF71841E and ENGINE_TYPE == "BACKEND" then
        require("VersionCheck")
        if canExecute then
            scene = room + 0x4
            crabclaw_address = inventory - 0x1 + 0x5A
        end
    else
        ConsolePrint("KH1 not detected, not running script")
    end
end

function _OnFrame()
    if canExecute then
        if ReadByte(world) == 0x09 then -- In Atlantica
            update_bytes()
        end
    end
end