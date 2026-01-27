local helpers = require("server.helpers")

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

function final_ansem_defeated(victory)
    --[[Checks if the player is on the results screen, meaning that they defeated Final Ansem]]
    victory_updated = false
    world = {0x2340E5C, 0x233FE84}
    room_offset = {0x68, 0x8}
    room = world[game_version] + room_offset[game_version]
    cutscene_flags_address = {0x2DEB264, 0x2DEA864}
    victory_status = ReadByte(world[game_version]) == 0x10 and ReadByte(room) == 0x20 and ReadByte(cutscene_flags_address[game_version] + 0xB) == 0x9B
    if victory_status ~= victory then
        victory_updated = true
    end
    return victory_status, victory_updated
end

function fill_location_map()
    location_map = {}
    chests_opened_address        = {0x2DEA32C, 0x2DE992C}
    world_progress_array_address = {0x2DEB264, 0x2DEA864}
    atlantica_clams_address      = {0x2DEBB09, 0x2DEB109}
    world_flags_address          = {0x2DEAA6D, 0x2DEA06D}
    soras_level_address          = {0x2DE9D98, 0x2DE9398}
    ansems_reports_address       = {0x2DEB720, 0x2DEAD20}
    olympus_flags_address        = {0x2E01896, 0x2E00E96}
    event_flags                  = {0x2DEAB68, 0x2DEA168}
    --[[Each location is defined by the following values
        Location_ID
        Address
        Bit Number (0 if byte value)
        Compare Value
        Custom Logic ID
      ]]
    table.insert(location_map, {2650011, chests_opened_address[game_version]        + 0x0,    1, 0x01, 0}) --Destiny Islands Chest
    table.insert(location_map, {2650211, chests_opened_address[game_version]        + 0x14,   1, 0x01, 0}) --Traverse Town 1st District Candle Puzzle Chest
    table.insert(location_map, {2650212, chests_opened_address[game_version]        + 0x14,   2, 0x01, 0}) --Traverse Town Accessory Shop Roof Chest
    table.insert(location_map, {2650213, chests_opened_address[game_version]        + 0x14,   3, 0x01, 0}) --Traverse Town 2nd District Boots and Shoes Awning Chest
    table.insert(location_map, {2650214, chests_opened_address[game_version]        + 0x14,   4, 0x01, 0}) --Traverse Town 2nd District Rooftop Chest
    table.insert(location_map, {2650251, chests_opened_address[game_version]        + 0x18,   1, 0x01, 0}) --Traverse Town 2nd Distrcit Gizmo Shop Facade Chest
    table.insert(location_map, {2650252, chests_opened_address[game_version]        + 0x18,   2, 0x01, 0}) --Traverse Town Alleyway Balcony Chest
    table.insert(location_map, {2650253, chests_opened_address[game_version]        + 0x18,   3, 0x01, 0}) --Traverse Town Alleyway Blue Room Awning Chest
    table.insert(location_map, {2650254, chests_opened_address[game_version]        + 0x18,   4, 0x01, 0}) --Traverse Town Alleyway Corner Chest
    table.insert(location_map, {2650292, chests_opened_address[game_version]        + 0x1C,   2, 0x01, 0}) --Traverse Town Green Room Clock Puzzle Chest
    table.insert(location_map, {2650293, chests_opened_address[game_version]        + 0x1C,   3, 0x01, 0}) --Traverse Town Green Room Table Chest
    table.insert(location_map, {2650294, chests_opened_address[game_version]        + 0x1C,   4, 0x01, 0}) --Traverse Town Red Room Chest
    table.insert(location_map, {2650331, chests_opened_address[game_version]        + 0x20,   1, 0x01, 0}) --Traverse Town Mystical House Yellow Trinity Chest
    table.insert(location_map, {2650332, chests_opened_address[game_version]        + 0x20,   2, 0x01, 0}) --Traverse Town Accessory Shop Chest
    table.insert(location_map, {2650333, chests_opened_address[game_version]        + 0x20,   3, 0x01, 0}) --Traverse Town Secret Waterway White Trinity Chest
    table.insert(location_map, {2650334, chests_opened_address[game_version]        + 0x20,   4, 0x01, 0}) --Traverse Town Geppetto's House Chest
    table.insert(location_map, {2650371, chests_opened_address[game_version]        + 0x24,   1, 0x01, 0}) --Traverse Town Item Workshop Right Chest
    table.insert(location_map, {2650411, chests_opened_address[game_version]        + 0x28,   1, 0x01, 0}) --Traverse Town 1st District Blue Trinity Balcony Chest
    table.insert(location_map, {2650891, chests_opened_address[game_version]        + 0x58,   1, 0x01, 0}) --Traverse Town Mystical House Glide Chest
    table.insert(location_map, {2650892, chests_opened_address[game_version]        + 0x58,   2, 0x01, 0}) --Traverse Town Alleyway Behind Crates Chest
    table.insert(location_map, {2650893, chests_opened_address[game_version]        + 0x58,   3, 0x01, 0}) --Traverse Town Item Workshop Left Chest
    table.insert(location_map, {2650894, chests_opened_address[game_version]        + 0x58,   4, 0x01, 0}) --Traverse Town Secret Waterway Near Stairs Chest
    table.insert(location_map, {2650931, chests_opened_address[game_version]        + 0x5C,   1, 0x01, 0}) --Wonderland Rabbit Hole Green Trinity Chest
    table.insert(location_map, {2650932, chests_opened_address[game_version]        + 0x5C,   2, 0x01, 0}) --Wonderland Rabbit Hole Defeat Heartless 1 Chest
    table.insert(location_map, {2650933, chests_opened_address[game_version]        + 0x5C,   3, 0x01, 0}) --Wonderland Rabbit Hole Defeat Heartless 2 Chest
    table.insert(location_map, {2650934, chests_opened_address[game_version]        + 0x5C,   4, 0x01, 0}) --Wonderland Rabbit Hole Defeat Heartless 3 Chest
    table.insert(location_map, {2650971, chests_opened_address[game_version]        + 0x60,   1, 0x01, 0}) --Wonderland Bizarre Room Green Trinity Chest
    table.insert(location_map, {2651011, chests_opened_address[game_version]        + 0x64,   1, 0x01, 0}) --Wonderland Queen's Castle Hedge Left Red Chest
    table.insert(location_map, {2651012, chests_opened_address[game_version]        + 0x64,   2, 0x01, 0}) --Wonderland Queen's Castle Hedge Right Blue Chest
    table.insert(location_map, {2651013, chests_opened_address[game_version]        + 0x64,   3, 0x01, 0}) --Wonderland Queen's Castle Hedge Right Red Chest
    table.insert(location_map, {2651014, chests_opened_address[game_version]        + 0x64,   4, 0x01, 0}) --Wonderland Lotus Forest Thunder Plant Chest
    table.insert(location_map, {2651051, chests_opened_address[game_version]        + 0x68,   1, 0x01, 0}) --Wonderland Lotus Forest Through the Painting Thunder Plant Chest
    table.insert(location_map, {2651052, chests_opened_address[game_version]        + 0x68,   2, 0x01, 0}) --Wonderland Lotus Forest Glide Chest
    table.insert(location_map, {2651053, chests_opened_address[game_version]        + 0x68,   3, 0x01, 0}) --Wonderland Lotus Forest Nut Chest
    table.insert(location_map, {2651054, chests_opened_address[game_version]        + 0x68,   4, 0x01, 0}) --Wonderland Lotus Forest Corner Chest
    table.insert(location_map, {2651091, chests_opened_address[game_version]        + 0x6C,   1, 0x01, 0}) --Wonderland Bizarre Room Lamp Chest
    table.insert(location_map, {2651093, chests_opened_address[game_version]        + 0x6C,   3, 0x01, 0}) --Wonderland Tea Party Garden Above Lotus Forest Entrance 2nd Chest
    table.insert(location_map, {2651094, chests_opened_address[game_version]        + 0x6C,   4, 0x01, 0}) --Wonderland Tea Party Garden Above Lotus Forest Entrance 1st Chest
    table.insert(location_map, {2651131, chests_opened_address[game_version]        + 0x70,   1, 0x01, 0}) --Wonderland Tea Party Garden Bear and Clock Puzzle Chest
    table.insert(location_map, {2651132, chests_opened_address[game_version]        + 0x70,   2, 0x01, 0}) --Wonderland Tea Party Garden Across From Bizarre Room Entrance Chest
    table.insert(location_map, {2651133, chests_opened_address[game_version]        + 0x70,   3, 0x01, 0}) --Wonderland Lotus Forest Through the Painting White Trinity Chest
    table.insert(location_map, {2651213, chests_opened_address[game_version]        + 0x78,   3, 0x01, 0}) --Deep Jungle Tree House Beneath Tree House Chest
    table.insert(location_map, {2651214, chests_opened_address[game_version]        + 0x78,   4, 0x01, 0}) --Deep Jungle Tree House Rooftop Chest
    table.insert(location_map, {2651251, chests_opened_address[game_version]        + 0x7C,   1, 0x01, 0}) --Deep Jungle Hippo's Lagoon Center Chest
    table.insert(location_map, {2651252, chests_opened_address[game_version]        + 0x7C,   2, 0x01, 0}) --Deep Jungle Hippo's Lagoon Left Chest
    table.insert(location_map, {2651253, chests_opened_address[game_version]        + 0x7C,   3, 0x01, 0}) --Deep Jungle Hippo's Lagoon Right Chest
    table.insert(location_map, {2651291, chests_opened_address[game_version]        + 0x80,   1, 0x01, 0}) --Deep Jungle Vines Chest
    table.insert(location_map, {2651292, chests_opened_address[game_version]        + 0x80,   2, 0x01, 0}) --Deep Jungle Vines 2 Chest
    table.insert(location_map, {2651293, chests_opened_address[game_version]        + 0x80,   3, 0x01, 0}) --Deep Jungle Climbing Trees Blue Trinity Chest
    table.insert(location_map, {2651331, chests_opened_address[game_version]        + 0x84,   1, 0x01, 0}) --Deep Jungle Tunnel Chest
    table.insert(location_map, {2651332, chests_opened_address[game_version]        + 0x84,   2, 0x01, 0}) --Deep Jungle Cavern of Hearts White Trinity Chest
    table.insert(location_map, {2651333, chests_opened_address[game_version]        + 0x84,   3, 0x01, 0}) --Deep Jungle Camp Blue Trinity Chest
    table.insert(location_map, {2651334, chests_opened_address[game_version]        + 0x84,   4, 0x01, 0}) --Deep Jungle Tent Chest
    table.insert(location_map, {2651371, chests_opened_address[game_version]        + 0x88,   1, 0x01, 0}) --Deep Jungle Waterfall Cavern Low Chest
    table.insert(location_map, {2651372, chests_opened_address[game_version]        + 0x88,   2, 0x01, 0}) --Deep Jungle Waterfall Cavern Middle Chest
    table.insert(location_map, {2651373, chests_opened_address[game_version]        + 0x88,   3, 0x01, 0}) --Deep Jungle Waterfall Cavern High Wall Chest
    table.insert(location_map, {2651374, chests_opened_address[game_version]        + 0x88,   4, 0x01, 0}) --Deep Jungle Waterfall Cavern High Middle Chest
    table.insert(location_map, {2651411, chests_opened_address[game_version]        + 0x8C,   1, 0x01, 0}) --Deep Jungle Cliff Right Cliff Left Chest
    table.insert(location_map, {2651412, chests_opened_address[game_version]        + 0x8C,   2, 0x01, 0}) --Deep Jungle Cliff Right Cliff Right Chest
    table.insert(location_map, {2651413, chests_opened_address[game_version]        + 0x8C,   3, 0x01, 0}) --Deep Jungle Tree House Suspended Boat Chest
    table.insert(location_map, {2651654, chests_opened_address[game_version]        + 0xA4,   4, 0x01, 0}) --100 Acre Wood Meadow Inside Log Chest
    table.insert(location_map, {2651691, chests_opened_address[game_version]        + 0xA8,   1, 0x01, 0}) --100 Acre Wood Bouncing Spot Left Cliff Chest
    table.insert(location_map, {2651692, chests_opened_address[game_version]        + 0xA8,   2, 0x01, 0}) --100 Acre Wood Bouncing Spot Right Tree Alcove Chest
    table.insert(location_map, {2651693, chests_opened_address[game_version]        + 0xA8,   3, 0x01, 0}) --100 Acre Wood Bouncing Spot Under Giant Pot Chest
    table.insert(location_map, {2651972, chests_opened_address[game_version]        + 0xC4,   2, 0x01, 0}) --Agrabah Plaza By Storage Chest
    table.insert(location_map, {2651973, chests_opened_address[game_version]        + 0xC4,   3, 0x01, 0}) --Agrabah Plaza Raised Terrace Chest
    table.insert(location_map, {2651974, chests_opened_address[game_version]        + 0xC4,   4, 0x01, 0}) --Agrabah Plaza Top Corner Chest
    table.insert(location_map, {2652011, chests_opened_address[game_version]        + 0xC8,   1, 0x01, 0}) --Agrabah Alley Chest
    table.insert(location_map, {2652012, chests_opened_address[game_version]        + 0xC8,   2, 0x01, 0}) --Agrabah Bazaar Across Windows Chest
    table.insert(location_map, {2652013, chests_opened_address[game_version]        + 0xC8,   3, 0x01, 0}) --Agrabah Bazaar High Corner Chest
    table.insert(location_map, {2652014, chests_opened_address[game_version]        + 0xC8,   4, 0x01, 0}) --Agrabah Main Street Right Palace Entrance Chest
    table.insert(location_map, {2652051, chests_opened_address[game_version]        + 0xCC,   1, 0x01, 0}) --Agrabah Main Street High Above Alley Entrance Chest
    table.insert(location_map, {2652052, chests_opened_address[game_version]        + 0xCC,   2, 0x01, 0}) --Agrabah Main Street High Above Palace Gates Entrance Chest
    table.insert(location_map, {2652053, chests_opened_address[game_version]        + 0xCC,   3, 0x01, 0}) --Agrabah Palace Gates Low Chest
    table.insert(location_map, {2652054, chests_opened_address[game_version]        + 0xCC,   4, 0x01, 0}) --Agrabah Palace Gates High Opposite Palace Chest
    table.insert(location_map, {2652091, chests_opened_address[game_version]        + 0xD0,   1, 0x01, 0}) --Agrabah Palace Gates High Close to Palace Chest
    table.insert(location_map, {2652092, chests_opened_address[game_version]        + 0xD0,   2, 0x01, 0}) --Agrabah Storage Green Trinity Chest
    table.insert(location_map, {2652093, chests_opened_address[game_version]        + 0xD0,   3, 0x01, 0}) --Agrabah Storage Behind Barrel Chest
    table.insert(location_map, {2652094, chests_opened_address[game_version]        + 0xD0,   4, 0x01, 0}) --Agrabah Cave of Wonders Entrance Left Chest
    table.insert(location_map, {2652131, chests_opened_address[game_version]        + 0xD4,   1, 0x01, 0}) --Agrabah Cave of Wonders Entrance Tall Tower Chest
    table.insert(location_map, {2652132, chests_opened_address[game_version]        + 0xD4,   2, 0x01, 0}) --Agrabah Cave of Wonders Hall High Left Chest
    table.insert(location_map, {2652133, chests_opened_address[game_version]        + 0xD4,   3, 0x01, 0}) --Agrabah Cave of Wonders Hall Near Bottomless Hall Chest
    table.insert(location_map, {2652134, chests_opened_address[game_version]        + 0xD4,   4, 0x01, 0}) --Agrabah Cave of Wonders Bottomless Hall Raised Platform Chest
    table.insert(location_map, {2652171, chests_opened_address[game_version]        + 0xD8,   1, 0x01, 0}) --Agrabah Cave of Wonders Bottomless Hall Pillar Chest
    table.insert(location_map, {2652172, chests_opened_address[game_version]        + 0xD8,   2, 0x01, 0}) --Agrabah Cave of Wonders Bottomless Hall Across Chasm Chest
    table.insert(location_map, {2652173, chests_opened_address[game_version]        + 0xD8,   3, 0x01, 0}) --Agrabah Cave of Wonders Treasure Room Across Platforms Chest
    table.insert(location_map, {2652174, chests_opened_address[game_version]        + 0xD8,   4, 0x01, 0}) --Agrabah Cave of Wonders Treasure Room Small Treasure Pile Chest
    table.insert(location_map, {2652211, chests_opened_address[game_version]        + 0xDC,   1, 0x01, 0}) --Agrabah Cave of Wonders Treasure Room Large Treasure Pile Chest
    table.insert(location_map, {2652212, chests_opened_address[game_version]        + 0xDC,   2, 0x01, 0}) --Agrabah Cave of Wonders Treasure Room Above Fire Chest
    table.insert(location_map, {2652213, chests_opened_address[game_version]        + 0xDC,   3, 0x01, 0}) --Agrabah Cave of Wonders Relic Chamber Jump from Stairs Chest
    table.insert(location_map, {2652214, chests_opened_address[game_version]        + 0xDC,   4, 0x01, 0}) --Agrabah Cave of Wonders Relic Chamber Stairs Chest
    table.insert(location_map, {2652251, chests_opened_address[game_version]        + 0xE0,   1, 0x01, 0}) --Agrabah Cave of Wonders Dark Chamber Abu Gem Chest
    table.insert(location_map, {2652252, chests_opened_address[game_version]        + 0xE0,   2, 0x01, 0}) --Agrabah Cave of Wonders Dark Chamber Across from Relic Chamber Entrance Chest
    table.insert(location_map, {2652253, chests_opened_address[game_version]        + 0xE0,   3, 0x01, 0}) --Agrabah Cave of Wonders Dark Chamber Bridge Chest
    table.insert(location_map, {2652254, chests_opened_address[game_version]        + 0xE0,   4, 0x01, 0}) --Agrabah Cave of Wonders Dark Chamber Near Save Chest
    table.insert(location_map, {2652291, chests_opened_address[game_version]        + 0xE4,   1, 0x01, 0}) --Agrabah Cave of Wonders Silent Chamber Blue Trinity Chest
    table.insert(location_map, {2652292, chests_opened_address[game_version]        + 0xE4,   2, 0x01, 0}) --Agrabah Cave of Wonders Hidden Room Right Chest
    table.insert(location_map, {2652293, chests_opened_address[game_version]        + 0xE4,   3, 0x01, 0}) --Agrabah Cave of Wonders Hidden Room Left Chest
    table.insert(location_map, {2652294, chests_opened_address[game_version]        + 0xE4,   4, 0x01, 0}) --Agrabah Aladdin's House Main Street Entrance Chest
    table.insert(location_map, {2652331, chests_opened_address[game_version]        + 0xE8,   1, 0x01, 0}) --Agrabah Aladdin's House Plaza Entrance Chest
    table.insert(location_map, {2652332, chests_opened_address[game_version]        + 0xE8,   2, 0x01, 0}) --Agrabah Cave of Wonders Entrance White Trinity Chest
    table.insert(location_map, {2652413, chests_opened_address[game_version]        + 0xF0,   3, 0x01, 0}) --Monstro Chamber 6 Other Platform Chest
    table.insert(location_map, {2652414, chests_opened_address[game_version]        + 0xF0,   4, 0x01, 0}) --Monstro Chamber 6 Platform Near Chamber 5 Entrance Chest
    table.insert(location_map, {2652451, chests_opened_address[game_version]        + 0xF4,   1, 0x01, 0}) --Monstro Chamber 6 Raised Area Near Chamber 1 Entrance Chest
    table.insert(location_map, {2652452, chests_opened_address[game_version]        + 0xF4,   2, 0x01, 0}) --Monstro Chamber 6 Low Chest
    table.insert(location_map, {2652531, chests_opened_address[game_version]        + 0xFC,   1, 0x01, 0}) --Atlantica Sunken Ship In Flipped Boat Chest
    table.insert(location_map, {2652532, chests_opened_address[game_version]        + 0xFC,   2, 0x01, 0}) --Atlantica Sunken Ship Seabed Chest
    table.insert(location_map, {2652533, chests_opened_address[game_version]        + 0xFC,   3, 0x01, 0}) --Atlantica Sunken Ship Inside Ship Chest
    table.insert(location_map, {2652534, chests_opened_address[game_version]        + 0xFC,   4, 0x01, 0}) --Atlantica Ariel's Grotto High Chest
    table.insert(location_map, {2652571, chests_opened_address[game_version]        + 0x100,  1, 0x01, 0}) --Atlantica Ariel's Grotto Middle Chest
    table.insert(location_map, {2652572, chests_opened_address[game_version]        + 0x100,  2, 0x01, 0}) --Atlantica Ariel's Grotto Low Chest
    table.insert(location_map, {2652573, chests_opened_address[game_version]        + 0x100,  3, 0x01, 0}) --Atlantica Ursula's Lair Use Fire on Urchin Chest
    table.insert(location_map, {2652574, chests_opened_address[game_version]        + 0x100,  4, 0x01, 0}) --Atlantica Undersea Gorge Jammed by Ariel's Grotto Chest
    table.insert(location_map, {2652611, chests_opened_address[game_version]        + 0x104,  1, 0x01, 0}) --Atlantica Triton's Palace White Trinity Chest
    table.insert(location_map, {2653014, chests_opened_address[game_version]        + 0x12C,  4, 0x01, 0}) --Halloween Town Moonlight Hill White Trinity Chest
    table.insert(location_map, {2653051, chests_opened_address[game_version]        + 0x130,  1, 0x01, 0}) --Halloween Town Bridge Under Bridge
    table.insert(location_map, {2653052, chests_opened_address[game_version]        + 0x130,  2, 0x01, 0}) --Halloween Town Boneyard Tombstone Puzzle Chest
    table.insert(location_map, {2653053, chests_opened_address[game_version]        + 0x130,  3, 0x01, 0}) --Halloween Town Bridge Right of Gate Chest
    table.insert(location_map, {2653054, chests_opened_address[game_version]        + 0x130,  4, 0x01, 0}) --Halloween Town Cemetery Behind Grave Chest
    table.insert(location_map, {2653091, chests_opened_address[game_version]        + 0x134,  1, 0x01, 0}) --Halloween Town Cemetery By Cat Shape Chest
    table.insert(location_map, {2653092, chests_opened_address[game_version]        + 0x134,  2, 0x01, 0}) --Halloween Town Cemetery Between Graves Chest
    table.insert(location_map, {2653093, chests_opened_address[game_version]        + 0x134,  3, 0x01, 0}) --Halloween Town Oogie's Manor Lower Iron Cage Chest
    table.insert(location_map, {2653094, chests_opened_address[game_version]        + 0x134,  4, 0x01, 0}) --Halloween Town Oogie's Manor Upper Iron Cage Chest
    table.insert(location_map, {2653131, chests_opened_address[game_version]        + 0x138,  1, 0x01, 0}) --Halloween Town Oogie's Manor Hollow Chest
    table.insert(location_map, {2653132, chests_opened_address[game_version]        + 0x138,  2, 0x01, 0}) --Halloween Town Oogie's Manor Grounds Red Trinity Chest
    table.insert(location_map, {2653133, chests_opened_address[game_version]        + 0x138,  3, 0x01, 0}) --Halloween Town Guillotine Square High Tower Chest
    table.insert(location_map, {2653134, chests_opened_address[game_version]        + 0x138,  4, 0x01, 0}) --Halloween Town Guillotine Square Pumpkin Structure Left Chest
    table.insert(location_map, {2653171, chests_opened_address[game_version]        + 0x13C,  1, 0x01, 0}) --Halloween Town Oogie's Manor Entrance Steps Chest
    table.insert(location_map, {2653172, chests_opened_address[game_version]        + 0x13C,  2, 0x01, 0}) --Halloween Town Oogie's Manor Inside Entrance Chest
    table.insert(location_map, {2653291, chests_opened_address[game_version]        + 0x148,  1, 0x01, 0}) --Halloween Town Bridge Left of Gate Chest
    table.insert(location_map, {2653292, chests_opened_address[game_version]        + 0x148,  2, 0x01, 0}) --Halloween Town Cemetery By Striped Grave Chest
    table.insert(location_map, {2653293, chests_opened_address[game_version]        + 0x148,  3, 0x01, 0}) --Halloween Town Guillotine Square Under Jack's House Stairs Chest
    table.insert(location_map, {2653294, chests_opened_address[game_version]        + 0x148,  4, 0x01, 0}) --Halloween Town Guillotine Square Pumpkin Structure Right Chest
    table.insert(location_map, {2653332, chests_opened_address[game_version]        + 0x14C,  2, 0x01, 0}) --Olympus Coliseum Coliseum Gates Left Behind Columns Chest
    table.insert(location_map, {2653333, chests_opened_address[game_version]        + 0x14C,  3, 0x01, 0}) --Olympus Coliseum Coliseum Gates Right Blue Trinity Chest
    table.insert(location_map, {2653334, chests_opened_address[game_version]        + 0x14C,  4, 0x01, 0}) --Olympus Coliseum Coliseum Gates Left Blue Trinity Chest
    table.insert(location_map, {2653371, chests_opened_address[game_version]        + 0x150,  1, 0x01, 0}) --Olympus Coliseum Coliseum Gates White Trinity Chest
    table.insert(location_map, {2653372, chests_opened_address[game_version]        + 0x150,  2, 0x01, 0}) --Olympus Coliseum Coliseum Gates Blizzara Chest
    table.insert(location_map, {2653373, chests_opened_address[game_version]        + 0x150,  3, 0x01, 0}) --Olympus Coliseum Coliseum Gates Blizzaga Chest
    table.insert(location_map, {2653454, chests_opened_address[game_version]        + 0x158,  4, 0x01, 0}) --Monstro Mouth Boat Deck Chest
    table.insert(location_map, {2653491, chests_opened_address[game_version]        + 0x15C,  1, 0x01, 0}) --Monstro Mouth High Platform Boat Side Chest
    table.insert(location_map, {2653492, chests_opened_address[game_version]        + 0x15C,  2, 0x01, 0}) --Monstro Mouth High Platform Across from Boat Chest
    table.insert(location_map, {2653493, chests_opened_address[game_version]        + 0x15C,  3, 0x01, 0}) --Monstro Mouth Near Ship Chest
    table.insert(location_map, {2653494, chests_opened_address[game_version]        + 0x15C,  4, 0x01, 0}) --Monstro Mouth Green Trinity Top of Boat Chest
    table.insert(location_map, {2653534, chests_opened_address[game_version]        + 0x160,  4, 0x01, 0}) --Monstro Chamber 2 Ground Chest
    table.insert(location_map, {2653571, chests_opened_address[game_version]        + 0x164,  1, 0x01, 0}) --Monstro Chamber 2 Platform Chest
    table.insert(location_map, {2653613, chests_opened_address[game_version]        + 0x168,  3, 0x01, 0}) --Monstro Chamber 5 Platform Chest
    table.insert(location_map, {2653614, chests_opened_address[game_version]        + 0x168,  4, 0x01, 0}) --Monstro Chamber 3 Ground Chest
    table.insert(location_map, {2653651, chests_opened_address[game_version]        + 0x16C,  1, 0x01, 0}) --Monstro Chamber 3 Platform Above Chamber 2 Entrance Chest
    table.insert(location_map, {2653652, chests_opened_address[game_version]        + 0x16C,  2, 0x01, 0}) --Monstro Chamber 3 Near Chamber 6 Entrance Chest
    table.insert(location_map, {2653653, chests_opened_address[game_version]        + 0x16C,  3, 0x01, 0}) --Monstro Chamber 3 Platform Near Chamber 6 Entrance Chest
    table.insert(location_map, {2653732, chests_opened_address[game_version]        + 0x174,  2, 0x01, 0}) --Monstro Mouth High Platform Near Teeth Chest
    table.insert(location_map, {2653733, chests_opened_address[game_version]        + 0x174,  3, 0x01, 0}) --Monstro Chamber 5 Atop Barrel Chest
    table.insert(location_map, {2653734, chests_opened_address[game_version]        + 0x174,  4, 0x01, 0}) --Monstro Chamber 5 Low 2nd Chest
    table.insert(location_map, {2653771, chests_opened_address[game_version]        + 0x178,  1, 0x01, 0}) --Monstro Chamber 5 Low 1st Chest
    table.insert(location_map, {2653772, chests_opened_address[game_version]        + 0x178,  2, 0x01, 0}) --Neverland Pirate Ship Deck White Trinity Chest
    table.insert(location_map, {2653773, chests_opened_address[game_version]        + 0x178,  3, 0x01, 0}) --Neverland Pirate Ship Crows Nest Chest
    table.insert(location_map, {2653774, chests_opened_address[game_version]        + 0x178,  4, 0x01, 0}) --Neverland Hold Yellow Trinity Right Blue Chest
    table.insert(location_map, {2653811, chests_opened_address[game_version]        + 0x17C,  1, 0x01, 0}) --Neverland Hold Yellow Trinity Left Blue Chest
    table.insert(location_map, {2653812, chests_opened_address[game_version]        + 0x17C,  2, 0x01, 0}) --Neverland Galley Chest
    table.insert(location_map, {2653813, chests_opened_address[game_version]        + 0x17C,  3, 0x01, 0}) --Neverland Cabin Chest
    table.insert(location_map, {2653814, chests_opened_address[game_version]        + 0x17C,  4, 0x01, 0}) --Neverland Hold Flight 1st Chest
    table.insert(location_map, {2654014, chests_opened_address[game_version]        + 0x190,  4, 0x01, 0}) --Neverland Clock Tower Chest
    table.insert(location_map, {2654051, chests_opened_address[game_version]        + 0x194,  1, 0x01, 0}) --Neverland Hold Flight 2nd Chest
    table.insert(location_map, {2654052, chests_opened_address[game_version]        + 0x194,  2, 0x01, 0}) --Neverland Hold Yellow Trinity Green Chest
    table.insert(location_map, {2654053, chests_opened_address[game_version]        + 0x194,  3, 0x01, 0}) --Neverland Captain's Cabin Chest
    table.insert(location_map, {2654054, chests_opened_address[game_version]        + 0x194,  4, 0x01, 0}) --Hollow Bastion Rising Falls Water's Surface Chest
    table.insert(location_map, {2654091, chests_opened_address[game_version]        + 0x198,  1, 0x01, 0}) --Hollow Bastion Rising Falls Under Water 1st Chest
    table.insert(location_map, {2654092, chests_opened_address[game_version]        + 0x198,  2, 0x01, 0}) --Hollow Bastion Rising Falls Under Water 2nd Chest
    table.insert(location_map, {2654093, chests_opened_address[game_version]        + 0x198,  3, 0x01, 0}) --Hollow Bastion Rising Falls Floating Platform Near Save Chest
    table.insert(location_map, {2654094, chests_opened_address[game_version]        + 0x198,  4, 0x01, 0}) --Hollow Bastion Rising Falls Floating Platform Near Bubble Chest
    table.insert(location_map, {2654131, chests_opened_address[game_version]        + 0x19C,  1, 0x01, 0}) --Hollow Bastion Rising Falls High Platform Chest
    table.insert(location_map, {2654132, chests_opened_address[game_version]        + 0x19C,  2, 0x01, 0}) --Hollow Bastion Castle Gates Gravity Chest
    table.insert(location_map, {2654133, chests_opened_address[game_version]        + 0x19C,  3, 0x01, 0}) --Hollow Bastion Castle Gates Freestanding Pillar Chest
    table.insert(location_map, {2654134, chests_opened_address[game_version]        + 0x19C,  4, 0x01, 0}) --Hollow Bastion Castle Gates High Pillar Chest
    table.insert(location_map, {2654171, chests_opened_address[game_version]        + 0x1A0,  1, 0x01, 0}) --Hollow Bastion Great Crest Lower Chest
    table.insert(location_map, {2654172, chests_opened_address[game_version]        + 0x1A0,  2, 0x01, 0}) --Hollow Bastion Great Crest After Battle Platform Chest
    table.insert(location_map, {2654173, chests_opened_address[game_version]        + 0x1A0,  3, 0x01, 0}) --Hollow Bastion High Tower 2nd Gravity Chest
    table.insert(location_map, {2654174, chests_opened_address[game_version]        + 0x1A0,  4, 0x01, 0}) --Hollow Bastion High Tower 1st Gravity Chest
    table.insert(location_map, {2654211, chests_opened_address[game_version]        + 0x1A4,  1, 0x01, 0}) --Hollow Bastion High Tower Above Sliding Blocks Chest
    table.insert(location_map, {2654213, chests_opened_address[game_version]        + 0x1A4,  3, 0x01, 0}) --Hollow Bastion Library Top of Bookshelf Chest
    table.insert(location_map, {2654214, chests_opened_address[game_version]        + 0x1A4,  4, 0x01, 0}) --Hollow Bastion Library 1st Floor Turn the Carousel Chest
    table.insert(location_map, {2654251, chests_opened_address[game_version]        + 0x1A8,  1, 0x01, 0}) --Hollow Bastion Library Top of Bookshelf Turn the Carousel Chest
    table.insert(location_map, {2654252, chests_opened_address[game_version]        + 0x1A8,  2, 0x01, 0}) --Hollow Bastion Library 2nd Floor Turn the Carousel 1st Chest
    table.insert(location_map, {2654253, chests_opened_address[game_version]        + 0x1A8,  3, 0x01, 0}) --Hollow Bastion Library 2nd Floor Turn the Carousel 2nd Chest
    table.insert(location_map, {2654254, chests_opened_address[game_version]        + 0x1A8,  4, 0x01, 0}) --Hollow Bastion Lift Stop Library Node After High Tower Switch Gravity Chest
    table.insert(location_map, {2654291, chests_opened_address[game_version]        + 0x1AC,  1, 0x01, 0}) --Hollow Bastion Lift Stop Library Node Gravity Chest
    table.insert(location_map, {2654292, chests_opened_address[game_version]        + 0x1AC,  2, 0x01, 0}) --Hollow Bastion Lift Stop Under High Tower Sliding Blocks Chest
    table.insert(location_map, {2654293, chests_opened_address[game_version]        + 0x1AC,  3, 0x01, 0}) --Hollow Bastion Lift Stop Outside Library Gravity Chest
    table.insert(location_map, {2654294, chests_opened_address[game_version]        + 0x1AC,  4, 0x01, 0}) --Hollow Bastion Lift Stop Heartless Sigil Door Gravity Chest
    table.insert(location_map, {2654331, chests_opened_address[game_version]        + 0x1B0,  1, 0x01, 0}) --Hollow Bastion Base Level Bubble Under the Wall Platform Chest
    table.insert(location_map, {2654332, chests_opened_address[game_version]        + 0x1B0,  2, 0x01, 0}) --Hollow Bastion Base Level Platform Near Entrance Chest
    table.insert(location_map, {2654333, chests_opened_address[game_version]        + 0x1B0,  3, 0x01, 0}) --Hollow Bastion Base Level Near Crystal Switch Chest
    table.insert(location_map, {2654334, chests_opened_address[game_version]        + 0x1B0,  4, 0x01, 0}) --Hollow Bastion Waterway Near Save Chest
    table.insert(location_map, {2654371, chests_opened_address[game_version]        + 0x1B4,  1, 0x01, 0}) --Hollow Bastion Waterway Blizzard on Bubble Chest
    table.insert(location_map, {2654372, chests_opened_address[game_version]        + 0x1B4,  2, 0x01, 0}) --Hollow Bastion Waterway Unlock Passage from Base Level Chest
    table.insert(location_map, {2654373, chests_opened_address[game_version]        + 0x1B4,  3, 0x01, 0}) --Hollow Bastion Dungeon By Candles Chest
    table.insert(location_map, {2654374, chests_opened_address[game_version]        + 0x1B4,  4, 0x01, 0}) --Hollow Bastion Dungeon Corner Chest
    table.insert(location_map, {2654454, chests_opened_address[game_version]        + 0x1BC,  4, 0x01, 0}) --Hollow Bastion Grand Hall Steps Right Side Chest
    table.insert(location_map, {2654491, chests_opened_address[game_version]        + 0x1C0,  1, 0x01, 0}) --Hollow Bastion Grand Hall Oblivion Chest
    table.insert(location_map, {2654492, chests_opened_address[game_version]        + 0x1C0,  2, 0x01, 0}) --Hollow Bastion Grand Hall Left of Gate Chest
    table.insert(location_map, {2654493, chests_opened_address[game_version]        + 0x1C0,  3, 0x01, 0}) --Hollow Bastion Entrance Hall Push the Statue Chest
    table.insert(location_map, {2654212, chests_opened_address[game_version]        + 0x1A4,  2, 0x01, 0}) --Hollow Bastion Entrance Hall Left of Emblem Door Chest
    table.insert(location_map, {2654494, chests_opened_address[game_version]        + 0x1C0,  4, 0x01, 0}) --Hollow Bastion Rising Falls White Trinity Chest
    table.insert(location_map, {2654531, chests_opened_address[game_version]        + 0x1C4,  1, 0x01, 0}) --End of the World Final Dimension 1st Chest
    table.insert(location_map, {2654532, chests_opened_address[game_version]        + 0x1C4,  2, 0x01, 0}) --End of the World Final Dimension 2nd Chest
    table.insert(location_map, {2654533, chests_opened_address[game_version]        + 0x1C4,  3, 0x01, 0}) --End of the World Final Dimension 3rd Chest
    table.insert(location_map, {2654534, chests_opened_address[game_version]        + 0x1C4,  4, 0x01, 0}) --End of the World Final Dimension 4th Chest
    table.insert(location_map, {2654571, chests_opened_address[game_version]        + 0x1C8,  1, 0x01, 0}) --End of the World Final Dimension 5th Chest
    table.insert(location_map, {2654572, chests_opened_address[game_version]        + 0x1C8,  2, 0x01, 0}) --End of the World Final Dimension 6th Chest
    table.insert(location_map, {2654573, chests_opened_address[game_version]        + 0x1C8,  3, 0x01, 0}) --End of the World Final Dimension 10th Chest
    table.insert(location_map, {2654574, chests_opened_address[game_version]        + 0x1C8,  4, 0x01, 0}) --End of the World Final Dimension 9th Chest
    table.insert(location_map, {2654611, chests_opened_address[game_version]        + 0x1CC,  1, 0x01, 0}) --End of the World Final Dimension 8th Chest
    table.insert(location_map, {2654612, chests_opened_address[game_version]        + 0x1CC,  2, 0x01, 0}) --End of the World Final Dimension 7th Chest
    table.insert(location_map, {2654613, chests_opened_address[game_version]        + 0x1CC,  3, 0x01, 0}) --End of the World Giant Crevasse 3rd Chest
    table.insert(location_map, {2654614, chests_opened_address[game_version]        + 0x1CC,  4, 0x01, 0}) --End of the World Giant Crevasse 5th Chest
    table.insert(location_map, {2654651, chests_opened_address[game_version]        + 0x1D0,  1, 0x01, 0}) --End of the World Giant Crevasse 1st Chest
    table.insert(location_map, {2654652, chests_opened_address[game_version]        + 0x1D0,  2, 0x01, 0}) --End of the World Giant Crevasse 4th Chest
    table.insert(location_map, {2654653, chests_opened_address[game_version]        + 0x1D0,  3, 0x01, 0}) --End of the World Giant Crevasse 2nd Chest
    table.insert(location_map, {2654654, chests_opened_address[game_version]        + 0x1D0,  4, 0x01, 0}) --End of the World World Terminus Traverse Town Chest
    table.insert(location_map, {2654691, chests_opened_address[game_version]        + 0x1D4,  1, 0x01, 0}) --End of the World World Terminus Wonderland Chest
    table.insert(location_map, {2654692, chests_opened_address[game_version]        + 0x1D4,  2, 0x01, 0}) --End of the World World Terminus Olympus Coliseum Chest
    table.insert(location_map, {2654693, chests_opened_address[game_version]        + 0x1D4,  3, 0x01, 0}) --End of the World World Terminus Deep Jungle Chest
    table.insert(location_map, {2654694, chests_opened_address[game_version]        + 0x1D4,  4, 0x01, 0}) --End of the World World Terminus Agrabah Chest
    table.insert(location_map, {2654731, chests_opened_address[game_version]        + 0x1D8,  1, 0x01, 0}) --End of the World World Terminus Atlantica Chest
    table.insert(location_map, {2654732, chests_opened_address[game_version]        + 0x1D8,  2, 0x01, 0}) --End of the World World Terminus Halloween Town Chest
    table.insert(location_map, {2654733, chests_opened_address[game_version]        + 0x1D8,  3, 0x01, 0}) --End of the World World Terminus Neverland Chest
    table.insert(location_map, {2654734, chests_opened_address[game_version]        + 0x1D8,  4, 0x01, 0}) --End of the World World Terminus 100 Acre Wood Chest
    table.insert(location_map, {2654771, chests_opened_address[game_version]        + 0x1DC,  1, 0x01, 0}) --End of the World World Terminus Hollow Bastion Chest
    table.insert(location_map, {2654772, chests_opened_address[game_version]        + 0x1DC,  2, 0x01, 0}) --End of the World Final Rest Chest
    table.insert(location_map, {2655092, chests_opened_address[game_version]        + 0x1FC,  2, 0x01, 0}) --Monstro Chamber 6 White Trinity Chest
    table.insert(location_map, {2655093, chests_opened_address[game_version]        + 0x1FC,  3, 0x01, 0}) --Awakening Chest
    table.insert(location_map, {2656011, world_progress_array_address[game_version] + 0x0,    0, 0x31, 0}) --Traverse Town Defeat Guard Armor Dodge Roll Event
    table.insert(location_map, {2656012, world_progress_array_address[game_version] + 0x0,    0, 0x31, 0}) --Traverse Town Defeat Guard Armor Fire Event
    table.insert(location_map, {2656013, world_progress_array_address[game_version] + 0x0,    0, 0x31, 0}) --Traverse Town Defeat Guard Armor Blue Trinity Event
    table.insert(location_map, {2656014, world_progress_array_address[game_version] + 0x0,    0, 0x3E, 0}) --Traverse Town Leon Secret Waterway Earthshine Event
    table.insert(location_map, {2656015, world_progress_array_address[game_version] + 0x0,    0, 0x8C, 0}) --Traverse Town Kairi Secret Waterway Oathkeeper Event
    table.insert(location_map, {2656016, world_progress_array_address[game_version] + 0x0,    0, 0x2B, 0}) --Traverse Town Defeat Guard Armor Brave Warrior Event
    table.insert(location_map, {2656021, world_progress_array_address[game_version] + 0x1,    0, 0x42, 0}) --Deep Jungle Defeat Sabor White Fang Event
    table.insert(location_map, {2656022, world_progress_array_address[game_version] + 0x1,    0, 0x56, 0}) --Deep Jungle Defeat Clayton Cure Event
    table.insert(location_map, {2656023, world_progress_array_address[game_version] + 0x1,    0, 0x6E, 0}) --Deep Jungle Seal Keyhole Jungle King Event
    table.insert(location_map, {2656024, world_progress_array_address[game_version] + 0x1,    0, 0x6E, 0}) --Deep Jungle Seal Keyhole Red Trinity Event
    table.insert(location_map, {2656031, world_progress_array_address[game_version] + 0x2,    0, 0x0D, 0}) --Olympus Coliseum Clear Phil's Training Thunder Event
    table.insert(location_map, {2656033, world_progress_array_address[game_version] + 0x2,    0, 0x25, 0}) --Olympus Coliseum Defeat Cerberus Inferno Band Event
    table.insert(location_map, {2656041, world_progress_array_address[game_version] + 0x3,    0, 0x2E, 0}) --Wonderland Defeat Trickmaster Blizzard Event
    table.insert(location_map, {2656042, world_progress_array_address[game_version] + 0x3,    0, 0x2E, 0}) --Wonderland Defeat Trickmaster Ifrit's Horn Event
    table.insert(location_map, {2656051, world_progress_array_address[game_version] + 0x4,    0, 0x35, 0}) --Agrabah Defeat Pot Centipede Ray of Light Event
    table.insert(location_map, {2656052, world_progress_array_address[game_version] + 0x4,    0, 0x49, 0}) --Agrabah Defeat Jafar Blizzard Event
    table.insert(location_map, {2656053, world_progress_array_address[game_version] + 0x4,    0, 0x5A, 0}) --Agrabah Defeat Jafar Genie Fire Event
    table.insert(location_map, {2656054, world_progress_array_address[game_version] + 0x4,    0, 0x78, 0}) --Agrabah Seal Keyhole Genie Event
    table.insert(location_map, {2656055, world_progress_array_address[game_version] + 0x4,    0, 0x78, 0}) --Agrabah Seal Keyhole Three Wishes Event
    table.insert(location_map, {2656056, world_progress_array_address[game_version] + 0x4,    0, 0x78, 0}) --Agrabah Seal Keyhole Green Trinity Event
    table.insert(location_map, {2656061, world_progress_array_address[game_version] + 0x5,    0, 0x2E, 0}) --Monstro Defeat Parasite Cage I Goofy Cheer Event
    table.insert(location_map, {2656062, world_progress_array_address[game_version] + 0x5,    0, 0x46, 0}) --Monstro Defeat Parasite Cage II Stop Event
    table.insert(location_map, {2656071, world_progress_array_address[game_version] + 0x6,    0, 0x53, 0}) --Atlantica Defeat Ursula I Mermaid Kick Event
    table.insert(location_map, {2656072, world_progress_array_address[game_version] + 0x6,    0, 0x5D, 0}) --Atlantica Defeat Ursula II Thunder Event
    table.insert(location_map, {2656073, world_progress_array_address[game_version] + 0x6,    0, 0x64, 0}) --Atlantica Seal Keyhole Crabclaw Event
    table.insert(location_map, {2656081, world_progress_array_address[game_version] + 0x8,    0, 0x62, 0}) --Halloween Town Defeat Oogie Boogie Holy Circlet Event
    table.insert(location_map, {2656082, world_progress_array_address[game_version] + 0x8,    0, 0x6A, 0}) --Halloween Town Defeat Oogie's Manor Gravity Event
    table.insert(location_map, {2656083, world_progress_array_address[game_version] + 0x8,    0, 0x6E, 0}) --Halloween Town Seal Keyhole Pumpkinhead Event
    table.insert(location_map, {2656091, world_progress_array_address[game_version] + 0x9,    0, 0x35, 0}) --Neverland Defeat Anti Sora Raven's Claw Event
    table.insert(location_map, {2656092, world_progress_array_address[game_version] + 0x9,    0, 0x3F, 0}) --Neverland Encounter Hook Cure Event
    table.insert(location_map, {2656093, world_progress_array_address[game_version] + 0x9,    0, 0x6E, 0}) --Neverland Seal Keyhole Fairy Harp Event
    table.insert(location_map, {2656112, world_progress_array_address[game_version] + 0x9,    0, 0x6E, 0}) --Neverland Seal Keyhole Navi-G Piece Event
    table.insert(location_map, {2656094, world_progress_array_address[game_version] + 0x9,    0, 0x6E, 0}) --Neverland Seal Keyhole Tinker Bell Event
    table.insert(location_map, {2656095, world_progress_array_address[game_version] + 0x9,    0, 0x6E, 0}) --Neverland Seal Keyhole Glide Event
    table.insert(location_map, {2656096, world_progress_array_address[game_version] + 0x9,    0, 0x96, 0}) --Neverland Defeat Phantom Stop Event
    table.insert(location_map, {2656097, world_progress_array_address[game_version] + 0x9,    0, 0x56, 0}) --Neverland Defeat Captain Hook Ars Arcanum Event
    table.insert(location_map, {2656101, world_progress_array_address[game_version] + 0xA,    0, 0x32, 0}) --Hollow Bastion Defeat Riku I White Trinity Event
    table.insert(location_map, {2656102, world_progress_array_address[game_version] + 0xA,    0, 0x5A, 0}) --Hollow Bastion Defeat Maleficent Donald Cheer Event
    table.insert(location_map, {2656103, world_progress_array_address[game_version] + 0xA,    0, 0x6E, 0}) --Hollow Bastion Defeat Dragon Maleficent Fireglow Event
    table.insert(location_map, {2656104, world_progress_array_address[game_version] + 0xA,    0, 0x82, 0}) --Hollow Bastion Defeat Riku II Ragnarok Event
    table.insert(location_map, {2656105, world_progress_array_address[game_version] + 0xA,    0, 0xB9, 0}) --Hollow Bastion Defeat Behemoth Omega Arts Event
    table.insert(location_map, {2656106, world_progress_array_address[game_version] + 0xA,    0, 0xC3, 0}) --Hollow Bastion Speak to Princesses Fire Event
    table.insert(location_map, {2656111, world_progress_array_address[game_version] + 0xB,    0, 0x33, 0}) --End of the World Defeat Chernabog Superglide Event
    table.insert(location_map, {2656113, world_progress_array_address[game_version] + 0x0,    0, 0x8C, 0}) --Traverse Town Secret Waterway Navi Gummi Event
    table.insert(location_map, {2656120, world_flags_address[game_version]          + 0xFB2,  0, 0x01, 0}) --Traverse Town Mail Postcard 01 Event
    table.insert(location_map, {2656121, world_flags_address[game_version]          + 0xFB2,  0, 0x02, 0}) --Traverse Town Mail Postcard 02 Event
    table.insert(location_map, {2656122, world_flags_address[game_version]          + 0xFB2,  0, 0x03, 0}) --Traverse Town Mail Postcard 03 Event
    table.insert(location_map, {2656123, world_flags_address[game_version]          + 0xFB2,  0, 0x04, 0}) --Traverse Town Mail Postcard 04 Event
    table.insert(location_map, {2656124, world_flags_address[game_version]          + 0xFB2,  0, 0x05, 0}) --Traverse Town Mail Postcard 05 Event
    table.insert(location_map, {2656125, world_flags_address[game_version]          + 0xFB2,  0, 0x06, 0}) --Traverse Town Mail Postcard 06 Event
    table.insert(location_map, {2656126, world_flags_address[game_version]          + 0xFB2,  0, 0x07, 0}) --Traverse Town Mail Postcard 07 Event
    table.insert(location_map, {2656127, world_flags_address[game_version]          + 0xFB2,  0, 0x08, 0}) --Traverse Town Mail Postcard 08 Event
    table.insert(location_map, {2656128, world_flags_address[game_version]          + 0xFB2,  0, 0x09, 0}) --Traverse Town Mail Postcard 09 Event
    table.insert(location_map, {2656129, world_flags_address[game_version]          + 0xFB2,  0, 0x0A, 0}) --Traverse Town Mail Postcard 10 Event
    table.insert(location_map, {2656131, world_progress_array_address[game_version] + 0xE,    0, 0x14, 0}) --Traverse Town Defeat Opposite Armor Aero Event
    table.insert(location_map, {2656132, world_progress_array_address[game_version] + 0xE,    0, 0x14, 0}) --Traverse Town Defeat Opposite Armor Navi-G Piece Event
    table.insert(location_map, {2656201, atlantica_clams_address[game_version]      + 0x0,    1, 0x01, 0}) --Atlantica Undersea Gorge Blizzard Clam
    table.insert(location_map, {2656202, atlantica_clams_address[game_version]      + 0x0,    2, 0x01, 0}) --Atlantica Undersea Gorge Ocean Floor Clam
    table.insert(location_map, {2656203, atlantica_clams_address[game_version]      + 0x0,    3, 0x01, 0}) --Atlantica Undersea Valley Higher Cave Clam
    table.insert(location_map, {2656204, atlantica_clams_address[game_version]      + 0x0,    4, 0x01, 0}) --Atlantica Undersea Valley Lower Cave Clam
    table.insert(location_map, {2656205, atlantica_clams_address[game_version]      + 0x0,    5, 0x01, 0}) --Atlantica Undersea Valley Fire Clam
    table.insert(location_map, {2656206, atlantica_clams_address[game_version]      + 0x0,    6, 0x01, 0}) --Atlantica Undersea Valley Wall Clam
    table.insert(location_map, {2656207, atlantica_clams_address[game_version]      + 0x0,    7, 0x01, 0}) --Atlantica Undersea Valley Pillar Clam
    table.insert(location_map, {2656208, atlantica_clams_address[game_version]      + 0x0,    8, 0x01, 0}) --Atlantica Undersea Valley Ocean Floor Clam
    table.insert(location_map, {2656209, atlantica_clams_address[game_version]      + 0x1,    1, 0x01, 0}) --Atlantica Triton's Palace Thunder Clam
    table.insert(location_map, {2656210, atlantica_clams_address[game_version]      + 0x1,    2, 0x01, 0}) --Atlantica Triton's Palace Wall Right Clam
    table.insert(location_map, {2656211, atlantica_clams_address[game_version]      + 0x1,    3, 0x01, 0}) --Atlantica Triton's Palace Near Path Clam
    table.insert(location_map, {2656212, atlantica_clams_address[game_version]      + 0x1,    4, 0x01, 0}) --Atlantica Triton's Palace Wall Left Clam
    table.insert(location_map, {2656213, atlantica_clams_address[game_version]      + 0x1,    5, 0x01, 0}) --Atlantica Cavern Nook Clam
    table.insert(location_map, {2656214, atlantica_clams_address[game_version]      + 0x1,    6, 0x01, 0}) --Atlantica Below Deck Clam
    table.insert(location_map, {2656215, atlantica_clams_address[game_version]      + 0x1,    7, 0x01, 0}) --Atlantica Undersea Garden Clam
    table.insert(location_map, {2656216, atlantica_clams_address[game_version]      + 0x1,    8, 0x01, 0}) --Atlantica Undersea Cave Clam
    table.insert(location_map, {2656300, world_flags_address[game_version]          + 0x1B,   0, 0x01, 0}) --Traverse Town Magician's Study Turn in Naturespark
    table.insert(location_map, {2656301, world_flags_address[game_version]          + 0x1C,   0, 0x01, 0}) --Traverse Town Magician's Study Turn in Watergleam
    table.insert(location_map, {2656302, world_flags_address[game_version]          + 0x1D,   0, 0x01, 0}) --Traverse Town Magician's Study Turn in Fireglow
    table.insert(location_map, {2656303, world_flags_address[game_version]          + 0x22,   0, 0x01, 0}) --Traverse Town Magician's Study Turn in all Summon Gems
    table.insert(location_map, {2656304, world_flags_address[game_version]          + 0x23,   0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto Reward 1
    table.insert(location_map, {2656305, world_flags_address[game_version]          + 0x24,   0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto Reward 2
    table.insert(location_map, {2656306, world_flags_address[game_version]          + 0x25,   0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto Reward 3
    table.insert(location_map, {2656307, world_flags_address[game_version]          + 0x26,   0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto Reward 4
    table.insert(location_map, {2656308, world_flags_address[game_version]          + 0x27,   0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto Reward 5
    table.insert(location_map, {2656309, world_flags_address[game_version]          + 0x29,   0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto All Summons Reward
    table.insert(location_map, {2656310, world_flags_address[game_version]          + 0x28,   0, 0x01, 0}) --Traverse Town Geppetto's House Talk to Pinocchio
    table.insert(location_map, {2656311, world_flags_address[game_version]          + 0x2B,   0, 0x01, 0}) --Traverse Town Magician's Study Obtained All Arts Items
    table.insert(location_map, {2656312, world_flags_address[game_version]          + 0x2C,   0, 0x01, 0}) --Traverse Town Magician's Study Obtained All LV1 Magic
    table.insert(location_map, {2656313, world_flags_address[game_version]          + 0x2D,   0, 0x01, 0}) --Traverse Town Magician's Study Obtained All LV3 Magic
    table.insert(location_map, {2656314, world_flags_address[game_version]          + 0x12F,  0, 0x01, 0}) --Traverse Town Piano Room Return 10 Puppies
    table.insert(location_map, {2656315, world_flags_address[game_version]          + 0x130,  0, 0x01, 0}) --Traverse Town Piano Room Return 20 Puppies
    table.insert(location_map, {2656316, world_flags_address[game_version]          + 0x131,  0, 0x01, 0}) --Traverse Town Piano Room Return 30 Puppies
    table.insert(location_map, {2656317, world_flags_address[game_version]          + 0x132,  0, 0x01, 0}) --Traverse Town Piano Room Return 40 Puppies
    table.insert(location_map, {2656318, world_flags_address[game_version]          + 0x133,  0, 0x01, 0}) --Traverse Town Piano Room Return 50 Puppies Reward 1
    table.insert(location_map, {2656319, world_flags_address[game_version]          + 0x133,  0, 0x01, 0}) --Traverse Town Piano Room Return 50 Puppies Reward 2
    table.insert(location_map, {2656320, world_flags_address[game_version]          + 0x134,  0, 0x01, 0}) --Traverse Town Piano Room Return 60 Puppies
    table.insert(location_map, {2656321, world_flags_address[game_version]          + 0x135,  0, 0x01, 0}) --Traverse Town Piano Room Return 70 Puppies
    table.insert(location_map, {2656322, world_flags_address[game_version]          + 0x136,  0, 0x01, 0}) --Traverse Town Piano Room Return 80 Puppies
    table.insert(location_map, {2656324, world_flags_address[game_version]          + 0x137,  0, 0x01, 0}) --Traverse Town Piano Room Return 90 Puppies
    table.insert(location_map, {2656326, world_flags_address[game_version]          + 0x138,  0, 0x01, 0}) --Traverse Town Piano Room Return 99 Puppies Reward 1
    table.insert(location_map, {2656327, world_flags_address[game_version]          + 0x138,  0, 0x01, 0}) --Traverse Town Piano Room Return 99 Puppies Reward 2
    table.insert(location_map, {2656032, world_flags_address[game_version]          + 0x1F5,  0, 0x0A, 0}) --Olympus Coliseum Cloud Sonic Blade Event
    table.insert(location_map, {2656328, world_flags_address[game_version]          + 0x25D,  0, 0x01, 0}) --Olympus Coliseum Defeat Sephiroth One-Winged Angel Event
    table.insert(location_map, {2656329, world_flags_address[game_version]          + 0x25C,  0, 0x01, 0}) --Olympus Coliseum Defeat Ice Titan Diamond Dust Event
    table.insert(location_map, {2656330, world_flags_address[game_version]          + 0x1106, 0, 0x01, 0}) --Olympus Coliseum Gates Purple Jar After Defeating Hades
    table.insert(location_map, {2656331, world_flags_address[game_version]          + 0x10C3, 2, 0x01, 0}) --Halloween Town Guillotine Square Ring Jack's Doorbell 3 Times
    table.insert(location_map, {2656332, world_flags_address[game_version]          + 0x1154, 8, 0x01, 0}) --Neverland Clock Tower 01:00 Door
    table.insert(location_map, {2656333, world_flags_address[game_version]          + 0x1154, 7, 0x01, 0}) --Neverland Clock Tower 02:00 Door
    table.insert(location_map, {2656334, world_flags_address[game_version]          + 0x1154, 6, 0x01, 0}) --Neverland Clock Tower 03:00 Door
    table.insert(location_map, {2656335, world_flags_address[game_version]          + 0x1154, 5, 0x01, 0}) --Neverland Clock Tower 04:00 Door
    table.insert(location_map, {2656336, world_flags_address[game_version]          + 0x1154, 4, 0x01, 0}) --Neverland Clock Tower 05:00 Door
    table.insert(location_map, {2656337, world_flags_address[game_version]          + 0x1154, 3, 0x01, 0}) --Neverland Clock Tower 06:00 Door
    table.insert(location_map, {2656338, world_flags_address[game_version]          + 0x1154, 2, 0x01, 0}) --Neverland Clock Tower 07:00 Door
    table.insert(location_map, {2656339, world_flags_address[game_version]          + 0x1154, 1, 0x01, 0}) --Neverland Clock Tower 08:00 Door
    table.insert(location_map, {2656340, world_flags_address[game_version]          + 0x1155, 8, 0x01, 0}) --Neverland Clock Tower 09:00 Door
    table.insert(location_map, {2656341, world_flags_address[game_version]          + 0x1155, 7, 0x01, 0}) --Neverland Clock Tower 10:00 Door
    table.insert(location_map, {2656342, world_flags_address[game_version]          + 0x1155, 6, 0x01, 0}) --Neverland Clock Tower 11:00 Door
    table.insert(location_map, {2656343, world_flags_address[game_version]          + 0x1155, 5, 0x01, 0}) --Neverland Clock Tower 12:00 Door
    table.insert(location_map, {2656344, world_flags_address[game_version]          + 0x1155, 2, 0x01, 0}) --Neverland Hold Aero Chest
    table.insert(location_map, {2656345, world_flags_address[game_version]          + 0x6F4,  0, 0x01, 1}) --100 Acre Wood Bouncing Spot Turn in Rare Nut 1
    table.insert(location_map, {2656346, world_flags_address[game_version]          + 0x6F4,  0, 0x02, 1}) --100 Acre Wood Bouncing Spot Turn in Rare Nut 2
    table.insert(location_map, {2656347, world_flags_address[game_version]          + 0x6F4,  0, 0x03, 1}) --100 Acre Wood Bouncing Spot Turn in Rare Nut 3
    table.insert(location_map, {2656348, world_flags_address[game_version]          + 0x6F4,  0, 0x04, 1}) --100 Acre Wood Bouncing Spot Turn in Rare Nut 4
    table.insert(location_map, {2656349, world_flags_address[game_version]          + 0x6F4,  0, 0x05, 1}) --100 Acre Wood Bouncing Spot Turn in Rare Nut 5
    table.insert(location_map, {2656350, world_flags_address[game_version]          + 0x702,  0, 0x01, 0}) --100 Acre Wood Pooh's House Owl Cheer
    table.insert(location_map, {2656351, world_flags_address[game_version]          + 0x703,  0, 0x01, 0}) --100 Acre Wood Convert Torn Page 1
    table.insert(location_map, {2656352, world_flags_address[game_version]          + 0x704,  0, 0x01, 0}) --100 Acre Wood Convert Torn Page 2
    table.insert(location_map, {2656353, world_flags_address[game_version]          + 0x705,  0, 0x01, 0}) --100 Acre Wood Convert Torn Page 3
    table.insert(location_map, {2656354, world_flags_address[game_version]          + 0x706,  0, 0x01, 0}) --100 Acre Wood Convert Torn Page 4
    table.insert(location_map, {2656355, world_flags_address[game_version]          + 0x707,  0, 0x01, 0}) --100 Acre Wood Convert Torn Page 5
    table.insert(location_map, {2656356, world_flags_address[game_version]          + 0x719,  0, 0x04, 0}) --100 Acre Wood Pooh's House Start Fire
    table.insert(location_map, {2656357, world_flags_address[game_version]          + 0x1036, 0, 0x04, 0}) --100 Acre Wood Pooh's Room Cabinet
    table.insert(location_map, {2656358, world_flags_address[game_version]          + 0x1037, 0, 0x04, 0}) --100 Acre Wood Pooh's Room Chimney
    table.insert(location_map, {2656359, world_flags_address[game_version]          + 0x1038, 0, 0x04, 0}) --100 Acre Wood Bouncing Spot Break Log
    table.insert(location_map, {2656360, world_flags_address[game_version]          + 0x1039, 0, 0x04, 0}) --100 Acre Wood Bouncing Spot Fall Through Top of Tree Next to Pooh
    table.insert(location_map, {2656361, world_flags_address[game_version]          + 0x1012, 0, 0x01, 0}) --Deep Jungle Camp Hi-Potion Experiment
    table.insert(location_map, {2656361, world_flags_address[game_version]          + 0x1011, 0, 0x01, 0}) --Deep Jungle Camp Hi-Potion Experiment
    table.insert(location_map, {2656362, world_flags_address[game_version]          + 0x100C, 0, 0x01, 0}) --Deep Jungle Camp Ether Experiment
    table.insert(location_map, {2656363, world_flags_address[game_version]          + 0x101A, 0, 0x01, 0}) --Deep Jungle Camp Replication Experiment
    table.insert(location_map, {2656364, world_flags_address[game_version]          + 0x500,  0, 0x01, 0}) --Deep Jungle Cliff Save Gorillas
    table.insert(location_map, {2656365, world_flags_address[game_version]          + 0x501,  0, 0x01, 0}) --Deep Jungle Tree House Save Gorillas
    table.insert(location_map, {2656366, world_flags_address[game_version]          + 0x502,  0, 0x01, 0}) --Deep Jungle Camp Save Gorillas
    table.insert(location_map, {2656367, world_flags_address[game_version]          + 0x503,  0, 0x01, 0}) --Deep Jungle Bamboo Thicket Save Gorillas
    table.insert(location_map, {2656368, world_flags_address[game_version]          + 0x504,  0, 0x01, 0}) --Deep Jungle Climbing Trees Save Gorillas
    table.insert(location_map, {2656369, world_flags_address[game_version]          + 0x21C,  2, 0x01, 0}) --Olympus Coliseum Olympia Chest
    table.insert(location_map, {2656370, world_flags_address[game_version]          + 0x102C, 0, 0x01, 0}) --Deep Jungle Jungle Slider 10 Fruits
    table.insert(location_map, {2656371, world_flags_address[game_version]          + 0x102D, 0, 0x01, 0}) --Deep Jungle Jungle Slider 20 Fruits
    table.insert(location_map, {2656372, world_flags_address[game_version]          + 0x102E, 0, 0x01, 0}) --Deep Jungle Jungle Slider 30 Fruits
    table.insert(location_map, {2656373, world_flags_address[game_version]          + 0x102F, 0, 0x01, 0}) --Deep Jungle Jungle Slider 40 Fruits
    table.insert(location_map, {2656374, world_flags_address[game_version]          + 0x1028, 0, 0x01, 0}) --Deep Jungle Jungle Slider 50 Fruits
    table.insert(location_map, {2656375, world_flags_address[game_version]          + 0xD,    0, 0x01, 0}) --Traverse Town 1st District Speak with Cid Event
    table.insert(location_map, {2656376, world_flags_address[game_version]          + 0xFD6,  8, 0x01, 0}) --Wonderland Bizarre Room Read Book
    table.insert(location_map, {2656377, world_flags_address[game_version]          + 0xF63,  4, 0x01, 0}) --Olympus Coliseum Coliseum Gates Green Trinity
    table.insert(location_map, {2656378, ansems_reports_address[game_version]       + 0x1,    6, 0x01, 0}) --Agrabah Defeat Kurt Zisa Zantetsuken Event
    table.insert(location_map, {2656379, ansems_reports_address[game_version]       + 0x1,    4, 0x01, 0}) --Hollow Bastion Defeat Unknown EXP Necklace Event
    table.insert(location_map, {2656380, world_progress_array_address[game_version] + 0x2,    0, 0x28, 0}) --Olympus Coliseum Coliseum Gates Hero's License Event
    table.insert(location_map, {2656381, world_progress_array_address[game_version] + 0x6,    0, 0x32, 0}) --Atlantica Sunken Ship Crystal Trident Event
    table.insert(location_map, {2656382, world_progress_array_address[game_version] + 0x8,    0, 0x1E, 0}) --Halloween Town Graveyard Forget-Me-Not Event
    table.insert(location_map, {2656383, world_progress_array_address[game_version] + 0x1,    0, 0x17, 0}) --Deep Jungle Tent Protect-G Event
    table.insert(location_map, {2656384, world_progress_array_address[game_version] + 0x1,    0, 0x5C, 0}) --Deep Jungle Cavern of Hearts Navi-G Piece Event
    table.insert(location_map, {2656385, world_progress_array_address[game_version] + 0x3,    0, 0x30, 0}) --Wonderland Bizarre Room Navi-G Piece Event
    table.insert(location_map, {2656386, world_progress_array_address[game_version] + 0x2,    0, 0x10, 0}) --Olympus Coliseum Coliseum Gates Entry Pass Event
    table.insert(location_map, {2656400, world_flags_address[game_version]          + 0xCC3,  0, 0x03, 0}) --Traverse Town Synth 15 Items
    table.insert(location_map, {2656401, world_flags_address[game_version]          + 0xCBB,  8, 0x01, 0}) --Traverse Town Synth Item 01
    table.insert(location_map, {2656402, world_flags_address[game_version]          + 0xCBB,  7, 0x01, 0}) --Traverse Town Synth Item 02
    table.insert(location_map, {2656403, world_flags_address[game_version]          + 0xCBB,  6, 0x01, 0}) --Traverse Town Synth Item 03
    table.insert(location_map, {2656404, world_flags_address[game_version]          + 0xCBB,  5, 0x01, 0}) --Traverse Town Synth Item 04
    table.insert(location_map, {2656405, world_flags_address[game_version]          + 0xCBB,  4, 0x01, 0}) --Traverse Town Synth Item 05
    table.insert(location_map, {2656406, world_flags_address[game_version]          + 0xCBB,  3, 0x01, 0}) --Traverse Town Synth Item 06
    table.insert(location_map, {2656407, world_flags_address[game_version]          + 0xCBB,  2, 0x01, 0}) --Traverse Town Synth Item 07
    table.insert(location_map, {2656408, world_flags_address[game_version]          + 0xCBB,  1, 0x01, 0}) --Traverse Town Synth Item 08
    table.insert(location_map, {2656409, world_flags_address[game_version]          + 0xCBC,  8, 0x01, 0}) --Traverse Town Synth Item 09
    table.insert(location_map, {2656410, world_flags_address[game_version]          + 0xCBC,  7, 0x01, 0}) --Traverse Town Synth Item 10
    table.insert(location_map, {2656411, world_flags_address[game_version]          + 0xCBC,  6, 0x01, 0}) --Traverse Town Synth Item 11
    table.insert(location_map, {2656412, world_flags_address[game_version]          + 0xCBC,  5, 0x01, 0}) --Traverse Town Synth Item 12
    table.insert(location_map, {2656413, world_flags_address[game_version]          + 0xCBC,  4, 0x01, 0}) --Traverse Town Synth Item 13
    table.insert(location_map, {2656414, world_flags_address[game_version]          + 0xCBC,  3, 0x01, 0}) --Traverse Town Synth Item 14
    table.insert(location_map, {2656415, world_flags_address[game_version]          + 0xCBC,  2, 0x01, 0}) --Traverse Town Synth Item 15
    table.insert(location_map, {2656416, world_flags_address[game_version]          + 0xCBC,  1, 0x01, 0}) --Traverse Town Synth Item 16
    table.insert(location_map, {2656417, world_flags_address[game_version]          + 0xCBD,  8, 0x01, 0}) --Traverse Town Synth Item 17
    table.insert(location_map, {2656418, world_flags_address[game_version]          + 0xCBD,  7, 0x01, 0}) --Traverse Town Synth Item 18
    table.insert(location_map, {2656419, world_flags_address[game_version]          + 0xCBD,  6, 0x01, 0}) --Traverse Town Synth Item 19
    table.insert(location_map, {2656420, world_flags_address[game_version]          + 0xCBD,  5, 0x01, 0}) --Traverse Town Synth Item 20
    table.insert(location_map, {2656421, world_flags_address[game_version]          + 0xCBD,  4, 0x01, 0}) --Traverse Town Synth Item 21
    table.insert(location_map, {2656422, world_flags_address[game_version]          + 0xCBD,  3, 0x01, 0}) --Traverse Town Synth Item 22
    table.insert(location_map, {2656423, world_flags_address[game_version]          + 0xCBD,  2, 0x01, 0}) --Traverse Town Synth Item 23
    table.insert(location_map, {2656424, world_flags_address[game_version]          + 0xCBD,  1, 0x01, 0}) --Traverse Town Synth Item 24
    table.insert(location_map, {2656425, world_flags_address[game_version]          + 0xCBE,  8, 0x01, 0}) --Traverse Town Synth Item 25
    table.insert(location_map, {2656426, world_flags_address[game_version]          + 0xCBE,  7, 0x01, 0}) --Traverse Town Synth Item 26
    table.insert(location_map, {2656427, world_flags_address[game_version]          + 0xCBE,  6, 0x01, 0}) --Traverse Town Synth Item 27
    table.insert(location_map, {2656428, world_flags_address[game_version]          + 0xCBE,  5, 0x01, 0}) --Traverse Town Synth Item 28
    table.insert(location_map, {2656429, world_flags_address[game_version]          + 0xCBE,  4, 0x01, 0}) --Traverse Town Synth Item 29
    table.insert(location_map, {2656430, world_flags_address[game_version]          + 0xCBE,  3, 0x01, 0}) --Traverse Town Synth Item 30
    table.insert(location_map, {2656431, world_flags_address[game_version]          + 0xCBE,  2, 0x01, 0}) --Traverse Town Synth Item 31
    table.insert(location_map, {2656432, world_flags_address[game_version]          + 0xCBE,  1, 0x01, 0}) --Traverse Town Synth Item 32
    table.insert(location_map, {2656433, world_flags_address[game_version]          + 0xCBF,  8, 0x01, 0}) --Traverse Town Synth Item 33
    table.insert(location_map, {2656500, world_flags_address[game_version]          + 0xFB3,  8, 0x01, 0}) --Traverse Town Item Shop Postcard
    table.insert(location_map, {2656501, world_flags_address[game_version]          + 0xFAA,  0, 0x01, 0}) --Traverse Town 1st District Safe Postcard
    table.insert(location_map, {2656502, world_flags_address[game_version]          + 0xFB1,  6, 0x01, 0}) --Traverse Town Gizmo Shop Postcard 1
    table.insert(location_map, {2656503, world_flags_address[game_version]          + 0xFB1,  6, 0x01, 0}) --Traverse Town Gizmo Shop Postcard 2
    table.insert(location_map, {2656504, world_flags_address[game_version]          + 0xFB3,  5, 0x01, 0}) --Traverse Town Item Workshop Postcard
    table.insert(location_map, {2656505, world_flags_address[game_version]          + 0xFB3,  7, 0x01, 0}) --Traverse Town 3rd District Balcony Postcard
    table.insert(location_map, {2656506, world_flags_address[game_version]          + 0xFB3,  4, 0x01, 0}) --Traverse Town Geppetto's House Postcard
    table.insert(location_map, {2656508, world_flags_address[game_version]          + 0x10C3, 1, 0x01, 0}) --Halloween Town Lab Torn Page
    table.insert(location_map, {2656516, world_flags_address[game_version]          + 0x11A1, 0, 0x02, 0}) --Hollow Bastion Entrance Hall Emblem Piece (Flame)
    table.insert(location_map, {2656517, world_flags_address[game_version]          + 0x11A2, 0, 0x02, 0}) --Hollow Bastion Entrance Hall Emblem Piece (Chest)
    table.insert(location_map, {2656518, world_flags_address[game_version]          + 0x11A3, 0, 0x02, 0}) --Hollow Bastion Entrance Hall Emblem Piece (Statue)
    table.insert(location_map, {2656519, world_flags_address[game_version]          + 0x11A4, 0, 0x02, 0}) --Hollow Bastion Entrance Hall Emblem Piece (Fountain)
    table.insert(location_map, {2656520, world_progress_array_address[game_version] + 0x0,    0, 0x31, 0}) --Traverse Town 1st District Leon Gift
    table.insert(location_map, {2656521, world_flags_address[game_version]          + 0x2,    0, 0x01, 0}) --Traverse Town 1st District Aerith Gift
    table.insert(location_map, {2656522, world_flags_address[game_version]          + 0x402,  0, 0x01, 0}) --Hollow Bastion Library Speak to Belle Divine Rose
    table.insert(location_map, {2656523, world_flags_address[game_version]          + 0x401,  0, 0x01, 0}) --Hollow Bastion Library Speak to Aerith Cure
    table.insert(location_map, {2656600, event_flags[game_version]                  + 0xE64,  7, 0x01, 0}) --Traverse Town 1st District Blue Trinity by Exit Door
    table.insert(location_map, {2656601, event_flags[game_version]                  + 0xEAB,  4, 0x01, 0}) --Traverse Town 3rd District Blue Trinity
    table.insert(location_map, {2656602, event_flags[game_version]                  + 0xEA9,  1, 0x01, 0}) --Traverse Town Magician's Study Blue Trinity
    table.insert(location_map, {2656603, event_flags[game_version]                  + 0xE66,  7, 0x01, 0}) --Wonderland Lotus Forest Blue Trinity in Alcove
    table.insert(location_map, {2656604, event_flags[game_version]                  + 0xE66,  6, 0x01, 0}) --Wonderland Lotus Forest Blue Trinity by Moving Boulder
    table.insert(location_map, {2656605, event_flags[game_version]                  + 0xE6C,  7, 0x01, 0}) --Agrabah Bazaar Blue Trinity
    table.insert(location_map, {2656606, event_flags[game_version]                  + 0xE6E,  6, 0x01, 0}) --Monstro Mouth Blue Trinity
    table.insert(location_map, {2656607, event_flags[game_version]                  + 0xE6E,  4, 0x01, 0}) --Monstro Chamber 5 Blue Trinity
    table.insert(location_map, {2656608, event_flags[game_version]                  + 0xE73,  7, 0x01, 0}) --Hollow Bastion Great Crest Blue Trinity
    table.insert(location_map, {2656609, event_flags[game_version]                  + 0xE73,  6, 0x01, 0}) --Hollow Bastion Dungeon Blue Trinity
    table.insert(location_map, {2656610, event_flags[game_version]                  + 0xE6A,  4, 0x01, 0}) --Deep Jungle Treetop Green Trinity
    table.insert(location_map, {2656611, event_flags[game_version]                  + 0xE6C,  4, 0x01, 0}) --Agrabah Treasure Room Red Trinity
    table.insert(location_map, {2656612, event_flags[game_version]                  + 0xE6E,  5, 0x01, 0}) --Monstro Throat Blue Trinity
    table.insert(location_map, {2656613, event_flags[game_version]                  + 0xEDA,  8, 0x01, 0}) --Wonderland Bizarre Room Examine Flower Pot
    table.insert(location_map, {2656614, event_flags[game_version]                  + 0xEE0,  5, 0x01, 0}) --Wonderland Lotus Forest Red Flowers on the Main Path
    table.insert(location_map, {2656614, event_flags[game_version]                  + 0xEE0,  2, 0x01, 0}) --Wonderland Lotus Forest Red Flowers on the Main Path
    table.insert(location_map, {2656615, event_flags[game_version]                  + 0xEE0,  8, 0x01, 0}) --Wonderland Lotus Forest Yellow Flowers in Middle Clearing and Through Painting
    table.insert(location_map, {2656615, event_flags[game_version]                  + 0xEE0,  6, 0x01, 0}) --Wonderland Lotus Forest Yellow Flowers in Middle Clearing and Through Painting
    table.insert(location_map, {2656616, event_flags[game_version]                  + 0xEE0,  7, 0x01, 0}) --Wonderland Lotus Forest Yellow Elixir Flower Through Painting
    table.insert(location_map, {2656617, event_flags[game_version]                  + 0xEE0,  3, 0x01, 0}) --Wonderland Lotus Forest Red Flower Raise Lily Pads
    table.insert(location_map, {2656618, event_flags[game_version]                  + 0xEE9,  7, 0x01, 0}) --Wonderland Tea Party Garden Left Cushioned Chair
    table.insert(location_map, {2656619, event_flags[game_version]                  + 0xEE9,  6, 0x01, 0}) --Wonderland Tea Party Garden Left Pink Chair
    table.insert(location_map, {2656620, event_flags[game_version]                  + 0xEE9,  2, 0x01, 0}) --Wonderland Tea Party Garden Right Yellow Chair
    table.insert(location_map, {2656621, event_flags[game_version]                  + 0xEE9,  5, 0x01, 0}) --Wonderland Tea Party Garden Left Gray Chair
    table.insert(location_map, {2656622, event_flags[game_version]                  + 0xEE9,  4, 0x01, 0}) --Wonderland Tea Party Garden Right Brown Chair
    table.insert(location_map, {2656623, event_flags[game_version]                  + 0x108D, 7, 0x01, 0}) --Hollow Bastion Lift Stop from Waterway Examine Node
    table.insert(location_map, {2656700, world_flags_address[game_version]          + 0x319,  0, 0x01, 0}) --Destiny Islands Seashore Capture Fish 1 (Day 2)
    table.insert(location_map, {2656701, world_flags_address[game_version]          + 0x31A,  0, 0x01, 0}) --Destiny Islands Seashore Capture Fish 2 (Day 2)
    table.insert(location_map, {2656702, world_flags_address[game_version]          + 0x31B,  0, 0x01, 0}) --Destiny Islands Seashore Capture Fish 3 (Day 2)
    table.insert(location_map, {2656703, world_flags_address[game_version]          + 0x303,  0, 0x01, 0}) --Destiny Islands Seashore Gather Seagull Egg (Day 2)
    table.insert(location_map, {2656705, world_flags_address[game_version]          + 0x326,  0, 0x01, 0}) --Destiny Islands Seashore Gather Log under Bridge (Day 1)
    table.insert(location_map, {2656706, world_flags_address[game_version]          + 0x327,  0, 0x01, 0}) --Destiny Islands Seashore Gather Cloth (Day 1)
    table.insert(location_map, {2656708, world_flags_address[game_version]          + 0x329,  0, 0x01, 0}) --Destiny Islands Seashore Defeat Riku (Day 1)
    table.insert(location_map, {2656704, world_flags_address[game_version]          + 0x325,  0, 0x01, 0}) --Destiny Islands Seashore Gather Log on Riku's Island (Day 1)
    table.insert(location_map, {2656707, world_flags_address[game_version]          + 0x31E,  0, 0x01, 0}) --Destiny Islands Seashore Gather Rope (Day 1)
    table.insert(location_map, {2656710, world_flags_address[game_version]          + 0x305,  0, 0x02, 0}) --Destiny Islands Seashore Deliver Kairi Items (Day 1)
    table.insert(location_map, {2656712, world_flags_address[game_version]          + 0x2FD,  0, 0x01, 0}) --Destiny Islands Cove Gather Mushroom Near Zip Line (Day 2)
    table.insert(location_map, {2656713, world_flags_address[game_version]          + 0x2FE,  0, 0x01, 0}) --Destiny Islands Cove Gather Mushroom in Small Cave (Day 2)
    table.insert(location_map, {2656714, world_flags_address[game_version]          + 0x2F3,  0, 0x01, 0}) --Destiny Islands Cove Talk to Kairi (Day 2)
    table.insert(location_map, {2656715, world_flags_address[game_version]          + 0x2FA,  0, 0x01, 0}) --Destiny Islands Gather Drinking Water (Day 2)
    table.insert(location_map, {2656711, world_flags_address[game_version]          + 0x31C,  0, 0x01, 0}) --Destiny Islands Secret Place Gather Mushroom (Day 2)
    table.insert(location_map, {2656716, world_flags_address[game_version]          + 0x301,  0, 0x02, 0}) --Destiny Islands Cove Deliver Kairi Items (Day 2)
    table.insert(location_map, {2656800, soras_level_address[game_version]          + 0x0,    0, 0x01, 0}) --Donald Starting Accessory 1
    table.insert(location_map, {2656801, soras_level_address[game_version]          + 0x0,    0, 0x01, 0}) --Donald Starting Accessory 2
    table.insert(location_map, {2656802, soras_level_address[game_version]          + 0x0,    0, 0x01, 0}) --Goofy Starting Accessory 1
    table.insert(location_map, {2656803, soras_level_address[game_version]          + 0x0,    0, 0x01, 0}) --Goofy Starting Accessory 2
    table.insert(location_map, {2656804, world_progress_array_address[game_version] + 0x1,    0, 0x14, 0}) --Tarzan Starting Accessory 1
    table.insert(location_map, {2656805, world_progress_array_address[game_version] + 0x4,    0, 0x24, 0}) --Aladdin Starting Accessory 1
    table.insert(location_map, {2656806, world_progress_array_address[game_version] + 0x4,    0, 0x24, 0}) --Aladdin Starting Accessory 2
    table.insert(location_map, {2656807, world_progress_array_address[game_version] + 0x6,    0, 0x0A, 0}) --Ariel Starting Accessory 1
    table.insert(location_map, {2656808, world_progress_array_address[game_version] + 0x6,    0, 0x0A, 0}) --Ariel Starting Accessory 2
    table.insert(location_map, {2656809, world_progress_array_address[game_version] + 0x6,    0, 0x0A, 0}) --Ariel Starting Accessory 3
    table.insert(location_map, {2656810, world_progress_array_address[game_version] + 0x8,    0, 0x07, 0}) --Jack Starting Accessory 1
    table.insert(location_map, {2656811, world_progress_array_address[game_version] + 0x8,    0, 0x07, 0}) --Jack Starting Accessory 2
    table.insert(location_map, {2656812, world_progress_array_address[game_version] + 0x9,    0, 0x0A, 0}) --Peter Pan Starting Accessory 1
    table.insert(location_map, {2656813, world_progress_array_address[game_version] + 0x9,    0, 0x0A, 0}) --Peter Pan Starting Accessory 2
    table.insert(location_map, {2656814, world_progress_array_address[game_version] + 0xA,    0, 0x1E, 0}) --Beast Starting Accessory 1
    table.insert(location_map, {2657018, ansems_reports_address[game_version]       + 0x0,    8, 0x01, 0}) --Agrabah Defeat Jafar Genie Ansem's Report 1
    table.insert(location_map, {2657017, ansems_reports_address[game_version]       + 0x0,    7, 0x01, 0}) --Hollow Bastion Speak with Aerith Ansem's Report 2
    table.insert(location_map, {2657016, ansems_reports_address[game_version]       + 0x0,    6, 0x01, 0}) --Atlantica Defeat Ursula II Ansem's Report 3
    table.insert(location_map, {2657015, ansems_reports_address[game_version]       + 0x0,    5, 0x01, 0}) --Hollow Bastion Speak with Aerith Ansem's Report 4
    table.insert(location_map, {2657014, ansems_reports_address[game_version]       + 0x0,    4, 0x01, 0}) --Hollow Bastion Defeat Maleficent Ansem's Report 5
    table.insert(location_map, {2657013, ansems_reports_address[game_version]       + 0x0,    3, 0x01, 0}) --Hollow Bastion Speak with Aerith Ansem's Report 6
    table.insert(location_map, {2657012, ansems_reports_address[game_version]       + 0x0,    2, 0x01, 0}) --Halloween Town Defeat Oogie Boogie Ansem's Report 7
    table.insert(location_map, {2657011, ansems_reports_address[game_version]       + 0x0,    1, 0x01, 0}) --Olympus Coliseum Defeat Hades Ansem's Report 8
    table.insert(location_map, {2657028, ansems_reports_address[game_version]       + 0x1,    8, 0x01, 0}) --Neverland Defeat Hook Ansem's Report 9
    table.insert(location_map, {2657027, ansems_reports_address[game_version]       + 0x1,    7, 0x01, 0}) --Hollow Bastion Speak with Aerith Ansem's Report 10
    table.insert(location_map, {2657026, ansems_reports_address[game_version]       + 0x1,    6, 0x01, 0}) --Agrabah Defeat Kurt Zisa Ansem's Report 11
    table.insert(location_map, {2657025, ansems_reports_address[game_version]       + 0x1,    5, 0x01, 0}) --Olympus Coliseum Defeat Sephiroth Ansem's Report 12
    table.insert(location_map, {2657024, ansems_reports_address[game_version]       + 0x1,    4, 0x01, 0}) --Hollow Bastion Defeat Unknown Ansem's Report 13
    table.insert(location_map, {2658001, soras_level_address[game_version]          + 0x0,    0, 0x01, 0}) --Level 001 (Slot 1)
    table.insert(location_map, {2658002, soras_level_address[game_version]          + 0x0,    0, 0x02, 0}) --Level 002 (Slot 1)
    table.insert(location_map, {2658003, soras_level_address[game_version]          + 0x0,    0, 0x03, 0}) --Level 003 (Slot 1)
    table.insert(location_map, {2658004, soras_level_address[game_version]          + 0x0,    0, 0x04, 0}) --Level 004 (Slot 1)
    table.insert(location_map, {2658005, soras_level_address[game_version]          + 0x0,    0, 0x05, 0}) --Level 005 (Slot 1)
    table.insert(location_map, {2658006, soras_level_address[game_version]          + 0x0,    0, 0x06, 0}) --Level 006 (Slot 1)
    table.insert(location_map, {2658007, soras_level_address[game_version]          + 0x0,    0, 0x07, 0}) --Level 007 (Slot 1)
    table.insert(location_map, {2658008, soras_level_address[game_version]          + 0x0,    0, 0x08, 0}) --Level 008 (Slot 1)
    table.insert(location_map, {2658009, soras_level_address[game_version]          + 0x0,    0, 0x09, 0}) --Level 009 (Slot 1)
    table.insert(location_map, {2658010, soras_level_address[game_version]          + 0x0,    0, 0x0A, 0}) --Level 010 (Slot 1)
    table.insert(location_map, {2658011, soras_level_address[game_version]          + 0x0,    0, 0x0B, 0}) --Level 011 (Slot 1)
    table.insert(location_map, {2658012, soras_level_address[game_version]          + 0x0,    0, 0x0C, 0}) --Level 012 (Slot 1)
    table.insert(location_map, {2658013, soras_level_address[game_version]          + 0x0,    0, 0x0D, 0}) --Level 013 (Slot 1)
    table.insert(location_map, {2658014, soras_level_address[game_version]          + 0x0,    0, 0x0E, 0}) --Level 014 (Slot 1)
    table.insert(location_map, {2658015, soras_level_address[game_version]          + 0x0,    0, 0x0F, 0}) --Level 015 (Slot 1)
    table.insert(location_map, {2658016, soras_level_address[game_version]          + 0x0,    0, 0x10, 0}) --Level 016 (Slot 1)
    table.insert(location_map, {2658017, soras_level_address[game_version]          + 0x0,    0, 0x11, 0}) --Level 017 (Slot 1)
    table.insert(location_map, {2658018, soras_level_address[game_version]          + 0x0,    0, 0x12, 0}) --Level 018 (Slot 1)
    table.insert(location_map, {2658019, soras_level_address[game_version]          + 0x0,    0, 0x13, 0}) --Level 019 (Slot 1)
    table.insert(location_map, {2658020, soras_level_address[game_version]          + 0x0,    0, 0x14, 0}) --Level 020 (Slot 1)
    table.insert(location_map, {2658021, soras_level_address[game_version]          + 0x0,    0, 0x15, 0}) --Level 021 (Slot 1)
    table.insert(location_map, {2658022, soras_level_address[game_version]          + 0x0,    0, 0x16, 0}) --Level 022 (Slot 1)
    table.insert(location_map, {2658023, soras_level_address[game_version]          + 0x0,    0, 0x17, 0}) --Level 023 (Slot 1)
    table.insert(location_map, {2658024, soras_level_address[game_version]          + 0x0,    0, 0x18, 0}) --Level 024 (Slot 1)
    table.insert(location_map, {2658025, soras_level_address[game_version]          + 0x0,    0, 0x19, 0}) --Level 025 (Slot 1)
    table.insert(location_map, {2658026, soras_level_address[game_version]          + 0x0,    0, 0x1A, 0}) --Level 026 (Slot 1)
    table.insert(location_map, {2658027, soras_level_address[game_version]          + 0x0,    0, 0x1B, 0}) --Level 027 (Slot 1)
    table.insert(location_map, {2658028, soras_level_address[game_version]          + 0x0,    0, 0x1C, 0}) --Level 028 (Slot 1)
    table.insert(location_map, {2658029, soras_level_address[game_version]          + 0x0,    0, 0x1D, 0}) --Level 029 (Slot 1)
    table.insert(location_map, {2658030, soras_level_address[game_version]          + 0x0,    0, 0x1E, 0}) --Level 030 (Slot 1)
    table.insert(location_map, {2658031, soras_level_address[game_version]          + 0x0,    0, 0x1F, 0}) --Level 031 (Slot 1)
    table.insert(location_map, {2658032, soras_level_address[game_version]          + 0x0,    0, 0x20, 0}) --Level 032 (Slot 1)
    table.insert(location_map, {2658033, soras_level_address[game_version]          + 0x0,    0, 0x21, 0}) --Level 033 (Slot 1)
    table.insert(location_map, {2658034, soras_level_address[game_version]          + 0x0,    0, 0x22, 0}) --Level 034 (Slot 1)
    table.insert(location_map, {2658035, soras_level_address[game_version]          + 0x0,    0, 0x23, 0}) --Level 035 (Slot 1)
    table.insert(location_map, {2658036, soras_level_address[game_version]          + 0x0,    0, 0x24, 0}) --Level 036 (Slot 1)
    table.insert(location_map, {2658037, soras_level_address[game_version]          + 0x0,    0, 0x25, 0}) --Level 037 (Slot 1)
    table.insert(location_map, {2658038, soras_level_address[game_version]          + 0x0,    0, 0x26, 0}) --Level 038 (Slot 1)
    table.insert(location_map, {2658039, soras_level_address[game_version]          + 0x0,    0, 0x27, 0}) --Level 039 (Slot 1)
    table.insert(location_map, {2658040, soras_level_address[game_version]          + 0x0,    0, 0x28, 0}) --Level 040 (Slot 1)
    table.insert(location_map, {2658041, soras_level_address[game_version]          + 0x0,    0, 0x29, 0}) --Level 041 (Slot 1)
    table.insert(location_map, {2658042, soras_level_address[game_version]          + 0x0,    0, 0x2A, 0}) --Level 042 (Slot 1)
    table.insert(location_map, {2658043, soras_level_address[game_version]          + 0x0,    0, 0x2B, 0}) --Level 043 (Slot 1)
    table.insert(location_map, {2658044, soras_level_address[game_version]          + 0x0,    0, 0x2C, 0}) --Level 044 (Slot 1)
    table.insert(location_map, {2658045, soras_level_address[game_version]          + 0x0,    0, 0x2D, 0}) --Level 045 (Slot 1)
    table.insert(location_map, {2658046, soras_level_address[game_version]          + 0x0,    0, 0x2E, 0}) --Level 046 (Slot 1)
    table.insert(location_map, {2658047, soras_level_address[game_version]          + 0x0,    0, 0x2F, 0}) --Level 047 (Slot 1)
    table.insert(location_map, {2658048, soras_level_address[game_version]          + 0x0,    0, 0x30, 0}) --Level 048 (Slot 1)
    table.insert(location_map, {2658049, soras_level_address[game_version]          + 0x0,    0, 0x31, 0}) --Level 049 (Slot 1)
    table.insert(location_map, {2658050, soras_level_address[game_version]          + 0x0,    0, 0x32, 0}) --Level 050 (Slot 1)
    table.insert(location_map, {2658051, soras_level_address[game_version]          + 0x0,    0, 0x33, 0}) --Level 051 (Slot 1)
    table.insert(location_map, {2658052, soras_level_address[game_version]          + 0x0,    0, 0x34, 0}) --Level 052 (Slot 1)
    table.insert(location_map, {2658053, soras_level_address[game_version]          + 0x0,    0, 0x35, 0}) --Level 053 (Slot 1)
    table.insert(location_map, {2658054, soras_level_address[game_version]          + 0x0,    0, 0x36, 0}) --Level 054 (Slot 1)
    table.insert(location_map, {2658055, soras_level_address[game_version]          + 0x0,    0, 0x37, 0}) --Level 055 (Slot 1)
    table.insert(location_map, {2658056, soras_level_address[game_version]          + 0x0,    0, 0x38, 0}) --Level 056 (Slot 1)
    table.insert(location_map, {2658057, soras_level_address[game_version]          + 0x0,    0, 0x39, 0}) --Level 057 (Slot 1)
    table.insert(location_map, {2658058, soras_level_address[game_version]          + 0x0,    0, 0x3A, 0}) --Level 058 (Slot 1)
    table.insert(location_map, {2658059, soras_level_address[game_version]          + 0x0,    0, 0x3B, 0}) --Level 059 (Slot 1)
    table.insert(location_map, {2658060, soras_level_address[game_version]          + 0x0,    0, 0x3C, 0}) --Level 060 (Slot 1)
    table.insert(location_map, {2658061, soras_level_address[game_version]          + 0x0,    0, 0x3D, 0}) --Level 061 (Slot 1)
    table.insert(location_map, {2658062, soras_level_address[game_version]          + 0x0,    0, 0x3E, 0}) --Level 062 (Slot 1)
    table.insert(location_map, {2658063, soras_level_address[game_version]          + 0x0,    0, 0x3F, 0}) --Level 063 (Slot 1)
    table.insert(location_map, {2658064, soras_level_address[game_version]          + 0x0,    0, 0x40, 0}) --Level 064 (Slot 1)
    table.insert(location_map, {2658065, soras_level_address[game_version]          + 0x0,    0, 0x41, 0}) --Level 065 (Slot 1)
    table.insert(location_map, {2658066, soras_level_address[game_version]          + 0x0,    0, 0x42, 0}) --Level 066 (Slot 1)
    table.insert(location_map, {2658067, soras_level_address[game_version]          + 0x0,    0, 0x43, 0}) --Level 067 (Slot 1)
    table.insert(location_map, {2658068, soras_level_address[game_version]          + 0x0,    0, 0x44, 0}) --Level 068 (Slot 1)
    table.insert(location_map, {2658069, soras_level_address[game_version]          + 0x0,    0, 0x45, 0}) --Level 069 (Slot 1)
    table.insert(location_map, {2658070, soras_level_address[game_version]          + 0x0,    0, 0x46, 0}) --Level 070 (Slot 1)
    table.insert(location_map, {2658071, soras_level_address[game_version]          + 0x0,    0, 0x47, 0}) --Level 071 (Slot 1)
    table.insert(location_map, {2658072, soras_level_address[game_version]          + 0x0,    0, 0x48, 0}) --Level 072 (Slot 1)
    table.insert(location_map, {2658073, soras_level_address[game_version]          + 0x0,    0, 0x49, 0}) --Level 073 (Slot 1)
    table.insert(location_map, {2658074, soras_level_address[game_version]          + 0x0,    0, 0x4A, 0}) --Level 074 (Slot 1)
    table.insert(location_map, {2658075, soras_level_address[game_version]          + 0x0,    0, 0x4B, 0}) --Level 075 (Slot 1)
    table.insert(location_map, {2658076, soras_level_address[game_version]          + 0x0,    0, 0x4C, 0}) --Level 076 (Slot 1)
    table.insert(location_map, {2658077, soras_level_address[game_version]          + 0x0,    0, 0x4D, 0}) --Level 077 (Slot 1)
    table.insert(location_map, {2658078, soras_level_address[game_version]          + 0x0,    0, 0x4E, 0}) --Level 078 (Slot 1)
    table.insert(location_map, {2658079, soras_level_address[game_version]          + 0x0,    0, 0x4F, 0}) --Level 079 (Slot 1)
    table.insert(location_map, {2658080, soras_level_address[game_version]          + 0x0,    0, 0x50, 0}) --Level 080 (Slot 1)
    table.insert(location_map, {2658081, soras_level_address[game_version]          + 0x0,    0, 0x51, 0}) --Level 081 (Slot 1)
    table.insert(location_map, {2658082, soras_level_address[game_version]          + 0x0,    0, 0x52, 0}) --Level 082 (Slot 1)
    table.insert(location_map, {2658083, soras_level_address[game_version]          + 0x0,    0, 0x53, 0}) --Level 083 (Slot 1)
    table.insert(location_map, {2658084, soras_level_address[game_version]          + 0x0,    0, 0x54, 0}) --Level 084 (Slot 1)
    table.insert(location_map, {2658085, soras_level_address[game_version]          + 0x0,    0, 0x55, 0}) --Level 085 (Slot 1)
    table.insert(location_map, {2658086, soras_level_address[game_version]          + 0x0,    0, 0x56, 0}) --Level 086 (Slot 1)
    table.insert(location_map, {2658087, soras_level_address[game_version]          + 0x0,    0, 0x57, 0}) --Level 087 (Slot 1)
    table.insert(location_map, {2658088, soras_level_address[game_version]          + 0x0,    0, 0x58, 0}) --Level 088 (Slot 1)
    table.insert(location_map, {2658089, soras_level_address[game_version]          + 0x0,    0, 0x59, 0}) --Level 089 (Slot 1)
    table.insert(location_map, {2658090, soras_level_address[game_version]          + 0x0,    0, 0x5A, 0}) --Level 090 (Slot 1)
    table.insert(location_map, {2658091, soras_level_address[game_version]          + 0x0,    0, 0x5B, 0}) --Level 091 (Slot 1)
    table.insert(location_map, {2658092, soras_level_address[game_version]          + 0x0,    0, 0x5C, 0}) --Level 092 (Slot 1)
    table.insert(location_map, {2658093, soras_level_address[game_version]          + 0x0,    0, 0x5D, 0}) --Level 093 (Slot 1)
    table.insert(location_map, {2658094, soras_level_address[game_version]          + 0x0,    0, 0x5E, 0}) --Level 094 (Slot 1)
    table.insert(location_map, {2658095, soras_level_address[game_version]          + 0x0,    0, 0x5F, 0}) --Level 095 (Slot 1)
    table.insert(location_map, {2658096, soras_level_address[game_version]          + 0x0,    0, 0x60, 0}) --Level 096 (Slot 1)
    table.insert(location_map, {2658097, soras_level_address[game_version]          + 0x0,    0, 0x61, 0}) --Level 097 (Slot 1)
    table.insert(location_map, {2658098, soras_level_address[game_version]          + 0x0,    0, 0x62, 0}) --Level 098 (Slot 1)
    table.insert(location_map, {2658099, soras_level_address[game_version]          + 0x0,    0, 0x63, 0}) --Level 099 (Slot 1)
    table.insert(location_map, {2658100, soras_level_address[game_version]          + 0x0,    0, 0x64, 0}) --Level 100 (Slot 1)
    table.insert(location_map, {2658101, soras_level_address[game_version]          + 0x0,    0, 0x01, 0}) --Level 001 (Slot 2)
    table.insert(location_map, {2658102, soras_level_address[game_version]          + 0x0,    0, 0x02, 0}) --Level 002 (Slot 2)
    table.insert(location_map, {2658103, soras_level_address[game_version]          + 0x0,    0, 0x03, 0}) --Level 003 (Slot 2)
    table.insert(location_map, {2658104, soras_level_address[game_version]          + 0x0,    0, 0x04, 0}) --Level 004 (Slot 2)
    table.insert(location_map, {2658105, soras_level_address[game_version]          + 0x0,    0, 0x05, 0}) --Level 005 (Slot 2)
    table.insert(location_map, {2658106, soras_level_address[game_version]          + 0x0,    0, 0x06, 0}) --Level 006 (Slot 2)
    table.insert(location_map, {2658107, soras_level_address[game_version]          + 0x0,    0, 0x07, 0}) --Level 007 (Slot 2)
    table.insert(location_map, {2658108, soras_level_address[game_version]          + 0x0,    0, 0x08, 0}) --Level 008 (Slot 2)
    table.insert(location_map, {2658109, soras_level_address[game_version]          + 0x0,    0, 0x09, 0}) --Level 009 (Slot 2)
    table.insert(location_map, {2658110, soras_level_address[game_version]          + 0x0,    0, 0x0A, 0}) --Level 010 (Slot 2)
    table.insert(location_map, {2658111, soras_level_address[game_version]          + 0x0,    0, 0x0B, 0}) --Level 011 (Slot 2)
    table.insert(location_map, {2658112, soras_level_address[game_version]          + 0x0,    0, 0x0C, 0}) --Level 012 (Slot 2)
    table.insert(location_map, {2658113, soras_level_address[game_version]          + 0x0,    0, 0x0D, 0}) --Level 013 (Slot 2)
    table.insert(location_map, {2658114, soras_level_address[game_version]          + 0x0,    0, 0x0E, 0}) --Level 014 (Slot 2)
    table.insert(location_map, {2658115, soras_level_address[game_version]          + 0x0,    0, 0x0F, 0}) --Level 015 (Slot 2)
    table.insert(location_map, {2658116, soras_level_address[game_version]          + 0x0,    0, 0x10, 0}) --Level 016 (Slot 2)
    table.insert(location_map, {2658117, soras_level_address[game_version]          + 0x0,    0, 0x11, 0}) --Level 017 (Slot 2)
    table.insert(location_map, {2658118, soras_level_address[game_version]          + 0x0,    0, 0x12, 0}) --Level 018 (Slot 2)
    table.insert(location_map, {2658119, soras_level_address[game_version]          + 0x0,    0, 0x13, 0}) --Level 019 (Slot 2)
    table.insert(location_map, {2658120, soras_level_address[game_version]          + 0x0,    0, 0x14, 0}) --Level 020 (Slot 2)
    table.insert(location_map, {2658121, soras_level_address[game_version]          + 0x0,    0, 0x15, 0}) --Level 021 (Slot 2)
    table.insert(location_map, {2658122, soras_level_address[game_version]          + 0x0,    0, 0x16, 0}) --Level 022 (Slot 2)
    table.insert(location_map, {2658123, soras_level_address[game_version]          + 0x0,    0, 0x17, 0}) --Level 023 (Slot 2)
    table.insert(location_map, {2658124, soras_level_address[game_version]          + 0x0,    0, 0x18, 0}) --Level 024 (Slot 2)
    table.insert(location_map, {2658125, soras_level_address[game_version]          + 0x0,    0, 0x19, 0}) --Level 025 (Slot 2)
    table.insert(location_map, {2658126, soras_level_address[game_version]          + 0x0,    0, 0x1A, 0}) --Level 026 (Slot 2)
    table.insert(location_map, {2658127, soras_level_address[game_version]          + 0x0,    0, 0x1B, 0}) --Level 027 (Slot 2)
    table.insert(location_map, {2658128, soras_level_address[game_version]          + 0x0,    0, 0x1C, 0}) --Level 028 (Slot 2)
    table.insert(location_map, {2658129, soras_level_address[game_version]          + 0x0,    0, 0x1D, 0}) --Level 029 (Slot 2)
    table.insert(location_map, {2658130, soras_level_address[game_version]          + 0x0,    0, 0x1E, 0}) --Level 030 (Slot 2)
    table.insert(location_map, {2658131, soras_level_address[game_version]          + 0x0,    0, 0x1F, 0}) --Level 031 (Slot 2)
    table.insert(location_map, {2658132, soras_level_address[game_version]          + 0x0,    0, 0x20, 0}) --Level 032 (Slot 2)
    table.insert(location_map, {2658133, soras_level_address[game_version]          + 0x0,    0, 0x21, 0}) --Level 033 (Slot 2)
    table.insert(location_map, {2658134, soras_level_address[game_version]          + 0x0,    0, 0x22, 0}) --Level 034 (Slot 2)
    table.insert(location_map, {2658135, soras_level_address[game_version]          + 0x0,    0, 0x23, 0}) --Level 035 (Slot 2)
    table.insert(location_map, {2658136, soras_level_address[game_version]          + 0x0,    0, 0x24, 0}) --Level 036 (Slot 2)
    table.insert(location_map, {2658137, soras_level_address[game_version]          + 0x0,    0, 0x25, 0}) --Level 037 (Slot 2)
    table.insert(location_map, {2658138, soras_level_address[game_version]          + 0x0,    0, 0x26, 0}) --Level 038 (Slot 2)
    table.insert(location_map, {2658139, soras_level_address[game_version]          + 0x0,    0, 0x27, 0}) --Level 039 (Slot 2)
    table.insert(location_map, {2658140, soras_level_address[game_version]          + 0x0,    0, 0x28, 0}) --Level 040 (Slot 2)
    table.insert(location_map, {2658141, soras_level_address[game_version]          + 0x0,    0, 0x29, 0}) --Level 041 (Slot 2)
    table.insert(location_map, {2658142, soras_level_address[game_version]          + 0x0,    0, 0x2A, 0}) --Level 042 (Slot 2)
    table.insert(location_map, {2658143, soras_level_address[game_version]          + 0x0,    0, 0x2B, 0}) --Level 043 (Slot 2)
    table.insert(location_map, {2658144, soras_level_address[game_version]          + 0x0,    0, 0x2C, 0}) --Level 044 (Slot 2)
    table.insert(location_map, {2658145, soras_level_address[game_version]          + 0x0,    0, 0x2D, 0}) --Level 045 (Slot 2)
    table.insert(location_map, {2658146, soras_level_address[game_version]          + 0x0,    0, 0x2E, 0}) --Level 046 (Slot 2)
    table.insert(location_map, {2658147, soras_level_address[game_version]          + 0x0,    0, 0x2F, 0}) --Level 047 (Slot 2)
    table.insert(location_map, {2658148, soras_level_address[game_version]          + 0x0,    0, 0x30, 0}) --Level 048 (Slot 2)
    table.insert(location_map, {2658149, soras_level_address[game_version]          + 0x0,    0, 0x31, 0}) --Level 049 (Slot 2)
    table.insert(location_map, {2658150, soras_level_address[game_version]          + 0x0,    0, 0x32, 0}) --Level 050 (Slot 2)
    table.insert(location_map, {2658151, soras_level_address[game_version]          + 0x0,    0, 0x33, 0}) --Level 051 (Slot 2)
    table.insert(location_map, {2658152, soras_level_address[game_version]          + 0x0,    0, 0x34, 0}) --Level 052 (Slot 2)
    table.insert(location_map, {2658153, soras_level_address[game_version]          + 0x0,    0, 0x35, 0}) --Level 053 (Slot 2)
    table.insert(location_map, {2658154, soras_level_address[game_version]          + 0x0,    0, 0x36, 0}) --Level 054 (Slot 2)
    table.insert(location_map, {2658155, soras_level_address[game_version]          + 0x0,    0, 0x37, 0}) --Level 055 (Slot 2)
    table.insert(location_map, {2658156, soras_level_address[game_version]          + 0x0,    0, 0x38, 0}) --Level 056 (Slot 2)
    table.insert(location_map, {2658157, soras_level_address[game_version]          + 0x0,    0, 0x39, 0}) --Level 057 (Slot 2)
    table.insert(location_map, {2658158, soras_level_address[game_version]          + 0x0,    0, 0x3A, 0}) --Level 058 (Slot 2)
    table.insert(location_map, {2658159, soras_level_address[game_version]          + 0x0,    0, 0x3B, 0}) --Level 059 (Slot 2)
    table.insert(location_map, {2658160, soras_level_address[game_version]          + 0x0,    0, 0x3C, 0}) --Level 060 (Slot 2)
    table.insert(location_map, {2658161, soras_level_address[game_version]          + 0x0,    0, 0x3D, 0}) --Level 061 (Slot 2)
    table.insert(location_map, {2658162, soras_level_address[game_version]          + 0x0,    0, 0x3E, 0}) --Level 062 (Slot 2)
    table.insert(location_map, {2658163, soras_level_address[game_version]          + 0x0,    0, 0x3F, 0}) --Level 063 (Slot 2)
    table.insert(location_map, {2658164, soras_level_address[game_version]          + 0x0,    0, 0x40, 0}) --Level 064 (Slot 2)
    table.insert(location_map, {2658165, soras_level_address[game_version]          + 0x0,    0, 0x41, 0}) --Level 065 (Slot 2)
    table.insert(location_map, {2658166, soras_level_address[game_version]          + 0x0,    0, 0x42, 0}) --Level 066 (Slot 2)
    table.insert(location_map, {2658167, soras_level_address[game_version]          + 0x0,    0, 0x43, 0}) --Level 067 (Slot 2)
    table.insert(location_map, {2658168, soras_level_address[game_version]          + 0x0,    0, 0x44, 0}) --Level 068 (Slot 2)
    table.insert(location_map, {2658169, soras_level_address[game_version]          + 0x0,    0, 0x45, 0}) --Level 069 (Slot 2)
    table.insert(location_map, {2658170, soras_level_address[game_version]          + 0x0,    0, 0x46, 0}) --Level 070 (Slot 2)
    table.insert(location_map, {2658171, soras_level_address[game_version]          + 0x0,    0, 0x47, 0}) --Level 071 (Slot 2)
    table.insert(location_map, {2658172, soras_level_address[game_version]          + 0x0,    0, 0x48, 0}) --Level 072 (Slot 2)
    table.insert(location_map, {2658173, soras_level_address[game_version]          + 0x0,    0, 0x49, 0}) --Level 073 (Slot 2)
    table.insert(location_map, {2658174, soras_level_address[game_version]          + 0x0,    0, 0x4A, 0}) --Level 074 (Slot 2)
    table.insert(location_map, {2658175, soras_level_address[game_version]          + 0x0,    0, 0x4B, 0}) --Level 075 (Slot 2)
    table.insert(location_map, {2658176, soras_level_address[game_version]          + 0x0,    0, 0x4C, 0}) --Level 076 (Slot 2)
    table.insert(location_map, {2658177, soras_level_address[game_version]          + 0x0,    0, 0x4D, 0}) --Level 077 (Slot 2)
    table.insert(location_map, {2658178, soras_level_address[game_version]          + 0x0,    0, 0x4E, 0}) --Level 078 (Slot 2)
    table.insert(location_map, {2658179, soras_level_address[game_version]          + 0x0,    0, 0x4F, 0}) --Level 079 (Slot 2)
    table.insert(location_map, {2658180, soras_level_address[game_version]          + 0x0,    0, 0x50, 0}) --Level 080 (Slot 2)
    table.insert(location_map, {2658181, soras_level_address[game_version]          + 0x0,    0, 0x51, 0}) --Level 081 (Slot 2)
    table.insert(location_map, {2658182, soras_level_address[game_version]          + 0x0,    0, 0x52, 0}) --Level 082 (Slot 2)
    table.insert(location_map, {2658183, soras_level_address[game_version]          + 0x0,    0, 0x53, 0}) --Level 083 (Slot 2)
    table.insert(location_map, {2658184, soras_level_address[game_version]          + 0x0,    0, 0x54, 0}) --Level 084 (Slot 2)
    table.insert(location_map, {2658185, soras_level_address[game_version]          + 0x0,    0, 0x55, 0}) --Level 085 (Slot 2)
    table.insert(location_map, {2658186, soras_level_address[game_version]          + 0x0,    0, 0x56, 0}) --Level 086 (Slot 2)
    table.insert(location_map, {2658187, soras_level_address[game_version]          + 0x0,    0, 0x57, 0}) --Level 087 (Slot 2)
    table.insert(location_map, {2658188, soras_level_address[game_version]          + 0x0,    0, 0x58, 0}) --Level 088 (Slot 2)
    table.insert(location_map, {2658189, soras_level_address[game_version]          + 0x0,    0, 0x59, 0}) --Level 089 (Slot 2)
    table.insert(location_map, {2658190, soras_level_address[game_version]          + 0x0,    0, 0x5A, 0}) --Level 090 (Slot 2)
    table.insert(location_map, {2658191, soras_level_address[game_version]          + 0x0,    0, 0x5B, 0}) --Level 091 (Slot 2)
    table.insert(location_map, {2658192, soras_level_address[game_version]          + 0x0,    0, 0x5C, 0}) --Level 092 (Slot 2)
    table.insert(location_map, {2658193, soras_level_address[game_version]          + 0x0,    0, 0x5D, 0}) --Level 093 (Slot 2)
    table.insert(location_map, {2658194, soras_level_address[game_version]          + 0x0,    0, 0x5E, 0}) --Level 094 (Slot 2)
    table.insert(location_map, {2658195, soras_level_address[game_version]          + 0x0,    0, 0x5F, 0}) --Level 095 (Slot 2)
    table.insert(location_map, {2658196, soras_level_address[game_version]          + 0x0,    0, 0x60, 0}) --Level 096 (Slot 2)
    table.insert(location_map, {2658197, soras_level_address[game_version]          + 0x0,    0, 0x61, 0}) --Level 097 (Slot 2)
    table.insert(location_map, {2658198, soras_level_address[game_version]          + 0x0,    0, 0x62, 0}) --Level 098 (Slot 2)
    table.insert(location_map, {2658199, soras_level_address[game_version]          + 0x0,    0, 0x63, 0}) --Level 099 (Slot 2)
    table.insert(location_map, {2658200, soras_level_address[game_version]          + 0x0,    0, 0x64, 0}) --Level 100 (Slot 2)
    table.insert(location_map, {2659001, olympus_flags_address[game_version]        + 0x0,    0, 0x01, 0}) --Complete Phil Cup
    table.insert(location_map, {2659002, olympus_flags_address[game_version]        + 0x0,    0, 0x02, 0}) --Complete Phil Cup Solo
    table.insert(location_map, {2659003, olympus_flags_address[game_version]        + 0x0,    0, 0x03, 0}) --Complete Phil Cup Time Trial
    table.insert(location_map, {2659004, olympus_flags_address[game_version]        + 0x1,    0, 0x01, 0}) --Complete Pegasus Cup
    table.insert(location_map, {2659005, olympus_flags_address[game_version]        + 0x1,    0, 0x02, 0}) --Complete Pegasus Cup Solo
    table.insert(location_map, {2659006, olympus_flags_address[game_version]        + 0x1,    0, 0x03, 0}) --Complete Pegasus Cup Time Trial
    table.insert(location_map, {2659007, olympus_flags_address[game_version]        + 0x2,    0, 0x01, 0}) --Complete Hercules Cup
    table.insert(location_map, {2659008, olympus_flags_address[game_version]        + 0x2,    0, 0x02, 0}) --Complete Hercules Cup Solo
    table.insert(location_map, {2659009, olympus_flags_address[game_version]        + 0x2,    0, 0x03, 0}) --Complete Hercules Cup Time Trial
    table.insert(location_map, {2659010, olympus_flags_address[game_version]        + 0x3,    0, 0x01, 0}) --Complete Hades Cup
    table.insert(location_map, {2659011, olympus_flags_address[game_version]        + 0x3,    0, 0x02, 0}) --Complete Hades Cup Solo
    table.insert(location_map, {2659012, olympus_flags_address[game_version]        + 0x3,    0, 0x03, 0}) --Complete Hades Cup Time Trial
    table.insert(location_map, {2659013, olympus_flags_address[game_version]        + 0x11,   0, 0x01, 0}) --Hades Cup Defeat Cloud and Leon Event
    table.insert(location_map, {2659014, olympus_flags_address[game_version]        + 0x12,   0, 0x01, 0}) --Hades Cup Defeat Yuffie Event
    table.insert(location_map, {2659015, olympus_flags_address[game_version]        + 0x13,   0, 0x01, 0}) --Hades Cup Defeat Cerberus Event
    table.insert(location_map, {2659016, olympus_flags_address[game_version]        + 0x14,   0, 0x01, 0}) --Hades Cup Defeat Behemoth Event
    table.insert(location_map, {2659017, ansems_reports_address[game_version]       + 0x0,    1, 0x01, 0}) --Hades Cup Defeat Hades Event
    table.insert(location_map, {2659018, olympus_flags_address[game_version]        + 0x2,    0, 0x01, 0}) --Hercules Cup Defeat Cloud Event
    table.insert(location_map, {2659019, olympus_flags_address[game_version]        + 0x2,    0, 0x01, 0}) --Hercules Cup Yellow Trinity Event
    return location_map
end

function add_locations_to_locations_checked(frame_count)
    for index, data in pairs(location_map) do
        if index % 60 == frame_count then
            location_id = data[1]
            if not contains_item(game_state.locations, location_id) then
                address          = data[2]
                bit_num          = data[3]
                compare_value    = data[4]
                special_function = data[5]
                if special_function == 0 then
                    if bit_num > 0 then
                        value = toBits(ReadByte(address))[bit_num]
                        if value == nil then
                            value = 0
                        end
                    else
                        value = ReadByte(address)
                    end
                    if value >= compare_value then
                        game_state.locations[#game_state.locations + 1] = location_id
                    end
                end
                if special_function == 1 then -- Rare nuts
                    if ReadByte(address) - ReadByte(address + 0x6) >= compare_value then
                        game_state.locations[#game_state.locations + 1] = location_id
                    end
                end
            end
        end
    end
end