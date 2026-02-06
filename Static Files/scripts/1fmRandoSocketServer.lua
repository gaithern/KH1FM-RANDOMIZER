LUAGUI_NAME = "1fmRandoSocketServer"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Creates KH Server, and allows clients to interface with game"

local socket         = require("socket")
local json           = require("json")
local helpers        = require("server.helpers")
local send_locations = require("server.send_locations")
local receive_items  = require("server.receive_items")
local show_prompt    = require("server.show_prompt")
local death_link     = require("server.death_link")
local synth_hints    = require("server.synth_hints")

local server = nil
local server_started = false

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

function start_server()
    if server_started then return end
    server = socket.bind("127.0.0.1", 13138)
    server:settimeout(0)
    server_started = true
    ConsolePrint("Socket server listening on 127.0.0.1:13138")
end

local function close_client(c)
    if not c then return end
    pcall(function() c:shutdown("send") end)
    pcall(function() c:close() end)
end

local function handle_message(line)
    local reply = {}
    local ok, msg = pcall(json.decode, line)
    if not ok then
        return nil
    end

    if msg.get_state then
        reply.locations = game_state.locations
        reply.victory = game_state.victory
        reply.world = game_state.world
        reply.sora_koed = game_state.sora_koed
        reply.hinted_locations = game_state.hinted_locations
    end

    if type(msg.items) == "table" then
        receive_items_from_client(msg.items)
    end

    if type(msg.prompt) == "table" then
        handle_prompt(msg.prompt)
    end

    if type(msg.effect) == "table" then
        if msg.effect.heartless_angel then
            heartless_angel_sora()
        elseif msg.effect.sora_ko then
            ko_sora()
        end
    end

    if type(msg.adhoc_item) == "number" then
        handle_item_received(msg.adhoc_item)
    end

    if msg.get_abilities then
        reply.abilities = read_abilities()
    end

    if msg.get_items then
        reply.items = read_stock()
    end

    if msg.get_shared_abilities then
        reply.shared_abilities = read_shared_abilities()
    end

    return reply
end

function serve_once()
    if not server_started then return end

    local c = server:accept()
    if not c then return end

    c:settimeout(0)

    local line, err = c:receive("*l")
    if line then
        local reply = handle_message(line)
        if reply ~= nil then
            c:send(json.encode(reply) .. "\n")
        end
    end

    close_client(c)
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
    if canExecute then
        start_server()
        location_map = fill_location_map()
        death_link_init()
    end
end

function _OnFrame()
    if canExecute then
        serve_once()
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
