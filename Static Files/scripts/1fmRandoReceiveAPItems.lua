LUAGUI_NAME = "1fmRandoReceiveAPItems"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Receive AP Items"

canExecute = false
game_version = 1
initializing = true

require("globals")

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

function in_gummi_garage()
    in_gummi_address = {0x508778, 0x507C08}
    return ReadInt(in_gummi_address[game_version]) > 0
end

function get_item_by_id(item_id)
  for i = 1, #items do
    if items[i].ID == item_id then
      return items[i]
    end
  end
end

function read_check_number()
    --[[Reads the current check number]]
    gummi_address = {0x2DF5BD8, 0x2DF51D8}
    check_number_item_address = gummi_address[game_version] + 0x77
    check_number = ReadInt(check_number_item_address)
    return check_number
end

function read_start_inventory_written_byte()
    gummi_address = {0x2DF5BD8, 0x2DF51D8}
    start_inventory_written_address = gummi_address[game_version] + 0x7B
    return ReadByte(start_inventory_written_address)
end

function write_start_inventory_written_byte(val)
    gummi_address = {0x2DF5BD8, 0x2DF51D8}
    start_inventory_written_address = gummi_address[game_version] + 0x7B
    return WriteByte(start_inventory_written_address, val)
end

function read_world()
    --[[Gets the numeric value of the currently occupied world]]
    world_address = {0x2340E5C, 0x233FE84}
    return ReadByte(world_address[game_version])
end

function write_check_number(check_number)
    --[[Writes the correct number of "check" unused gummi items. Used for syncing game with server]]
    gummi_address = {0x2DF5BD8, 0x2DF51D8}
    check_number_item_address = gummi_address[game_version] + 0x77
    WriteInt(check_number_item_address, check_number)
end

function write_slides()
    write_item(217)
    write_item(218)
    write_item(219)
    write_item(220)
    write_item(221)
    write_item(222)
    slides_picked_up_array = {1,1,1,1,1,1}
    slides_picked_up_array_address = {0x2DEAF67, 0x2DEA567}
    WriteArray(slides_picked_up_array_address[game_version], slides_picked_up_array)
end

function write_shared_ability(shared_ability_value)
    --[[Writes the player's unlocked shared abilities]]
    shared_abilities_address = {0x2DEA2F8, 0x2DE98F8}
    can_add_ability = true
    current_shared_abilities_array = ReadArray(shared_abilities_address[game_version]+1,8)
    current_shared_abilities_count = {}
    max_shared_abilities = {3, 2, 1, 3}
    for current_shared_ability_index, current_shared_ability_value in pairs(current_shared_abilities_array) do
        if current_shared_abilities_count[current_shared_ability_value%128] == nil then
            current_shared_abilities_count[current_shared_ability_value%128] = 1
        else
            current_shared_abilities_count[current_shared_ability_value%128] = current_shared_abilities_count[current_shared_ability_value%128] + 1
        end
    end
    if current_shared_abilities_count[shared_ability_value] ~= nil then
        if shared_ability_value == 3 and current_shared_abilities_count[shared_ability_value] == 1 then --Handle Progressive Glide
            shared_ability_value = 4
            if current_shared_abilities_count[shared_ability_value] == nil then
                current_shared_abilities_count[shared_ability_value] = 0
            end
        end
        if current_shared_abilities_count[shared_ability_value] >= max_shared_abilities[shared_ability_value] then
            can_add_ability = false
        end
    end
    if can_add_ability then
        local i = 1
        while ReadByte(shared_abilities_address[game_version] + i) ~= 0 and i <= 10 do
            i = i + 1
        end
        if i <= 9 then
            WriteByte(shared_abilities_address[game_version] + i, shared_ability_value + 128)
        end
    end
end

function write_sora_ability(ability_value)
    --[[Grants the player a specific ability defined by the ability value]]
    abilities_address = {0x2DE9DA3, 0x2DE93A3}
    local i = 1
    while ReadByte(abilities_address[game_version] + i) ~= 0 do
        i = i + 1
    end
    if i <= 48 then
        WriteByte(abilities_address[game_version] + i, ability_value + 128)
    end
end

function write_item(item_offset)
    --[[Grants the players a specific item defined by the offset]]
    stock_address = {0x2DEA1F9, 0x2DE97F9}
    WriteByte(stock_address[game_version] + item_offset, math.min(ReadByte(stock_address[game_version] + item_offset) + 1, 99))
end

function handle_item_received(received_item_id)
    if received_item_id >= 2641000 and received_item_id < 2642000 then
        if received_item_id % 2641000 == 217 then
            write_slides()
        else
            write_item(received_item_id % 2641000)
        end
    elseif received_item_id >= 2642000 and received_item_id < 2642100 then
        write_shared_ability(received_item_id % 2642000)
    elseif received_item_id >= 2643000 and received_item_id < 2644000 then
        write_sora_ability(received_item_id % 2643000)
    end
end

function handle_start_inventory()
    if read_start_inventory_written_byte() ~= 1 then
        for item_num,item_id in pairs(starting_items) do
            handle_item_received(item_id)
        end
        write_start_inventory_written_byte(1)
    end
end

function receive_items()
    --[[Main function for receiving items from the AP server]]
    i = read_check_number() + 1
    while file_exists(client_communication_path .. "AP_" .. tostring(i) .. ".item") do
        file = io.open(client_communication_path .. "AP_" .. tostring(i) .. ".item", "r")
        io.input(file)
        received_item_id = tonumber(io.read())
        if received_item_id == nil then
            return
        end
        io.close(file)
        handle_item_received(received_item_id)
        i = i + 1
    end
    initializing = false
    write_check_number(i - 1)
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
        if not in_gummi_garage() then
            handle_start_inventory()
            receive_items()
        end
    end
end