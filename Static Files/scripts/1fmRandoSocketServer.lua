LUAGUI_NAME = "1fmRandoSocketServer"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Creates KH Server, and allows clients to interface with game"

-------------
-- Imports --
-------------
local socket         = require("socket")
local json           = require("json")
local helpers        = require("server.helpers")
local send_locations = require("server.send_locations")
local receive_items  = require("server.receive_items")
local show_prompt    = require("server.show_prompt")
local death_link     = require("server.death_link")
local synth_hints    = require("server.synth_hints")

------------------
-- Socket state --
------------------
local server = nil
local clients = {}
local server_started = false

-------------
-- Globals --
-------------
canExecute = false
game_version = 1
frame_count = 0
location_map = {}

game_state = {}
game_state.victory = false
game_state.locations = {}
game_state.world = 0
game_state.sora_koed = false
game_state.hinted_locations = {}

starting_items = {}

------------
-- Socket --
------------
function start_server()
    if server_started then return end

    server = socket.bind("127.0.0.1", 13138)
    server:settimeout(0) -- non-blocking

    server_started = true
    ConsolePrint("Socket server listening on 127.0.0.1:13138")
end

function accept_client()
    if not server_started then return end
    local c, err = server:accept()
    if c then
        c:settimeout(0)
        table.insert(clients, c)
        ConsolePrint("Client connected, total clients: " .. #clients)
    end
end

function close_client(client_index)
    c = clients[client_index]
    c:shutdown("send")
    socket.sleep(0.01)
    c:close()
    table.remove(clients, client_index)
    ConsolePrint("Client disconnected")
end

function send_message_to_client(client, message, print_msg)
    encoded_message = json.encode(message)
    client:send(encoded_message.."\n")
    if print_msg then
        ConsolePrint("Replied with: " .. encoded_message)
    end
end

function handle_message(c, line)
    if line ~= "{\"get_state\": true}" then
        ConsolePrint("Received request: " .. line)
    end

    local reply = {}
    local ok, msg = pcall(json.decode, line)
    if not ok then
        ConsolePrint("Invalid JSON")
        return
    end

    -- {"get_state": true}
    if msg.get_state then
        reply.locations = game_state.locations
        reply.victory = game_state.victory
        reply.world = game_state.world
        reply.sora_koed = game_state.sora_koed
        reply.hinted_locations = game_state.hinted_locations
    end

    -- {"items": [...]}
    if type(msg.items) == "table" then
        receive_items_from_client(msg.items)
    end

    -- {"prompt": [...]}
    if type(msg.prompt) == "table" then
        handle_prompt(msg.prompt)
    end

    -- {"effect": {...}}
    if type(msg.effect) == "table" then
        if msg.effect.heartless_angel then
            heartless_angel_sora()
        elseif msg.effect.sora_ko then
            ko_sora()
        end
    end

    -- {"adhoc_item": number}
    if type(msg.adhoc_item) == "number" then
        handle_item_received(msg.adhoc_item)
    end
    
    -- {"get_abilities": true}
    if msg.get_abilities then
        reply.abilities = read_abilities()
    end
    
    -- {"get_items": true}
    if msg.get_items then
        reply.items = read_stock()
    end
    
    -- {"get_shared_abilities": true}
    if msg.get_shared_abilities then
        reply.shared_abilities = read_shared_abilities()
    end

    send_message_to_client(c, reply, false)
end

function receive_client_data()
    for i = #clients, 1, -1 do
        local c = clients[i]
        local line, err = c:receive("*l")

        if line then
            handle_message(c, line)

        elseif err == "closed" then
            close_client(i)

        elseif err ~= "timeout" then
            ConsolePrint("Socket error: " .. tostring(err))
            close_client(i)
        end
    end
end

function set_subscriptions(c, topics)
    ensure_client_entry(c)
    local subs = client_subscriptions[c]
    -- clear existing
    for k, _ in pairs(subs) do subs[k] = nil end
    -- set new
    for _, t in ipairs(topics) do
        local nt = normalize_topic(t)
        if nt then subs[nt] = true end
    end
end

function add_subscriptions(c, topics)
    ensure_client_entry(c)
    local subs = client_subscriptions[c]
    for _, t in ipairs(topics) do
        local nt = normalize_topic(t)
        if nt then subs[nt] = true end
    end
end

function remove_subscriptions(c, topics)
    ensure_client_entry(c)
    local subs = client_subscriptions[c]
    for _, t in ipairs(topics) do
        local nt = normalize_topic(t)
        if nt then subs[nt] = nil end
    end
end

----------------------
-- Life cycle hooks --
----------------------
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
    if canExecute then
        start_server()
        location_map = fill_location_map()
        death_link_init()
    end
end

function _OnFrame()
    if canExecute then
        accept_client()
        receive_client_data()
        handle_start_inventory()
        if read_world() ~= 0 then
            frame_count = (frame_count + 1) % 60
            add_locations_to_locations_checked(frame_count)
            final_ansem_defeated()
            check_for_world_update()
            check_for_synth_shop_hints()
            get_sora_koed()
            death_link_frame()
        end
    end
end
