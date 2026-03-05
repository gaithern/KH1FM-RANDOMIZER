LUAGUI_NAME = "1fmRandoClient"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Client"

local AP             = require("lua-apclientpp")
local json           = require("json")
local globals        = require("globals")
local helpers        = require("client.helpers")
local send_locations = require("client.send_locations")
local receive_items  = require("client.receive_items")
local show_prompt    = require("client.show_prompt")
local death_link     = require("client.death_link")
local synth_hints    = require("client.synth_hints")

-- AP globals
local game_name = "Kingdom Hearts"
local items_handling = 3  -- full remote except start inventory
local client_version = {1, 0, 7}  -- optional, defaults to lib version
local message_format = AP.RenderFormat.TEXT
local ap = nil

-- Connection string data
local last_json_data = ""

-- Game state data
game_state = {}
game_state.victory = false
game_state.locations = {}
game_state.world = 0
game_state.sora_koed = false
game_state.hinted_locations = {}
game_state.items_received = {}
game_state.remote_location_ids = {}

function CheckForConnectionFile()
    local path = "ap_connection_info.json"
    local file = io.open(path, "r")
    
    if file then
        local content = file:read("*all")
        file:close()
        
        -- Only trigger if the file content actually changed and isn't empty
        if content ~= last_json_data and content ~= "{}" and content ~= "" then
            last_json_data = content
            local status, data = pcall(json.decode, content)
            
            if status and data and data.host and data.slot then
                ConsolePrint("C++ DLL triggered connection for: " .. data.slot)
                connect(data.host, data.slot, data.password or "")
            end
        end
    end
end

function connect(server, slot, password)
    function on_socket_connected()
        ConsolePrint("Socket connected")
    end

    function on_socket_error(msg)
        ConsolePrint("Socket error: " .. msg)
    end

    function on_socket_disconnected()
        ConsolePrint("Socket disconnected")
        game_state.remote_location_ids = slot_data.remote_location_ids
        game_state.items_received = {}
    end

    function on_room_info()
        ConsolePrint("Room info")
        ap:ConnectSlot(slot, password, items_handling, {"Lua-APClientPP"}, client_version)
    end

    function on_slot_connected(slot_data)
        ConsolePrint("Slot connected")
        game_state.remote_location_ids = slot_data.remote_location_ids
        game_state.items_received = {}
        ap:ConnectUpdate(nil, {"Lua-APClientPP"})
    end


    function on_slot_refused(reasons)
        ConsolePrint("Slot refused: " .. table.concat(reasons, ", "))
    end

    function on_items_received(items)
        ConsolePrint("Items received:")
        for _, item in ipairs(items) do
            local item_id = item.item
            local location_id = item.location
            local sender_id = item.player
            local player_id = ap:get_player_number()
            ConsolePrint("Item ID:     " .. tostring(item_id))
            ConsolePrint("Location ID: " .. tostring(location_id))
            ConsolePrint("Sender ID:   " .. tostring(sender_id))
            ConsolePrint("Player ID:   " .. tostring(player_id))
            if player_id == sender_id and contains_item(gl_slot_data.remote_location_ids, location_id) then
                ConsolePrint("Would receive remote item from self " .. tostring(item_id))
                table.insert(game_state.items_received, item_id)
            elseif player_id ~= sender_id then
                ConsolePrint("Would receive remote item from someone else " .. tostring(item_id))
                table.insert(game_state.items_received, item_id)
            else
                ConsolePrint("Would not receive local item " .. tostring(item_id))
            end
        end
    end

    function on_location_info(items)
        ConsolePrint("Locations scouted:")
        for _, item in ipairs(items) do
            ConsolePrint(item.item)
        end
    end

    function on_location_checked(locations)
        ConsolePrint("Locations checked:" .. table.concat(locations, ", "))
        ConsolePrint("Checked locations: " .. table.concat(ap.checked_locations, ", "))
    end

    function on_data_package_changed(data_package)
        ConsolePrint("Data package changed:")
        ConsolePrint(data_package)
    end

    function on_print(msg)
        ConsolePrint(msg)
    end

    function on_print_json(msg, extra)
        ConsolePrint(ap:render_json(msg, message_format))
        for key, value in pairs(extra) do
            -- ConsolePrint("  " .. key .. ": " .. tostring(value))
        end
    end

    function on_bounced(bounce)
        ConsolePrint("Bounced:")
        ConsolePrint(bounce)
    end

    function on_retrieved(map, keys, extra)
        ConsolePrint("Retrieved:")
        -- since lua tables won't contain nil values, we can use keys array
        for _, key in ipairs(keys) do
            ConsolePrint("  " .. key .. ": " .. tostring(map[key]))
        end
        -- extra will include extra fields from Get
        ConsolePrint("Extra:")
        for key, value in pairs(extra) do
            ConsolePrint("  " .. key .. ": " .. tostring(value))
        end
        -- both keys and extra are optional
    end

    function on_set_reply(message)
        ConsolePrint("Set Reply:")
        for key, value in pairs(message) do
            ConsolePrint("  " .. key .. ": " .. tostring(value))
            if key == "value" and type(value) == "table" then
                for subkey, subvalue in pairs(value) do
                    ConsolePrint("    " .. subkey .. ": " .. tostring(subvalue))
                end
            end
        end
    end


    local uuid = ""
    ap = AP(uuid, game_name, server);

    ap:set_socket_connected_handler(on_socket_connected)
    ap:set_socket_error_handler(on_socket_error)
    ap:set_socket_disconnected_handler(on_socket_disconnected)
    ap:set_room_info_handler(on_room_info)
    ap:set_slot_connected_handler(on_slot_connected)
    ap:set_slot_refused_handler(on_slot_refused)
    ap:set_items_received_handler(on_items_received)
    ap:set_location_info_handler(on_location_info)
    ap:set_location_checked_handler(on_location_checked)
    ap:set_data_package_changed_handler(on_data_package_changed)
    ap:set_print_handler(on_print)
    ap:set_print_json_handler(on_print_json)
    ap:set_bounced_handler(on_bounced)
    ap:set_retrieved_handler(on_retrieved)
    ap:set_set_reply_handler(on_set_reply)
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
        CheckForConnectionFile()
        handle_start_inventory()
        if read_world() ~= 0 then
            frame_count = (frame_count + 1) % 60
            add_locations_to_locations_checked(frame_count)
            final_ansem_defeated()
            game_state.world = read_world()
            check_for_synth_shop_hints()
            get_sora_koed()
            death_link_frame()
            receive_items_from_client(game_state.items_received)
        end
        if ap then
            ap:LocationChecks(game_state.locations)
            ap:LocationScouts(game_state.hinted_locations)
            ap:poll()
        end
    end
end
