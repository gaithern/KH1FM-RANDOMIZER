-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------              by Gicu           -----
-------------------------------------------

LUAGUI_NAME = "1fmRandoSendAPLocations"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Send AP Locations"

canExecute = false
game_version = 1
frame_count = 0
location_map = {}

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

function fill_location_map()
    chests_opened_address        = {0x2DEA32C, 0x2DE992C}
    world_progress_array_address = {0x2DEB264, 0x2DEA864}
    atlantica_clams_address      = {0x2DEBB09, 0x2DEB109}
    world_flags_address          = {0x2DEAA6D, 0x2DEA06D}
    soras_level_address          = {0x2DE9D98, 0x2DE9398}
    ansems_reports_address       = {0x2DEB720, 0x2DEAD20}
    olympus_flags_address        = {0x2E01896, 0x2E00E96}
    --[[Each location is defined by the following values
        Location_ID
        Address
        Bit Number (0 if byte value)
        Compare Value
        Custom Logic ID
      ]]
    table.insert(location_map, {2650011, chests_opened_address[game_version]        +    0, 1, 0x01, 0}) --Destiny Islands Chest
    table.insert(location_map, {2650211, chests_opened_address[game_version]        +   20, 1, 0x01, 0}) --Traverse Town 1st District Candle Puzzle Chest
    table.insert(location_map, {2650212, chests_opened_address[game_version]        +   20, 2, 0x01, 0}) --Traverse Town Accessory Shop Roof Chest
    table.insert(location_map, {2650213, chests_opened_address[game_version]        +   20, 3, 0x01, 0}) --Traverse Town 2nd District Boots and Shoes Awning Chest
    table.insert(location_map, {2650214, chests_opened_address[game_version]        +   20, 4, 0x01, 0}) --Traverse Town 2nd District Rooftop Chest
    table.insert(location_map, {2650251, chests_opened_address[game_version]        +   24, 1, 0x01, 0}) --Traverse Town 2nd Distrcit Gizmo Shop Facade Chest
    table.insert(location_map, {2650252, chests_opened_address[game_version]        +   24, 2, 0x01, 0}) --Traverse Town Alleyway Balcony Chest
    table.insert(location_map, {2650253, chests_opened_address[game_version]        +   24, 3, 0x01, 0}) --Traverse Town Alleyway Blue Room Awning Chest
    table.insert(location_map, {2650254, chests_opened_address[game_version]        +   24, 4, 0x01, 0}) --Traverse Town Alleyway Corner Chest
    table.insert(location_map, {2650292, chests_opened_address[game_version]        +   28, 2, 0x01, 0}) --Traverse Town Green Room Clock Puzzle Chest
    table.insert(location_map, {2650293, chests_opened_address[game_version]        +   28, 3, 0x01, 0}) --Traverse Town Green Room Table Chest
    table.insert(location_map, {2650294, chests_opened_address[game_version]        +   28, 4, 0x01, 0}) --Traverse Town Red Room Chest
    table.insert(location_map, {2650331, chests_opened_address[game_version]        +   32, 1, 0x01, 0}) --Traverse Town Mystical House Yellow Trinity Chest
    table.insert(location_map, {2650332, chests_opened_address[game_version]        +   32, 2, 0x01, 0}) --Traverse Town Accessory Shop Chest
    table.insert(location_map, {2650333, chests_opened_address[game_version]        +   32, 3, 0x01, 0}) --Traverse Town Secret Waterway White Trinity Chest
    table.insert(location_map, {2650334, chests_opened_address[game_version]        +   32, 4, 0x01, 0}) --Traverse Town Geppetto's House Chest
    table.insert(location_map, {2650371, chests_opened_address[game_version]        +   36, 1, 0x01, 0}) --Traverse Town Item Workshop Right Chest
    table.insert(location_map, {2650411, chests_opened_address[game_version]        +   40, 1, 0x01, 0}) --Traverse Town 1st District Blue Trinity Balcony Chest
    table.insert(location_map, {2650891, chests_opened_address[game_version]        +   88, 1, 0x01, 0}) --Traverse Town Mystical House Glide Chest
    table.insert(location_map, {2650892, chests_opened_address[game_version]        +   88, 2, 0x01, 0}) --Traverse Town Alleyway Behind Crates Chest
    table.insert(location_map, {2650893, chests_opened_address[game_version]        +   88, 3, 0x01, 0}) --Traverse Town Item Workshop Left Chest
    table.insert(location_map, {2650894, chests_opened_address[game_version]        +   88, 4, 0x01, 0}) --Traverse Town Secret Waterway Near Stairs Chest
    table.insert(location_map, {2650931, chests_opened_address[game_version]        +   92, 1, 0x01, 0}) --Wonderland Rabbit Hole Green Trinity Chest
    table.insert(location_map, {2650932, chests_opened_address[game_version]        +   92, 2, 0x01, 0}) --Wonderland Rabbit Hole Defeat Heartless 1 Chest
    table.insert(location_map, {2650933, chests_opened_address[game_version]        +   92, 3, 0x01, 0}) --Wonderland Rabbit Hole Defeat Heartless 2 Chest
    table.insert(location_map, {2650934, chests_opened_address[game_version]        +   92, 4, 0x01, 0}) --Wonderland Rabbit Hole Defeat Heartless 3 Chest
    table.insert(location_map, {2650971, chests_opened_address[game_version]        +   96, 1, 0x01, 0}) --Wonderland Bizarre Room Green Trinity Chest
    table.insert(location_map, {2651011, chests_opened_address[game_version]        +  100, 1, 0x01, 0}) --Wonderland Queen's Castle Hedge Left Red Chest
    table.insert(location_map, {2651012, chests_opened_address[game_version]        +  100, 2, 0x01, 0}) --Wonderland Queen's Castle Hedge Right Blue Chest
    table.insert(location_map, {2651013, chests_opened_address[game_version]        +  100, 3, 0x01, 0}) --Wonderland Queen's Castle Hedge Right Red Chest
    table.insert(location_map, {2651014, chests_opened_address[game_version]        +  100, 4, 0x01, 0}) --Wonderland Lotus Forest Thunder Plant Chest
    table.insert(location_map, {2651051, chests_opened_address[game_version]        +  104, 1, 0x01, 0}) --Wonderland Lotus Forest Through the Painting Thunder Plant Chest
    table.insert(location_map, {2651052, chests_opened_address[game_version]        +  104, 2, 0x01, 0}) --Wonderland Lotus Forest Glide Chest
    table.insert(location_map, {2651053, chests_opened_address[game_version]        +  104, 3, 0x01, 0}) --Wonderland Lotus Forest Nut Chest
    table.insert(location_map, {2651054, chests_opened_address[game_version]        +  104, 4, 0x01, 0}) --Wonderland Lotus Forest Corner Chest
    table.insert(location_map, {2651091, chests_opened_address[game_version]        +  108, 1, 0x01, 0}) --Wonderland Bizarre Room Lamp Chest
    table.insert(location_map, {2651093, chests_opened_address[game_version]        +  108, 3, 0x01, 0}) --Wonderland Tea Party Garden Above Lotus Forest Entrance 2nd Chest
    table.insert(location_map, {2651094, chests_opened_address[game_version]        +  108, 4, 0x01, 0}) --Wonderland Tea Party Garden Above Lotus Forest Entrance 1st Chest
    table.insert(location_map, {2651131, chests_opened_address[game_version]        +  112, 1, 0x01, 0}) --Wonderland Tea Party Garden Bear and Clock Puzzle Chest
    table.insert(location_map, {2651132, chests_opened_address[game_version]        +  112, 2, 0x01, 0}) --Wonderland Tea Party Garden Across From Bizarre Room Entrance Chest
    table.insert(location_map, {2651133, chests_opened_address[game_version]        +  112, 3, 0x01, 0}) --Wonderland Lotus Forest Through the Painting White Trinity Chest
    table.insert(location_map, {2651213, chests_opened_address[game_version]        +  120, 3, 0x01, 0}) --Deep Jungle Tree House Beneath Tree House Chest
    table.insert(location_map, {2651214, chests_opened_address[game_version]        +  120, 4, 0x01, 0}) --Deep Jungle Tree House Rooftop Chest
    table.insert(location_map, {2651251, chests_opened_address[game_version]        +  124, 1, 0x01, 0}) --Deep Jungle Hippo's Lagoon Center Chest
    table.insert(location_map, {2651252, chests_opened_address[game_version]        +  124, 2, 0x01, 0}) --Deep Jungle Hippo's Lagoon Left Chest
    table.insert(location_map, {2651253, chests_opened_address[game_version]        +  124, 3, 0x01, 0}) --Deep Jungle Hippo's Lagoon Right Chest
    table.insert(location_map, {2651291, chests_opened_address[game_version]        +  128, 1, 0x01, 0}) --Deep Jungle Vines Chest
    table.insert(location_map, {2651292, chests_opened_address[game_version]        +  128, 2, 0x01, 0}) --Deep Jungle Vines 2 Chest
    table.insert(location_map, {2651293, chests_opened_address[game_version]        +  128, 3, 0x01, 0}) --Deep Jungle Climbing Trees Blue Trinity Chest
    table.insert(location_map, {2651331, chests_opened_address[game_version]        +  132, 1, 0x01, 0}) --Deep Jungle Tunnel Chest
    table.insert(location_map, {2651332, chests_opened_address[game_version]        +  132, 2, 0x01, 0}) --Deep Jungle Cavern of Hearts White Trinity Chest
    table.insert(location_map, {2651333, chests_opened_address[game_version]        +  132, 3, 0x01, 0}) --Deep Jungle Camp Blue Trinity Chest
    table.insert(location_map, {2651334, chests_opened_address[game_version]        +  132, 4, 0x01, 0}) --Deep Jungle Tent Chest
    table.insert(location_map, {2651371, chests_opened_address[game_version]        +  136, 1, 0x01, 0}) --Deep Jungle Waterfall Cavern Low Chest
    table.insert(location_map, {2651372, chests_opened_address[game_version]        +  136, 2, 0x01, 0}) --Deep Jungle Waterfall Cavern Middle Chest
    table.insert(location_map, {2651373, chests_opened_address[game_version]        +  136, 3, 0x01, 0}) --Deep Jungle Waterfall Cavern High Wall Chest
    table.insert(location_map, {2651374, chests_opened_address[game_version]        +  136, 4, 0x01, 0}) --Deep Jungle Waterfall Cavern High Middle Chest
    table.insert(location_map, {2651411, chests_opened_address[game_version]        +  140, 1, 0x01, 0}) --Deep Jungle Cliff Right Cliff Left Chest
    table.insert(location_map, {2651412, chests_opened_address[game_version]        +  140, 2, 0x01, 0}) --Deep Jungle Cliff Right Cliff Right Chest
    table.insert(location_map, {2651413, chests_opened_address[game_version]        +  140, 3, 0x01, 0}) --Deep Jungle Tree House Suspended Boat Chest
    table.insert(location_map, {2651654, chests_opened_address[game_version]        +  164, 4, 0x01, 0}) --100 Acre Wood Meadow Inside Log Chest
    table.insert(location_map, {2651691, chests_opened_address[game_version]        +  168, 1, 0x01, 0}) --100 Acre Wood Bouncing Spot Left Cliff Chest
    table.insert(location_map, {2651692, chests_opened_address[game_version]        +  168, 2, 0x01, 0}) --100 Acre Wood Bouncing Spot Right Tree Alcove Chest
    table.insert(location_map, {2651693, chests_opened_address[game_version]        +  168, 3, 0x01, 0}) --100 Acre Wood Bouncing Spot Under Giant Pot Chest
    table.insert(location_map, {2651972, chests_opened_address[game_version]        +  196, 2, 0x01, 0}) --Agrabah Plaza By Storage Chest
    table.insert(location_map, {2651973, chests_opened_address[game_version]        +  196, 3, 0x01, 0}) --Agrabah Plaza Raised Terrace Chest
    table.insert(location_map, {2651974, chests_opened_address[game_version]        +  196, 4, 0x01, 0}) --Agrabah Plaza Top Corner Chest
    table.insert(location_map, {2652011, chests_opened_address[game_version]        +  200, 1, 0x01, 0}) --Agrabah Alley Chest
    table.insert(location_map, {2652012, chests_opened_address[game_version]        +  200, 2, 0x01, 0}) --Agrabah Bazaar Across Windows Chest
    table.insert(location_map, {2652013, chests_opened_address[game_version]        +  200, 3, 0x01, 0}) --Agrabah Bazaar High Corner Chest
    table.insert(location_map, {2652014, chests_opened_address[game_version]        +  200, 4, 0x01, 0}) --Agrabah Main Street Right Palace Entrance Chest
    table.insert(location_map, {2652051, chests_opened_address[game_version]        +  204, 1, 0x01, 0}) --Agrabah Main Street High Above Alley Entrance Chest
    table.insert(location_map, {2652052, chests_opened_address[game_version]        +  204, 2, 0x01, 0}) --Agrabah Main Street High Above Palace Gates Entrance Chest
    table.insert(location_map, {2652053, chests_opened_address[game_version]        +  204, 3, 0x01, 0}) --Agrabah Palace Gates Low Chest
    table.insert(location_map, {2652054, chests_opened_address[game_version]        +  204, 4, 0x01, 0}) --Agrabah Palace Gates High Opposite Palace Chest
    table.insert(location_map, {2652091, chests_opened_address[game_version]        +  208, 1, 0x01, 0}) --Agrabah Palace Gates High Close to Palace Chest
    table.insert(location_map, {2652092, chests_opened_address[game_version]        +  208, 2, 0x01, 0}) --Agrabah Storage Green Trinity Chest
    table.insert(location_map, {2652093, chests_opened_address[game_version]        +  208, 3, 0x01, 0}) --Agrabah Storage Behind Barrel Chest
    table.insert(location_map, {2652094, chests_opened_address[game_version]        +  208, 4, 0x01, 0}) --Agrabah Cave of Wonders Entrance Left Chest
    table.insert(location_map, {2652131, chests_opened_address[game_version]        +  212, 1, 0x01, 0}) --Agrabah Cave of Wonders Entrance Tall Tower Chest
    table.insert(location_map, {2652132, chests_opened_address[game_version]        +  212, 2, 0x01, 0}) --Agrabah Cave of Wonders Hall High Left Chest
    table.insert(location_map, {2652133, chests_opened_address[game_version]        +  212, 3, 0x01, 0}) --Agrabah Cave of Wonders Hall Near Bottomless Hall Chest
    table.insert(location_map, {2652134, chests_opened_address[game_version]        +  212, 4, 0x01, 0}) --Agrabah Cave of Wonders Bottomless Hall Raised Platform Chest
    table.insert(location_map, {2652171, chests_opened_address[game_version]        +  216, 1, 0x01, 0}) --Agrabah Cave of Wonders Bottomless Hall Pillar Chest
    table.insert(location_map, {2652172, chests_opened_address[game_version]        +  216, 2, 0x01, 0}) --Agrabah Cave of Wonders Bottomless Hall Across Chasm Chest
    table.insert(location_map, {2652173, chests_opened_address[game_version]        +  216, 3, 0x01, 0}) --Agrabah Cave of Wonders Treasure Room Across Platforms Chest
    table.insert(location_map, {2652174, chests_opened_address[game_version]        +  216, 4, 0x01, 0}) --Agrabah Cave of Wonders Treasure Room Small Treasure Pile Chest
    table.insert(location_map, {2652211, chests_opened_address[game_version]        +  220, 1, 0x01, 0}) --Agrabah Cave of Wonders Treasure Room Large Treasure Pile Chest
    table.insert(location_map, {2652212, chests_opened_address[game_version]        +  220, 2, 0x01, 0}) --Agrabah Cave of Wonders Treasure Room Above Fire Chest
    table.insert(location_map, {2652213, chests_opened_address[game_version]        +  220, 3, 0x01, 0}) --Agrabah Cave of Wonders Relic Chamber Jump from Stairs Chest
    table.insert(location_map, {2652214, chests_opened_address[game_version]        +  220, 4, 0x01, 0}) --Agrabah Cave of Wonders Relic Chamber Stairs Chest
    table.insert(location_map, {2652251, chests_opened_address[game_version]        +  224, 1, 0x01, 0}) --Agrabah Cave of Wonders Dark Chamber Abu Gem Chest
    table.insert(location_map, {2652252, chests_opened_address[game_version]        +  224, 2, 0x01, 0}) --Agrabah Cave of Wonders Dark Chamber Across from Relic Chamber Entrance Chest
    table.insert(location_map, {2652253, chests_opened_address[game_version]        +  224, 3, 0x01, 0}) --Agrabah Cave of Wonders Dark Chamber Bridge Chest
    table.insert(location_map, {2652254, chests_opened_address[game_version]        +  224, 4, 0x01, 0}) --Agrabah Cave of Wonders Dark Chamber Near Save Chest
    table.insert(location_map, {2652291, chests_opened_address[game_version]        +  228, 1, 0x01, 0}) --Agrabah Cave of Wonders Silent Chamber Blue Trinity Chest
    table.insert(location_map, {2652292, chests_opened_address[game_version]        +  228, 2, 0x01, 0}) --Agrabah Cave of Wonders Hidden Room Right Chest
    table.insert(location_map, {2652293, chests_opened_address[game_version]        +  228, 3, 0x01, 0}) --Agrabah Cave of Wonders Hidden Room Left Chest
    table.insert(location_map, {2652294, chests_opened_address[game_version]        +  228, 4, 0x01, 0}) --Agrabah Aladdin's House Main Street Entrance Chest
    table.insert(location_map, {2652331, chests_opened_address[game_version]        +  232, 1, 0x01, 0}) --Agrabah Aladdin's House Plaza Entrance Chest
    table.insert(location_map, {2652332, chests_opened_address[game_version]        +  232, 2, 0x01, 0}) --Agrabah Cave of Wonders Entrance White Trinity Chest
    table.insert(location_map, {2652413, chests_opened_address[game_version]        +  240, 3, 0x01, 0}) --Monstro Chamber 6 Other Platform Chest
    table.insert(location_map, {2652414, chests_opened_address[game_version]        +  240, 4, 0x01, 0}) --Monstro Chamber 6 Platform Near Chamber 5 Entrance Chest
    table.insert(location_map, {2652451, chests_opened_address[game_version]        +  244, 1, 0x01, 0}) --Monstro Chamber 6 Raised Area Near Chamber 1 Entrance Chest
    table.insert(location_map, {2652452, chests_opened_address[game_version]        +  244, 2, 0x01, 0}) --Monstro Chamber 6 Low Chest
    table.insert(location_map, {2652531, chests_opened_address[game_version]        +  252, 1, 0x01, 0}) --Atlantica Sunken Ship In Flipped Boat Chest
    table.insert(location_map, {2652532, chests_opened_address[game_version]        +  252, 2, 0x01, 0}) --Atlantica Sunken Ship Seabed Chest
    table.insert(location_map, {2652533, chests_opened_address[game_version]        +  252, 3, 0x01, 0}) --Atlantica Sunken Ship Inside Ship Chest
    table.insert(location_map, {2652534, chests_opened_address[game_version]        +  252, 4, 0x01, 0}) --Atlantica Ariel's Grotto High Chest
    table.insert(location_map, {2652571, chests_opened_address[game_version]        +  256, 1, 0x01, 0}) --Atlantica Ariel's Grotto Middle Chest
    table.insert(location_map, {2652572, chests_opened_address[game_version]        +  256, 2, 0x01, 0}) --Atlantica Ariel's Grotto Low Chest
    table.insert(location_map, {2652573, chests_opened_address[game_version]        +  256, 3, 0x01, 0}) --Atlantica Ursula's Lair Use Fire on Urchin Chest
    table.insert(location_map, {2652574, chests_opened_address[game_version]        +  256, 4, 0x01, 0}) --Atlantica Undersea Gorge Jammed by Ariel's Grotto Chest
    table.insert(location_map, {2652611, chests_opened_address[game_version]        +  260, 1, 0x01, 0}) --Atlantica Triton's Palace White Trinity Chest
    table.insert(location_map, {2653014, chests_opened_address[game_version]        +  300, 4, 0x01, 0}) --Halloween Town Moonlight Hill White Trinity Chest
    table.insert(location_map, {2653051, chests_opened_address[game_version]        +  304, 1, 0x01, 0}) --Halloween Town Bridge Under Bridge
    table.insert(location_map, {2653052, chests_opened_address[game_version]        +  304, 2, 0x01, 0}) --Halloween Town Boneyard Tombstone Puzzle Chest
    table.insert(location_map, {2653053, chests_opened_address[game_version]        +  304, 3, 0x01, 0}) --Halloween Town Bridge Right of Gate Chest
    table.insert(location_map, {2653054, chests_opened_address[game_version]        +  304, 4, 0x01, 0}) --Halloween Town Cemetery Behind Grave Chest
    table.insert(location_map, {2653091, chests_opened_address[game_version]        +  308, 1, 0x01, 0}) --Halloween Town Cemetery By Cat Shape Chest
    table.insert(location_map, {2653092, chests_opened_address[game_version]        +  308, 2, 0x01, 0}) --Halloween Town Cemetery Between Graves Chest
    table.insert(location_map, {2653093, chests_opened_address[game_version]        +  308, 3, 0x01, 0}) --Halloween Town Oogie's Manor Lower Iron Cage Chest
    table.insert(location_map, {2653094, chests_opened_address[game_version]        +  308, 4, 0x01, 0}) --Halloween Town Oogie's Manor Upper Iron Cage Chest
    table.insert(location_map, {2653131, chests_opened_address[game_version]        +  312, 1, 0x01, 0}) --Halloween Town Oogie's Manor Hollow Chest
    table.insert(location_map, {2653132, chests_opened_address[game_version]        +  312, 2, 0x01, 0}) --Halloween Town Oogie's Manor Grounds Red Trinity Chest
    table.insert(location_map, {2653133, chests_opened_address[game_version]        +  312, 3, 0x01, 0}) --Halloween Town Guillotine Square High Tower Chest
    table.insert(location_map, {2653134, chests_opened_address[game_version]        +  312, 4, 0x01, 0}) --Halloween Town Guillotine Square Pumpkin Structure Left Chest
    table.insert(location_map, {2653171, chests_opened_address[game_version]        +  316, 1, 0x01, 0}) --Halloween Town Oogie's Manor Entrance Steps Chest
    table.insert(location_map, {2653172, chests_opened_address[game_version]        +  316, 2, 0x01, 0}) --Halloween Town Oogie's Manor Inside Entrance Chest
    table.insert(location_map, {2653291, chests_opened_address[game_version]        +  328, 1, 0x01, 0}) --Halloween Town Bridge Left of Gate Chest
    table.insert(location_map, {2653292, chests_opened_address[game_version]        +  328, 2, 0x01, 0}) --Halloween Town Cemetery By Striped Grave Chest
    table.insert(location_map, {2653293, chests_opened_address[game_version]        +  328, 3, 0x01, 0}) --Halloween Town Guillotine Square Under Jack's House Stairs Chest
    table.insert(location_map, {2653294, chests_opened_address[game_version]        +  328, 4, 0x01, 0}) --Halloween Town Guillotine Square Pumpkin Structure Right Chest
    table.insert(location_map, {2653332, chests_opened_address[game_version]        +  332, 2, 0x01, 0}) --Olympus Coliseum Coliseum Gates Left Behind Columns Chest
    table.insert(location_map, {2653333, chests_opened_address[game_version]        +  332, 3, 0x01, 0}) --Olympus Coliseum Coliseum Gates Right Blue Trinity Chest
    table.insert(location_map, {2653334, chests_opened_address[game_version]        +  332, 4, 0x01, 0}) --Olympus Coliseum Coliseum Gates Left Blue Trinity Chest
    table.insert(location_map, {2653371, chests_opened_address[game_version]        +  336, 1, 0x01, 0}) --Olympus Coliseum Coliseum Gates White Trinity Chest
    table.insert(location_map, {2653372, chests_opened_address[game_version]        +  336, 2, 0x01, 0}) --Olympus Coliseum Coliseum Gates Blizzara Chest
    table.insert(location_map, {2653373, chests_opened_address[game_version]        +  336, 3, 0x01, 0}) --Olympus Coliseum Coliseum Gates Blizzaga Chest
    table.insert(location_map, {2653454, chests_opened_address[game_version]        +  344, 4, 0x01, 0}) --Monstro Mouth Boat Deck Chest
    table.insert(location_map, {2653491, chests_opened_address[game_version]        +  348, 1, 0x01, 0}) --Monstro Mouth High Platform Boat Side Chest
    table.insert(location_map, {2653492, chests_opened_address[game_version]        +  348, 2, 0x01, 0}) --Monstro Mouth High Platform Across from Boat Chest
    table.insert(location_map, {2653493, chests_opened_address[game_version]        +  348, 3, 0x01, 0}) --Monstro Mouth Near Ship Chest
    table.insert(location_map, {2653494, chests_opened_address[game_version]        +  348, 4, 0x01, 0}) --Monstro Mouth Green Trinity Top of Boat Chest
    table.insert(location_map, {2653534, chests_opened_address[game_version]        +  352, 4, 0x01, 0}) --Monstro Chamber 2 Ground Chest
    table.insert(location_map, {2653571, chests_opened_address[game_version]        +  356, 1, 0x01, 0}) --Monstro Chamber 2 Platform Chest
    table.insert(location_map, {2653613, chests_opened_address[game_version]        +  360, 3, 0x01, 0}) --Monstro Chamber 5 Platform Chest
    table.insert(location_map, {2653614, chests_opened_address[game_version]        +  360, 4, 0x01, 0}) --Monstro Chamber 3 Ground Chest
    table.insert(location_map, {2653651, chests_opened_address[game_version]        +  364, 1, 0x01, 0}) --Monstro Chamber 3 Platform Above Chamber 2 Entrance Chest
    table.insert(location_map, {2653652, chests_opened_address[game_version]        +  364, 2, 0x01, 0}) --Monstro Chamber 3 Near Chamber 6 Entrance Chest
    table.insert(location_map, {2653653, chests_opened_address[game_version]        +  364, 3, 0x01, 0}) --Monstro Chamber 3 Platform Near Chamber 6 Entrance Chest
    table.insert(location_map, {2653732, chests_opened_address[game_version]        +  372, 2, 0x01, 0}) --Monstro Mouth High Platform Near Teeth Chest
    table.insert(location_map, {2653733, chests_opened_address[game_version]        +  372, 3, 0x01, 0}) --Monstro Chamber 5 Atop Barrel Chest
    table.insert(location_map, {2653734, chests_opened_address[game_version]        +  372, 4, 0x01, 0}) --Monstro Chamber 5 Low 2nd Chest
    table.insert(location_map, {2653771, chests_opened_address[game_version]        +  376, 1, 0x01, 0}) --Monstro Chamber 5 Low 1st Chest
    table.insert(location_map, {2653772, chests_opened_address[game_version]        +  376, 2, 0x01, 0}) --Neverland Pirate Ship Deck White Trinity Chest
    table.insert(location_map, {2653773, chests_opened_address[game_version]        +  376, 3, 0x01, 0}) --Neverland Pirate Ship Crows Nest Chest
    table.insert(location_map, {2653774, chests_opened_address[game_version]        +  376, 4, 0x01, 0}) --Neverland Hold Yellow Trinity Right Blue Chest
    table.insert(location_map, {2653811, chests_opened_address[game_version]        +  380, 1, 0x01, 0}) --Neverland Hold Yellow Trinity Left Blue Chest
    table.insert(location_map, {2653812, chests_opened_address[game_version]        +  380, 2, 0x01, 0}) --Neverland Galley Chest
    table.insert(location_map, {2653813, chests_opened_address[game_version]        +  380, 3, 0x01, 0}) --Neverland Cabin Chest
    table.insert(location_map, {2653814, chests_opened_address[game_version]        +  380, 4, 0x01, 0}) --Neverland Hold Flight 1st Chest
    table.insert(location_map, {2654014, chests_opened_address[game_version]        +  400, 4, 0x01, 0}) --Neverland Clock Tower Chest
    table.insert(location_map, {2654051, chests_opened_address[game_version]        +  404, 1, 0x01, 0}) --Neverland Hold Flight 2nd Chest
    table.insert(location_map, {2654052, chests_opened_address[game_version]        +  404, 2, 0x01, 0}) --Neverland Hold Yellow Trinity Green Chest
    table.insert(location_map, {2654053, chests_opened_address[game_version]        +  404, 3, 0x01, 0}) --Neverland Captain's Cabin Chest
    table.insert(location_map, {2654054, chests_opened_address[game_version]        +  404, 4, 0x01, 0}) --Hollow Bastion Rising Falls Water's Surface Chest
    table.insert(location_map, {2654091, chests_opened_address[game_version]        +  408, 1, 0x01, 0}) --Hollow Bastion Rising Falls Under Water 1st Chest
    table.insert(location_map, {2654092, chests_opened_address[game_version]        +  408, 2, 0x01, 0}) --Hollow Bastion Rising Falls Under Water 2nd Chest
    table.insert(location_map, {2654093, chests_opened_address[game_version]        +  408, 3, 0x01, 0}) --Hollow Bastion Rising Falls Floating Platform Near Save Chest
    table.insert(location_map, {2654094, chests_opened_address[game_version]        +  408, 4, 0x01, 0}) --Hollow Bastion Rising Falls Floating Platform Near Bubble Chest
    table.insert(location_map, {2654131, chests_opened_address[game_version]        +  412, 1, 0x01, 0}) --Hollow Bastion Rising Falls High Platform Chest
    table.insert(location_map, {2654132, chests_opened_address[game_version]        +  412, 2, 0x01, 0}) --Hollow Bastion Castle Gates Gravity Chest
    table.insert(location_map, {2654133, chests_opened_address[game_version]        +  412, 3, 0x01, 0}) --Hollow Bastion Castle Gates Freestanding Pillar Chest
    table.insert(location_map, {2654134, chests_opened_address[game_version]        +  412, 4, 0x01, 0}) --Hollow Bastion Castle Gates High Pillar Chest
    table.insert(location_map, {2654171, chests_opened_address[game_version]        +  416, 1, 0x01, 0}) --Hollow Bastion Great Crest Lower Chest
    table.insert(location_map, {2654172, chests_opened_address[game_version]        +  416, 2, 0x01, 0}) --Hollow Bastion Great Crest After Battle Platform Chest
    table.insert(location_map, {2654173, chests_opened_address[game_version]        +  416, 3, 0x01, 0}) --Hollow Bastion High Tower 2nd Gravity Chest
    table.insert(location_map, {2654174, chests_opened_address[game_version]        +  416, 4, 0x01, 0}) --Hollow Bastion High Tower 1st Gravity Chest
    table.insert(location_map, {2654211, chests_opened_address[game_version]        +  420, 1, 0x01, 0}) --Hollow Bastion High Tower Above Sliding Blocks Chest
    table.insert(location_map, {2654213, chests_opened_address[game_version]        +  420, 3, 0x01, 0}) --Hollow Bastion Library Top of Bookshelf Chest
    table.insert(location_map, {2654214, chests_opened_address[game_version]        +  420, 4, 0x01, 0}) --Hollow Bastion Library 1st Floor Turn the Carousel Chest
    table.insert(location_map, {2654251, chests_opened_address[game_version]        +  424, 1, 0x01, 0}) --Hollow Bastion Library Top of Bookshelf Turn the Carousel Chest
    table.insert(location_map, {2654252, chests_opened_address[game_version]        +  424, 2, 0x01, 0}) --Hollow Bastion Library 2nd Floor Turn the Carousel 1st Chest
    table.insert(location_map, {2654253, chests_opened_address[game_version]        +  424, 3, 0x01, 0}) --Hollow Bastion Library 2nd Floor Turn the Carousel 2nd Chest
    table.insert(location_map, {2654254, chests_opened_address[game_version]        +  424, 4, 0x01, 0}) --Hollow Bastion Lift Stop Library Node After High Tower Switch Gravity Chest
    table.insert(location_map, {2654291, chests_opened_address[game_version]        +  428, 1, 0x01, 0}) --Hollow Bastion Lift Stop Library Node Gravity Chest
    table.insert(location_map, {2654292, chests_opened_address[game_version]        +  428, 2, 0x01, 0}) --Hollow Bastion Lift Stop Under High Tower Sliding Blocks Chest
    table.insert(location_map, {2654293, chests_opened_address[game_version]        +  428, 3, 0x01, 0}) --Hollow Bastion Lift Stop Outside Library Gravity Chest
    table.insert(location_map, {2654294, chests_opened_address[game_version]        +  428, 4, 0x01, 0}) --Hollow Bastion Lift Stop Heartless Sigil Door Gravity Chest
    table.insert(location_map, {2654331, chests_opened_address[game_version]        +  432, 1, 0x01, 0}) --Hollow Bastion Base Level Bubble Under the Wall Platform Chest
    table.insert(location_map, {2654332, chests_opened_address[game_version]        +  432, 2, 0x01, 0}) --Hollow Bastion Base Level Platform Near Entrance Chest
    table.insert(location_map, {2654333, chests_opened_address[game_version]        +  432, 3, 0x01, 0}) --Hollow Bastion Base Level Near Crystal Switch Chest
    table.insert(location_map, {2654334, chests_opened_address[game_version]        +  432, 4, 0x01, 0}) --Hollow Bastion Waterway Near Save Chest
    table.insert(location_map, {2654371, chests_opened_address[game_version]        +  436, 1, 0x01, 0}) --Hollow Bastion Waterway Blizzard on Bubble Chest
    table.insert(location_map, {2654372, chests_opened_address[game_version]        +  436, 2, 0x01, 0}) --Hollow Bastion Waterway Unlock Passage from Base Level Chest
    table.insert(location_map, {2654373, chests_opened_address[game_version]        +  436, 3, 0x01, 0}) --Hollow Bastion Dungeon By Candles Chest
    table.insert(location_map, {2654374, chests_opened_address[game_version]        +  436, 4, 0x01, 0}) --Hollow Bastion Dungeon Corner Chest
    table.insert(location_map, {2654454, chests_opened_address[game_version]        +  444, 4, 0x01, 0}) --Hollow Bastion Grand Hall Steps Right Side Chest
    table.insert(location_map, {2654491, chests_opened_address[game_version]        +  448, 1, 0x01, 0}) --Hollow Bastion Grand Hall Oblivion Chest
    table.insert(location_map, {2654492, chests_opened_address[game_version]        +  448, 2, 0x01, 0}) --Hollow Bastion Grand Hall Left of Gate Chest
    table.insert(location_map, {2654493, chests_opened_address[game_version]        +  448, 3, 0x01, 0}) --Hollow Bastion Entrance Hall Push the Statue Chest
    table.insert(location_map, {2654212, chests_opened_address[game_version]        +  420, 2, 0x01, 0}) --Hollow Bastion Entrance Hall Left of Emblem Door Chest
    table.insert(location_map, {2654494, chests_opened_address[game_version]        +  448, 4, 0x01, 0}) --Hollow Bastion Rising Falls White Trinity Chest
    table.insert(location_map, {2654531, chests_opened_address[game_version]        +  452, 1, 0x01, 0}) --End of the World Final Dimension 1st Chest
    table.insert(location_map, {2654532, chests_opened_address[game_version]        +  452, 2, 0x01, 0}) --End of the World Final Dimension 2nd Chest
    table.insert(location_map, {2654533, chests_opened_address[game_version]        +  452, 3, 0x01, 0}) --End of the World Final Dimension 3rd Chest
    table.insert(location_map, {2654534, chests_opened_address[game_version]        +  452, 4, 0x01, 0}) --End of the World Final Dimension 4th Chest
    table.insert(location_map, {2654571, chests_opened_address[game_version]        +  456, 1, 0x01, 0}) --End of the World Final Dimension 5th Chest
    table.insert(location_map, {2654572, chests_opened_address[game_version]        +  456, 2, 0x01, 0}) --End of the World Final Dimension 6th Chest
    table.insert(location_map, {2654573, chests_opened_address[game_version]        +  456, 3, 0x01, 0}) --End of the World Final Dimension 10th Chest
    table.insert(location_map, {2654574, chests_opened_address[game_version]        +  456, 4, 0x01, 0}) --End of the World Final Dimension 9th Chest
    table.insert(location_map, {2654611, chests_opened_address[game_version]        +  460, 1, 0x01, 0}) --End of the World Final Dimension 8th Chest
    table.insert(location_map, {2654612, chests_opened_address[game_version]        +  460, 2, 0x01, 0}) --End of the World Final Dimension 7th Chest
    table.insert(location_map, {2654613, chests_opened_address[game_version]        +  460, 3, 0x01, 0}) --End of the World Giant Crevasse 3rd Chest
    table.insert(location_map, {2654614, chests_opened_address[game_version]        +  460, 4, 0x01, 0}) --End of the World Giant Crevasse 5th Chest
    table.insert(location_map, {2654651, chests_opened_address[game_version]        +  464, 1, 0x01, 0}) --End of the World Giant Crevasse 1st Chest
    table.insert(location_map, {2654652, chests_opened_address[game_version]        +  464, 2, 0x01, 0}) --End of the World Giant Crevasse 4th Chest
    table.insert(location_map, {2654653, chests_opened_address[game_version]        +  464, 3, 0x01, 0}) --End of the World Giant Crevasse 2nd Chest
    table.insert(location_map, {2654654, chests_opened_address[game_version]        +  464, 4, 0x01, 0}) --End of the World World Terminus Traverse Town Chest
    table.insert(location_map, {2654691, chests_opened_address[game_version]        +  468, 1, 0x01, 0}) --End of the World World Terminus Wonderland Chest
    table.insert(location_map, {2654692, chests_opened_address[game_version]        +  468, 2, 0x01, 0}) --End of the World World Terminus Olympus Coliseum Chest
    table.insert(location_map, {2654693, chests_opened_address[game_version]        +  468, 3, 0x01, 0}) --End of the World World Terminus Deep Jungle Chest
    table.insert(location_map, {2654694, chests_opened_address[game_version]        +  468, 4, 0x01, 0}) --End of the World World Terminus Agrabah Chest
    table.insert(location_map, {2654731, chests_opened_address[game_version]        +  472, 1, 0x01, 0}) --End of the World World Terminus Atlantica Chest
    table.insert(location_map, {2654732, chests_opened_address[game_version]        +  472, 2, 0x01, 0}) --End of the World World Terminus Halloween Town Chest
    table.insert(location_map, {2654733, chests_opened_address[game_version]        +  472, 3, 0x01, 0}) --End of the World World Terminus Neverland Chest
    table.insert(location_map, {2654734, chests_opened_address[game_version]        +  472, 4, 0x01, 0}) --End of the World World Terminus 100 Acre Wood Chest
    table.insert(location_map, {2654771, chests_opened_address[game_version]        +  476, 1, 0x01, 0}) --End of the World World Terminus Hollow Bastion Chest
    table.insert(location_map, {2654772, chests_opened_address[game_version]        +  476, 2, 0x01, 0}) --End of the World Final Rest Chest
    table.insert(location_map, {2655092, chests_opened_address[game_version]        +  508, 2, 0x01, 0}) --Monstro Chamber 6 White Trinity Chest
    table.insert(location_map, {2655093, chests_opened_address[game_version]        +  508, 3, 0x01, 0}) --Awakening Chest
    table.insert(location_map, {2656011, world_progress_array_address[game_version] +    0, 0, 0x31, 0}) --Traverse Town Defeat Guard Armor Dodge Roll Event
    table.insert(location_map, {2656012, world_progress_array_address[game_version] +    0, 0, 0x31, 0}) --Traverse Town Defeat Guard Armor Fire Event
    table.insert(location_map, {2656013, world_progress_array_address[game_version] +    0, 0, 0x31, 0}) --Traverse Town Defeat Guard Armor Blue Trinity Event
    table.insert(location_map, {2656014, world_progress_array_address[game_version] +    0, 0, 0x3E, 0}) --Traverse Town Leon Secret Waterway Earthshine Event
    table.insert(location_map, {2656015, world_progress_array_address[game_version] +    0, 0, 0x8C, 0}) --Traverse Town Kairi Secret Waterway Oathkeeper Event
    table.insert(location_map, {2656016, world_progress_array_address[game_version] +    0, 0, 0x2B, 0}) --Traverse Town Defeat Guard Armor Brave Warrior Event
    table.insert(location_map, {2656021, world_progress_array_address[game_version] +    1, 0, 0x42, 0}) --Deep Jungle Defeat Sabor White Fang Event
    table.insert(location_map, {2656022, world_progress_array_address[game_version] +    1, 0, 0x56, 0}) --Deep Jungle Defeat Clayton Cure Event
    table.insert(location_map, {2656023, world_progress_array_address[game_version] +    1, 0, 0x6E, 0}) --Deep Jungle Seal Keyhole Jungle King Event
    table.insert(location_map, {2656024, world_progress_array_address[game_version] +    1, 0, 0x6E, 0}) --Deep Jungle Seal Keyhole Red Trinity Event
    table.insert(location_map, {2656031, world_progress_array_address[game_version] +    2, 0, 0x0D, 0}) --Olympus Coliseum Clear Phil's Training Thunder Event
    table.insert(location_map, {2656033, world_progress_array_address[game_version] +    2, 0, 0x25, 0}) --Olympus Coliseum Defeat Cerberus Inferno Band Event
    table.insert(location_map, {2656041, world_progress_array_address[game_version] +    3, 0, 0x2E, 0}) --Wonderland Defeat Trickmaster Blizzard Event
    table.insert(location_map, {2656042, world_progress_array_address[game_version] +    3, 0, 0x2E, 0}) --Wonderland Defeat Trickmaster Ifrit's Horn Event
    table.insert(location_map, {2656051, world_progress_array_address[game_version] +    4, 0, 0x35, 0}) --Agrabah Defeat Pot Centipede Ray of Light Event
    table.insert(location_map, {2656052, world_progress_array_address[game_version] +    4, 0, 0x49, 0}) --Agrabah Defeat Jafar Blizzard Event
    table.insert(location_map, {2656053, world_progress_array_address[game_version] +    4, 0, 0x5A, 0}) --Agrabah Defeat Jafar Genie Fire Event
    table.insert(location_map, {2656054, world_progress_array_address[game_version] +    4, 0, 0x78, 0}) --Agrabah Seal Keyhole Genie Event
    table.insert(location_map, {2656055, world_progress_array_address[game_version] +    4, 0, 0x78, 0}) --Agrabah Seal Keyhole Three Wishes Event
    table.insert(location_map, {2656056, world_progress_array_address[game_version] +    4, 0, 0x78, 0}) --Agrabah Seal Keyhole Green Trinity Event
    table.insert(location_map, {2656061, world_progress_array_address[game_version] +    5, 0, 0x2E, 0}) --Monstro Defeat Parasite Cage I Goofy Cheer Event
    table.insert(location_map, {2656062, world_progress_array_address[game_version] +    5, 0, 0x46, 0}) --Monstro Defeat Parasite Cage II Stop Event
    table.insert(location_map, {2656071, world_progress_array_address[game_version] +    6, 0, 0x53, 0}) --Atlantica Defeat Ursula I Mermaid Kick Event
    table.insert(location_map, {2656072, world_progress_array_address[game_version] +    6, 0, 0x5D, 0}) --Atlantica Defeat Ursula II Thunder Event
    table.insert(location_map, {2656073, world_progress_array_address[game_version] +    6, 0, 0x64, 0}) --Atlantica Seal Keyhole Crabclaw Event
    table.insert(location_map, {2656081, world_progress_array_address[game_version] +    8, 0, 0x62, 0}) --Halloween Town Defeat Oogie Boogie Holy Circlet Event
    table.insert(location_map, {2656082, world_progress_array_address[game_version] +    8, 0, 0x6A, 0}) --Halloween Town Defeat Oogie's Manor Gravity Event
    table.insert(location_map, {2656083, world_progress_array_address[game_version] +    8, 0, 0x6E, 0}) --Halloween Town Seal Keyhole Pumpkinhead Event
    table.insert(location_map, {2656091, world_progress_array_address[game_version] +    9, 0, 0x35, 0}) --Neverland Defeat Anti Sora Raven's Claw Event
    table.insert(location_map, {2656092, world_progress_array_address[game_version] +    9, 0, 0x3F, 0}) --Neverland Encounter Hook Cure Event
    table.insert(location_map, {2656093, world_progress_array_address[game_version] +    9, 0, 0x6E, 0}) --Neverland Seal Keyhole Fairy Harp Event
    table.insert(location_map, {2656094, world_progress_array_address[game_version] +    9, 0, 0x6E, 0}) --Neverland Seal Keyhole Tinker Bell Event
    table.insert(location_map, {2656095, world_progress_array_address[game_version] +    9, 0, 0x6E, 0}) --Neverland Seal Keyhole Glide Event
    table.insert(location_map, {2656096, world_progress_array_address[game_version] +    9, 0, 0x96, 0}) --Neverland Defeat Phantom Stop Event
    table.insert(location_map, {2656097, world_progress_array_address[game_version] +    9, 0, 0x56, 0}) --Neverland Defeat Captain Hook Ars Arcanum Event
    table.insert(location_map, {2656101, world_progress_array_address[game_version] +   10, 0, 0x32, 0}) --Hollow Bastion Defeat Riku I White Trinity Event
    table.insert(location_map, {2656102, world_progress_array_address[game_version] +   10, 0, 0x5A, 0}) --Hollow Bastion Defeat Maleficent Donald Cheer Event
    table.insert(location_map, {2656103, world_progress_array_address[game_version] +   10, 0, 0x6E, 0}) --Hollow Bastion Defeat Dragon Maleficent Fireglow Event
    table.insert(location_map, {2656104, world_progress_array_address[game_version] +   10, 0, 0x82, 0}) --Hollow Bastion Defeat Riku II Ragnarok Event
    table.insert(location_map, {2656105, world_progress_array_address[game_version] +   10, 0, 0xB9, 0}) --Hollow Bastion Defeat Behemoth Omega Arts Event
    table.insert(location_map, {2656106, world_progress_array_address[game_version] +   10, 0, 0xC3, 0}) --Hollow Bastion Speak to Princesses Fire Event
    table.insert(location_map, {2656111, world_progress_array_address[game_version] +   11, 0, 0x33, 0}) --End of the World Defeat Chernabog Superglide Event
    table.insert(location_map, {2656120, world_flags_address[game_version]          + 4018, 0, 0x01, 0}) --Traverse Town Mail Postcard 01 Event
    table.insert(location_map, {2656121, world_flags_address[game_version]          + 4018, 0, 0x02, 0}) --Traverse Town Mail Postcard 02 Event
    table.insert(location_map, {2656122, world_flags_address[game_version]          + 4018, 0, 0x03, 0}) --Traverse Town Mail Postcard 03 Event
    table.insert(location_map, {2656123, world_flags_address[game_version]          + 4018, 0, 0x04, 0}) --Traverse Town Mail Postcard 04 Event
    table.insert(location_map, {2656124, world_flags_address[game_version]          + 4018, 0, 0x05, 0}) --Traverse Town Mail Postcard 05 Event
    table.insert(location_map, {2656125, world_flags_address[game_version]          + 4018, 0, 0x06, 0}) --Traverse Town Mail Postcard 06 Event
    table.insert(location_map, {2656126, world_flags_address[game_version]          + 4018, 0, 0x07, 0}) --Traverse Town Mail Postcard 07 Event
    table.insert(location_map, {2656127, world_flags_address[game_version]          + 4018, 0, 0x08, 0}) --Traverse Town Mail Postcard 08 Event
    table.insert(location_map, {2656128, world_flags_address[game_version]          + 4018, 0, 0x09, 0}) --Traverse Town Mail Postcard 09 Event
    table.insert(location_map, {2656129, world_flags_address[game_version]          + 4018, 0, 0x0A, 0}) --Traverse Town Mail Postcard 10 Event
    table.insert(location_map, {2656131, world_progress_array_address[game_version] +   14, 0, 0x14, 0}) --Traverse Town Defeat Opposite Armor Aero Event
    table.insert(location_map, {2656201, atlantica_clams_address[game_version]      +    0, 1, 0x01, 0}) --Atlantica Undersea Gorge Blizzard Clam
    table.insert(location_map, {2656202, atlantica_clams_address[game_version]      +    0, 2, 0x01, 0}) --Atlantica Undersea Gorge Ocean Floor Clam
    table.insert(location_map, {2656203, atlantica_clams_address[game_version]      +    0, 3, 0x01, 0}) --Atlantica Undersea Valley Higher Cave Clam
    table.insert(location_map, {2656204, atlantica_clams_address[game_version]      +    0, 4, 0x01, 0}) --Atlantica Undersea Valley Lower Cave Clam
    table.insert(location_map, {2656205, atlantica_clams_address[game_version]      +    0, 5, 0x01, 0}) --Atlantica Undersea Valley Fire Clam
    table.insert(location_map, {2656206, atlantica_clams_address[game_version]      +    0, 6, 0x01, 0}) --Atlantica Undersea Valley Wall Clam
    table.insert(location_map, {2656207, atlantica_clams_address[game_version]      +    0, 7, 0x01, 0}) --Atlantica Undersea Valley Pillar Clam
    table.insert(location_map, {2656208, atlantica_clams_address[game_version]      +    0, 8, 0x01, 0}) --Atlantica Undersea Valley Ocean Floor Clam
    table.insert(location_map, {2656209, atlantica_clams_address[game_version]      +    1, 1, 0x01, 0}) --Atlantica Triton's Palace Thunder Clam
    table.insert(location_map, {2656210, atlantica_clams_address[game_version]      +    1, 2, 0x01, 0}) --Atlantica Triton's Palace Wall Right Clam
    table.insert(location_map, {2656211, atlantica_clams_address[game_version]      +    1, 3, 0x01, 0}) --Atlantica Triton's Palace Near Path Clam
    table.insert(location_map, {2656212, atlantica_clams_address[game_version]      +    1, 4, 0x01, 0}) --Atlantica Triton's Palace Wall Left Clam
    table.insert(location_map, {2656213, atlantica_clams_address[game_version]      +    1, 5, 0x01, 0}) --Atlantica Cavern Nook Clam
    table.insert(location_map, {2656214, atlantica_clams_address[game_version]      +    1, 6, 0x01, 0}) --Atlantica Below Deck Clam
    table.insert(location_map, {2656215, atlantica_clams_address[game_version]      +    1, 7, 0x01, 0}) --Atlantica Undersea Garden Clam
    table.insert(location_map, {2656216, atlantica_clams_address[game_version]      +    1, 8, 0x01, 0}) --Atlantica Undersea Cave Clam
    table.insert(location_map, {2656300, world_flags_address[game_version]          +   27, 0, 0x01, 0}) --Traverse Town Magician's Study Turn in Naturespark
    table.insert(location_map, {2656301, world_flags_address[game_version]          +   28, 0, 0x01, 0}) --Traverse Town Magician's Study Turn in Watergleam
    table.insert(location_map, {2656302, world_flags_address[game_version]          +   29, 0, 0x01, 0}) --Traverse Town Magician's Study Turn in Fireglow
    table.insert(location_map, {2656303, world_flags_address[game_version]          +   34, 0, 0x01, 0}) --Traverse Town Magician's Study Turn in all Summon Gems
    table.insert(location_map, {2656304, world_flags_address[game_version]          +   35, 0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto Reward 1
    table.insert(location_map, {2656305, world_flags_address[game_version]          +   36, 0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto Reward 2
    table.insert(location_map, {2656306, world_flags_address[game_version]          +   37, 0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto Reward 3
    table.insert(location_map, {2656307, world_flags_address[game_version]          +   38, 0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto Reward 4
    table.insert(location_map, {2656308, world_flags_address[game_version]          +   39, 0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto Reward 5
    table.insert(location_map, {2656309, world_flags_address[game_version]          +   41, 0, 0x01, 0}) --Traverse Town Geppetto's House Geppetto All Summons Reward
    table.insert(location_map, {2656310, world_flags_address[game_version]          +   40, 0, 0x01, 0}) --Traverse Town Geppetto's House Talk to Pinocchio
    table.insert(location_map, {2656311, world_flags_address[game_version]          +   43, 0, 0x01, 0}) --Traverse Town Magician's Study Obtained All Arts Items
    table.insert(location_map, {2656312, world_flags_address[game_version]          +   44, 0, 0x01, 0}) --Traverse Town Magician's Study Obtained All LV1 Magic
    table.insert(location_map, {2656313, world_flags_address[game_version]          +   45, 0, 0x01, 0}) --Traverse Town Magician's Study Obtained All LV3 Magic
    table.insert(location_map, {2656314, world_flags_address[game_version]          +  303, 0, 0x01, 0}) --Traverse Town Piano Room Return 10 Puppies
    table.insert(location_map, {2656315, world_flags_address[game_version]          +  304, 0, 0x01, 0}) --Traverse Town Piano Room Return 20 Puppies
    table.insert(location_map, {2656316, world_flags_address[game_version]          +  305, 0, 0x01, 0}) --Traverse Town Piano Room Return 30 Puppies
    table.insert(location_map, {2656317, world_flags_address[game_version]          +  306, 0, 0x01, 0}) --Traverse Town Piano Room Return 40 Puppies
    table.insert(location_map, {2656318, world_flags_address[game_version]          +  307, 0, 0x01, 0}) --Traverse Town Piano Room Return 50 Puppies Reward 1
    table.insert(location_map, {2656319, world_flags_address[game_version]          +  307, 0, 0x01, 0}) --Traverse Town Piano Room Return 50 Puppies Reward 2
    table.insert(location_map, {2656320, world_flags_address[game_version]          +  308, 0, 0x01, 0}) --Traverse Town Piano Room Return 60 Puppies
    table.insert(location_map, {2656321, world_flags_address[game_version]          +  309, 0, 0x01, 0}) --Traverse Town Piano Room Return 70 Puppies
    table.insert(location_map, {2656322, world_flags_address[game_version]          +  310, 0, 0x01, 0}) --Traverse Town Piano Room Return 80 Puppies
    table.insert(location_map, {2656324, world_flags_address[game_version]          +  311, 0, 0x01, 0}) --Traverse Town Piano Room Return 90 Puppies
    table.insert(location_map, {2656326, world_flags_address[game_version]          +  312, 0, 0x01, 0}) --Traverse Town Piano Room Return 99 Puppies Reward 1
    table.insert(location_map, {2656327, world_flags_address[game_version]          +  312, 0, 0x01, 0}) --Traverse Town Piano Room Return 99 Puppies Reward 2
    table.insert(location_map, {2656032, world_flags_address[game_version]          +  501, 0, 0x0A, 0}) --Olympus Coliseum Cloud Sonic Blade Event
    table.insert(location_map, {2656328, world_flags_address[game_version]          +  605, 0, 0x01, 0}) --Olympus Coliseum Defeat Sephiroth One-Winged Angel Event
    table.insert(location_map, {2656329, world_flags_address[game_version]          +  604, 0, 0x01, 0}) --Olympus Coliseum Defeat Ice Titan Diamond Dust Event
    table.insert(location_map, {2656330, world_flags_address[game_version]          + 4358, 0, 0x01, 0}) --Olympus Coliseum Gates Purple Jar After Defeating Hades
    table.insert(location_map, {2656331, world_flags_address[game_version]          + 4291, 2, 0x01, 0}) --Halloween Town Guillotine Square Ring Jack's Doorbell 3 Times
    table.insert(location_map, {2656332, world_flags_address[game_version]          + 4436, 8, 0x01, 0}) --Neverland Clock Tower 01:00 Door
    table.insert(location_map, {2656333, world_flags_address[game_version]          + 4436, 7, 0x01, 0}) --Neverland Clock Tower 02:00 Door
    table.insert(location_map, {2656334, world_flags_address[game_version]          + 4436, 6, 0x01, 0}) --Neverland Clock Tower 03:00 Door
    table.insert(location_map, {2656335, world_flags_address[game_version]          + 4436, 5, 0x01, 0}) --Neverland Clock Tower 04:00 Door
    table.insert(location_map, {2656336, world_flags_address[game_version]          + 4436, 4, 0x01, 0}) --Neverland Clock Tower 05:00 Door
    table.insert(location_map, {2656337, world_flags_address[game_version]          + 4436, 3, 0x01, 0}) --Neverland Clock Tower 06:00 Door
    table.insert(location_map, {2656338, world_flags_address[game_version]          + 4436, 2, 0x01, 0}) --Neverland Clock Tower 07:00 Door
    table.insert(location_map, {2656339, world_flags_address[game_version]          + 4436, 1, 0x01, 0}) --Neverland Clock Tower 08:00 Door
    table.insert(location_map, {2656340, world_flags_address[game_version]          + 4437, 8, 0x01, 0}) --Neverland Clock Tower 09:00 Door
    table.insert(location_map, {2656341, world_flags_address[game_version]          + 4437, 7, 0x01, 0}) --Neverland Clock Tower 10:00 Door
    table.insert(location_map, {2656342, world_flags_address[game_version]          + 4437, 6, 0x01, 0}) --Neverland Clock Tower 11:00 Door
    table.insert(location_map, {2656343, world_flags_address[game_version]          + 4437, 5, 0x01, 0}) --Neverland Clock Tower 12:00 Door
    table.insert(location_map, {2656344, world_flags_address[game_version]          + 4437, 2, 0x01, 0}) --Neverland Hold Aero Chest
    table.insert(location_map, {2656345, world_flags_address[game_version]          + 1781, 0, 0x02, 0}) --100 Acre Wood Bouncing Spot Turn in Rare Nut 1
    table.insert(location_map, {2656346, world_flags_address[game_version]          + 1782, 0, 0x02, 0}) --100 Acre Wood Bouncing Spot Turn in Rare Nut 2
    table.insert(location_map, {2656347, world_flags_address[game_version]          + 1783, 0, 0x02, 0}) --100 Acre Wood Bouncing Spot Turn in Rare Nut 3
    table.insert(location_map, {2656348, world_flags_address[game_version]          + 1784, 0, 0x02, 0}) --100 Acre Wood Bouncing Spot Turn in Rare Nut 4
    table.insert(location_map, {2656349, world_flags_address[game_version]          + 1785, 0, 0x02, 0}) --100 Acre Wood Bouncing Spot Turn in Rare Nut 5
    table.insert(location_map, {2656350, world_flags_address[game_version]          + 1794, 0, 0x01, 0}) --100 Acre Wood Pooh's House Owl Cheer
    table.insert(location_map, {2656351, world_flags_address[game_version]          + 1795, 0, 0x01, 0}) --100 Acre Wood Convert Torn Page 1
    table.insert(location_map, {2656352, world_flags_address[game_version]          + 1796, 0, 0x01, 0}) --100 Acre Wood Convert Torn Page 2
    table.insert(location_map, {2656353, world_flags_address[game_version]          + 1797, 0, 0x01, 0}) --100 Acre Wood Convert Torn Page 3
    table.insert(location_map, {2656354, world_flags_address[game_version]          + 1798, 0, 0x01, 0}) --100 Acre Wood Convert Torn Page 4
    table.insert(location_map, {2656355, world_flags_address[game_version]          + 1799, 0, 0x01, 0}) --100 Acre Wood Convert Torn Page 5
    table.insert(location_map, {2656356, world_flags_address[game_version]          + 1817, 0, 0x04, 0}) --100 Acre Wood Pooh's House Start Fire
    table.insert(location_map, {2656357, world_flags_address[game_version]          + 4150, 0, 0x04, 0}) --100 Acre Wood Pooh's Room Cabinet
    table.insert(location_map, {2656358, world_flags_address[game_version]          + 4151, 0, 0x04, 0}) --100 Acre Wood Pooh's Room Chimney
    table.insert(location_map, {2656359, world_flags_address[game_version]          + 4152, 0, 0x04, 0}) --100 Acre Wood Bouncing Spot Break Log
    table.insert(location_map, {2656360, world_flags_address[game_version]          + 4153, 0, 0x04, 0}) --100 Acre Wood Bouncing Spot Fall Through Top of Tree Next to Pooh
    table.insert(location_map, {2656361, world_flags_address[game_version]          + 4114, 0, 0x01, 0}) --Deep Jungle Camp Hi-Potion Experiment
    table.insert(location_map, {2656361, world_flags_address[game_version]          + 4113, 0, 0x01, 0}) --Deep Jungle Camp Hi-Potion Experiment
    table.insert(location_map, {2656362, world_flags_address[game_version]          + 4108, 0, 0x01, 0}) --Deep Jungle Camp Ether Experiment
    table.insert(location_map, {2656363, world_flags_address[game_version]          + 4122, 0, 0x01, 0}) --Deep Jungle Camp Replication Experiment
    table.insert(location_map, {2656364, world_flags_address[game_version]          + 1280, 0, 0x01, 0}) --Deep Jungle Cliff Save Gorillas
    table.insert(location_map, {2656365, world_flags_address[game_version]          + 1281, 0, 0x01, 0}) --Deep Jungle Tree House Save Gorillas
    table.insert(location_map, {2656366, world_flags_address[game_version]          + 1282, 0, 0x01, 0}) --Deep Jungle Camp Save Gorillas
    table.insert(location_map, {2656367, world_flags_address[game_version]          + 1283, 0, 0x01, 0}) --Deep Jungle Bamboo Thicket Save Gorillas
    table.insert(location_map, {2656368, world_flags_address[game_version]          + 1284, 0, 0x01, 0}) --Deep Jungle Climbing Trees Save Gorillas
    table.insert(location_map, {2656369, world_flags_address[game_version]          +  540, 2, 0x01, 0}) --Olympus Coliseum Olympia Chest
    table.insert(location_map, {2656370, world_flags_address[game_version]          + 4140, 0, 0x01, 0}) --Deep Jungle Jungle Slider 10 Fruits
    table.insert(location_map, {2656371, world_flags_address[game_version]          + 4141, 0, 0x01, 0}) --Deep Jungle Jungle Slider 20 Fruits
    table.insert(location_map, {2656372, world_flags_address[game_version]          + 4142, 0, 0x01, 0}) --Deep Jungle Jungle Slider 30 Fruits
    table.insert(location_map, {2656373, world_flags_address[game_version]          + 4143, 0, 0x01, 0}) --Deep Jungle Jungle Slider 40 Fruits
    table.insert(location_map, {2656374, world_flags_address[game_version]          + 4136, 0, 0x01, 0}) --Deep Jungle Jungle Slider 50 Fruits
    table.insert(location_map, {2656375, world_flags_address[game_version]          +   13, 0, 0x01, 0}) --Traverse Town 1st District Speak with Cid Event
    table.insert(location_map, {2656376, world_flags_address[game_version]          + 4054, 8, 0x01, 0}) --Wonderland Bizarre Room Read Book
    table.insert(location_map, {2656377, world_flags_address[game_version]          + 3939, 4, 0x01, 0}) --Olympus Coliseum Coliseum Gates Green Trinity
    table.insert(location_map, {2656378, ansems_reports_address[game_version]       +    1, 6, 0x01, 0}) --Agrabah Defeat Kurt Zisa Zantetsuken Event
    table.insert(location_map, {2656379, ansems_reports_address[game_version]       +    1, 4, 0x01, 0}) --Hollow Bastion Defeat Unknown EXP Necklace Event
    table.insert(location_map, {2656380, world_progress_array_address[game_version] +    2, 0, 0x28, 0}) --Olympus Coliseum Coliseum Gates Hero's License Event
    table.insert(location_map, {2656381, world_progress_array_address[game_version] +    6, 0, 0x32, 0}) --Atlantica Sunken Ship Crystal Trident Event
    table.insert(location_map, {2656382, world_progress_array_address[game_version] +    8, 0, 0x1E, 0}) --Halloween Town Graveyard Forget-Me-Not Event
    table.insert(location_map, {2656383, world_progress_array_address[game_version] +    1, 0, 0x17, 0}) --Deep Jungle Tent Protect-G Event
    table.insert(location_map, {2656384, world_progress_array_address[game_version] +    1, 0, 0x5C, 0}) --Deep Jungle Cavern of Hearts Navi-G Piece Event
    table.insert(location_map, {2656385, world_progress_array_address[game_version] +    3, 0, 0x30, 0}) --Wonderland Bizarre Room Navi-G Piece Event
    table.insert(location_map, {2656386, world_progress_array_address[game_version] +    2, 0, 0x10, 0}) --Olympus Coliseum Coliseum Gates Entry Pass Event
    table.insert(location_map, {2656400, world_flags_address[game_version]          + 3267, 0, 0x03, 0}) --Traverse Town Synth 15 Items
    table.insert(location_map, {2656401, world_flags_address[game_version]          + 3259, 8, 0x01, 0}) --Traverse Town Synth Item 01
    table.insert(location_map, {2656402, world_flags_address[game_version]          + 3259, 7, 0x01, 0}) --Traverse Town Synth Item 02
    table.insert(location_map, {2656403, world_flags_address[game_version]          + 3259, 6, 0x01, 0}) --Traverse Town Synth Item 03
    table.insert(location_map, {2656404, world_flags_address[game_version]          + 3259, 5, 0x01, 0}) --Traverse Town Synth Item 04
    table.insert(location_map, {2656405, world_flags_address[game_version]          + 3259, 4, 0x01, 0}) --Traverse Town Synth Item 05
    table.insert(location_map, {2656406, world_flags_address[game_version]          + 3259, 3, 0x01, 0}) --Traverse Town Synth Item 06
    table.insert(location_map, {2656407, world_flags_address[game_version]          + 3259, 2, 0x01, 0}) --Traverse Town Synth Item 07
    table.insert(location_map, {2656408, world_flags_address[game_version]          + 3259, 1, 0x01, 0}) --Traverse Town Synth Item 08
    table.insert(location_map, {2656409, world_flags_address[game_version]          + 3260, 8, 0x01, 0}) --Traverse Town Synth Item 09
    table.insert(location_map, {2656410, world_flags_address[game_version]          + 3260, 7, 0x01, 0}) --Traverse Town Synth Item 10
    table.insert(location_map, {2656411, world_flags_address[game_version]          + 3260, 6, 0x01, 0}) --Traverse Town Synth Item 11
    table.insert(location_map, {2656412, world_flags_address[game_version]          + 3260, 5, 0x01, 0}) --Traverse Town Synth Item 12
    table.insert(location_map, {2656413, world_flags_address[game_version]          + 3260, 4, 0x01, 0}) --Traverse Town Synth Item 13
    table.insert(location_map, {2656414, world_flags_address[game_version]          + 3260, 3, 0x01, 0}) --Traverse Town Synth Item 14
    table.insert(location_map, {2656415, world_flags_address[game_version]          + 3260, 2, 0x01, 0}) --Traverse Town Synth Item 15
    table.insert(location_map, {2656416, world_flags_address[game_version]          + 3260, 1, 0x01, 0}) --Traverse Town Synth Item 16
    table.insert(location_map, {2656417, world_flags_address[game_version]          + 3261, 8, 0x01, 0}) --Traverse Town Synth Item 17
    table.insert(location_map, {2656418, world_flags_address[game_version]          + 3261, 7, 0x01, 0}) --Traverse Town Synth Item 18
    table.insert(location_map, {2656419, world_flags_address[game_version]          + 3261, 6, 0x01, 0}) --Traverse Town Synth Item 19
    table.insert(location_map, {2656420, world_flags_address[game_version]          + 3261, 5, 0x01, 0}) --Traverse Town Synth Item 20
    table.insert(location_map, {2656421, world_flags_address[game_version]          + 3261, 4, 0x01, 0}) --Traverse Town Synth Item 21
    table.insert(location_map, {2656422, world_flags_address[game_version]          + 3261, 3, 0x01, 0}) --Traverse Town Synth Item 22
    table.insert(location_map, {2656423, world_flags_address[game_version]          + 3261, 2, 0x01, 0}) --Traverse Town Synth Item 23
    table.insert(location_map, {2656424, world_flags_address[game_version]          + 3261, 1, 0x01, 0}) --Traverse Town Synth Item 24
    table.insert(location_map, {2656425, world_flags_address[game_version]          + 3262, 8, 0x01, 0}) --Traverse Town Synth Item 25
    table.insert(location_map, {2656426, world_flags_address[game_version]          + 3262, 7, 0x01, 0}) --Traverse Town Synth Item 26
    table.insert(location_map, {2656427, world_flags_address[game_version]          + 3262, 6, 0x01, 0}) --Traverse Town Synth Item 27
    table.insert(location_map, {2656428, world_flags_address[game_version]          + 3262, 5, 0x01, 0}) --Traverse Town Synth Item 28
    table.insert(location_map, {2656429, world_flags_address[game_version]          + 3262, 4, 0x01, 0}) --Traverse Town Synth Item 29
    table.insert(location_map, {2656430, world_flags_address[game_version]          + 3262, 3, 0x01, 0}) --Traverse Town Synth Item 30
    table.insert(location_map, {2656431, world_flags_address[game_version]          + 3262, 2, 0x01, 0}) --Traverse Town Synth Item 31
    table.insert(location_map, {2656432, world_flags_address[game_version]          + 3262, 1, 0x01, 0}) --Traverse Town Synth Item 32
    table.insert(location_map, {2656433, world_flags_address[game_version]          + 3263, 8, 0x01, 0}) --Traverse Town Synth Item 33
    table.insert(location_map, {2656500, world_flags_address[game_version]          + 4019, 8, 0x01, 0}) --Traverse Town Item Shop Postcard
    table.insert(location_map, {2656501, world_flags_address[game_version]          + 4010, 0, 0x01, 0}) --Traverse Town 1st District Safe Postcard
    table.insert(location_map, {2656502, world_flags_address[game_version]          + 4017, 6, 0x01, 0}) --Traverse Town Gizmo Shop Postcard 1
    table.insert(location_map, {2656503, world_flags_address[game_version]          + 4017, 6, 0x01, 0}) --Traverse Town Gizmo Shop Postcard 2
    table.insert(location_map, {2656504, world_flags_address[game_version]          + 4019, 5, 0x01, 0}) --Traverse Town Item Workshop Postcard
    table.insert(location_map, {2656505, world_flags_address[game_version]          + 4019, 7, 0x01, 0}) --Traverse Town 3rd District Balcony Postcard
    table.insert(location_map, {2656506, world_flags_address[game_version]          + 4019, 4, 0x01, 0}) --Traverse Town Geppetto's House Postcard
    table.insert(location_map, {2656508, world_flags_address[game_version]          + 4291, 1, 0x01, 0}) --Halloween Town Lab Torn Page
    table.insert(location_map, {2656516, world_flags_address[game_version]          + 4513, 0, 0x02, 0}) --Hollow Bastion Entrance Hall Emblem Piece (Flame)
    table.insert(location_map, {2656517, world_flags_address[game_version]          + 4514, 0, 0x02, 0}) --Hollow Bastion Entrance Hall Emblem Piece (Chest)
    table.insert(location_map, {2656518, world_flags_address[game_version]          + 4515, 0, 0x02, 0}) --Hollow Bastion Entrance Hall Emblem Piece (Statue)
    table.insert(location_map, {2656519, world_flags_address[game_version]          + 4516, 0, 0x02, 0}) --Hollow Bastion Entrance Hall Emblem Piece (Fountain)
    table.insert(location_map, {2656520, world_flags_address[game_version]          +    0, 0, 0x01, 1}) --Traverse Town 1st District Leon Gift
    table.insert(location_map, {2656521, world_flags_address[game_version]          +    2, 0, 0x01, 0}) --Traverse Town 1st District Aerith Gift
    table.insert(location_map, {2656522, world_flags_address[game_version]          + 1026, 0, 0x01, 0}) --Hollow Bastion Library Speak to Belle Divine Rose
    table.insert(location_map, {2656523, world_flags_address[game_version]          + 1025, 0, 0x01, 0}) --Hollow Bastion Library Speak to Aerith Cure
    table.insert(location_map, {2657018, ansems_reports_address[game_version]       +    0, 8, 0x01, 0}) --Agrabah Defeat Jafar Genie Ansem's Report 1
    table.insert(location_map, {2657017, ansems_reports_address[game_version]       +    0, 7, 0x01, 0}) --Hollow Bastion Speak with Aerith Ansem's Report 2
    table.insert(location_map, {2657016, ansems_reports_address[game_version]       +    0, 6, 0x01, 0}) --Atlantica Defeat Ursula II Ansem's Report 3
    table.insert(location_map, {2657015, ansems_reports_address[game_version]       +    0, 5, 0x01, 0}) --Hollow Bastion Speak with Aerith Ansem's Report 4
    table.insert(location_map, {2657014, ansems_reports_address[game_version]       +    0, 4, 0x01, 0}) --Hollow Bastion Defeat Maleficent Ansem's Report 5
    table.insert(location_map, {2657013, ansems_reports_address[game_version]       +    0, 3, 0x01, 0}) --Hollow Bastion Speak with Aerith Ansem's Report 6
    table.insert(location_map, {2657012, ansems_reports_address[game_version]       +    0, 2, 0x01, 0}) --Halloween Town Defeat Oogie Boogie Ansem's Report 7
    table.insert(location_map, {2657011, ansems_reports_address[game_version]       +    0, 1, 0x01, 0}) --Olympus Coliseum Defeat Hades Ansem's Report 8
    table.insert(location_map, {2657028, ansems_reports_address[game_version]       +    1, 8, 0x01, 0}) --Neverland Defeat Hook Ansem's Report 9
    table.insert(location_map, {2657027, ansems_reports_address[game_version]       +    1, 7, 0x01, 0}) --Hollow Bastion Speak with Aerith Ansem's Report 10
    table.insert(location_map, {2657026, ansems_reports_address[game_version]       +    1, 6, 0x01, 0}) --Agrabah Defeat Kurt Zisa Ansem's Report 11
    table.insert(location_map, {2657025, ansems_reports_address[game_version]       +    1, 5, 0x01, 0}) --Olympus Coliseum Defeat Sephiroth Ansem's Report 12
    table.insert(location_map, {2657024, ansems_reports_address[game_version]       +    1, 4, 0x01, 0}) --Hollow Bastion Defeat Unknown Ansem's Report 13
    table.insert(location_map, {2658001, soras_level_address[game_version]          +    0, 0, 0x01, 0}) --Level 001 (Slot 1)
    table.insert(location_map, {2658002, soras_level_address[game_version]          +    0, 0, 0x02, 0}) --Level 002 (Slot 1)
    table.insert(location_map, {2658003, soras_level_address[game_version]          +    0, 0, 0x03, 0}) --Level 003 (Slot 1)
    table.insert(location_map, {2658004, soras_level_address[game_version]          +    0, 0, 0x04, 0}) --Level 004 (Slot 1)
    table.insert(location_map, {2658005, soras_level_address[game_version]          +    0, 0, 0x05, 0}) --Level 005 (Slot 1)
    table.insert(location_map, {2658006, soras_level_address[game_version]          +    0, 0, 0x06, 0}) --Level 006 (Slot 1)
    table.insert(location_map, {2658007, soras_level_address[game_version]          +    0, 0, 0x07, 0}) --Level 007 (Slot 1)
    table.insert(location_map, {2658008, soras_level_address[game_version]          +    0, 0, 0x08, 0}) --Level 008 (Slot 1)
    table.insert(location_map, {2658009, soras_level_address[game_version]          +    0, 0, 0x09, 0}) --Level 009 (Slot 1)
    table.insert(location_map, {2658010, soras_level_address[game_version]          +    0, 0, 0x0A, 0}) --Level 010 (Slot 1)
    table.insert(location_map, {2658011, soras_level_address[game_version]          +    0, 0, 0x0B, 0}) --Level 011 (Slot 1)
    table.insert(location_map, {2658012, soras_level_address[game_version]          +    0, 0, 0x0C, 0}) --Level 012 (Slot 1)
    table.insert(location_map, {2658013, soras_level_address[game_version]          +    0, 0, 0x0D, 0}) --Level 013 (Slot 1)
    table.insert(location_map, {2658014, soras_level_address[game_version]          +    0, 0, 0x0E, 0}) --Level 014 (Slot 1)
    table.insert(location_map, {2658015, soras_level_address[game_version]          +    0, 0, 0x0F, 0}) --Level 015 (Slot 1)
    table.insert(location_map, {2658016, soras_level_address[game_version]          +    0, 0, 0x10, 0}) --Level 016 (Slot 1)
    table.insert(location_map, {2658017, soras_level_address[game_version]          +    0, 0, 0x11, 0}) --Level 017 (Slot 1)
    table.insert(location_map, {2658018, soras_level_address[game_version]          +    0, 0, 0x12, 0}) --Level 018 (Slot 1)
    table.insert(location_map, {2658019, soras_level_address[game_version]          +    0, 0, 0x13, 0}) --Level 019 (Slot 1)
    table.insert(location_map, {2658020, soras_level_address[game_version]          +    0, 0, 0x14, 0}) --Level 020 (Slot 1)
    table.insert(location_map, {2658021, soras_level_address[game_version]          +    0, 0, 0x15, 0}) --Level 021 (Slot 1)
    table.insert(location_map, {2658022, soras_level_address[game_version]          +    0, 0, 0x16, 0}) --Level 022 (Slot 1)
    table.insert(location_map, {2658023, soras_level_address[game_version]          +    0, 0, 0x17, 0}) --Level 023 (Slot 1)
    table.insert(location_map, {2658024, soras_level_address[game_version]          +    0, 0, 0x18, 0}) --Level 024 (Slot 1)
    table.insert(location_map, {2658025, soras_level_address[game_version]          +    0, 0, 0x19, 0}) --Level 025 (Slot 1)
    table.insert(location_map, {2658026, soras_level_address[game_version]          +    0, 0, 0x1A, 0}) --Level 026 (Slot 1)
    table.insert(location_map, {2658027, soras_level_address[game_version]          +    0, 0, 0x1B, 0}) --Level 027 (Slot 1)
    table.insert(location_map, {2658028, soras_level_address[game_version]          +    0, 0, 0x1C, 0}) --Level 028 (Slot 1)
    table.insert(location_map, {2658029, soras_level_address[game_version]          +    0, 0, 0x1D, 0}) --Level 029 (Slot 1)
    table.insert(location_map, {2658030, soras_level_address[game_version]          +    0, 0, 0x1E, 0}) --Level 030 (Slot 1)
    table.insert(location_map, {2658031, soras_level_address[game_version]          +    0, 0, 0x1F, 0}) --Level 031 (Slot 1)
    table.insert(location_map, {2658032, soras_level_address[game_version]          +    0, 0, 0x20, 0}) --Level 032 (Slot 1)
    table.insert(location_map, {2658033, soras_level_address[game_version]          +    0, 0, 0x21, 0}) --Level 033 (Slot 1)
    table.insert(location_map, {2658034, soras_level_address[game_version]          +    0, 0, 0x22, 0}) --Level 034 (Slot 1)
    table.insert(location_map, {2658035, soras_level_address[game_version]          +    0, 0, 0x23, 0}) --Level 035 (Slot 1)
    table.insert(location_map, {2658036, soras_level_address[game_version]          +    0, 0, 0x24, 0}) --Level 036 (Slot 1)
    table.insert(location_map, {2658037, soras_level_address[game_version]          +    0, 0, 0x25, 0}) --Level 037 (Slot 1)
    table.insert(location_map, {2658038, soras_level_address[game_version]          +    0, 0, 0x26, 0}) --Level 038 (Slot 1)
    table.insert(location_map, {2658039, soras_level_address[game_version]          +    0, 0, 0x27, 0}) --Level 039 (Slot 1)
    table.insert(location_map, {2658040, soras_level_address[game_version]          +    0, 0, 0x28, 0}) --Level 040 (Slot 1)
    table.insert(location_map, {2658041, soras_level_address[game_version]          +    0, 0, 0x29, 0}) --Level 041 (Slot 1)
    table.insert(location_map, {2658042, soras_level_address[game_version]          +    0, 0, 0x2A, 0}) --Level 042 (Slot 1)
    table.insert(location_map, {2658043, soras_level_address[game_version]          +    0, 0, 0x2B, 0}) --Level 043 (Slot 1)
    table.insert(location_map, {2658044, soras_level_address[game_version]          +    0, 0, 0x2C, 0}) --Level 044 (Slot 1)
    table.insert(location_map, {2658045, soras_level_address[game_version]          +    0, 0, 0x2D, 0}) --Level 045 (Slot 1)
    table.insert(location_map, {2658046, soras_level_address[game_version]          +    0, 0, 0x2E, 0}) --Level 046 (Slot 1)
    table.insert(location_map, {2658047, soras_level_address[game_version]          +    0, 0, 0x2F, 0}) --Level 047 (Slot 1)
    table.insert(location_map, {2658048, soras_level_address[game_version]          +    0, 0, 0x30, 0}) --Level 048 (Slot 1)
    table.insert(location_map, {2658049, soras_level_address[game_version]          +    0, 0, 0x31, 0}) --Level 049 (Slot 1)
    table.insert(location_map, {2658050, soras_level_address[game_version]          +    0, 0, 0x32, 0}) --Level 050 (Slot 1)
    table.insert(location_map, {2658051, soras_level_address[game_version]          +    0, 0, 0x33, 0}) --Level 051 (Slot 1)
    table.insert(location_map, {2658052, soras_level_address[game_version]          +    0, 0, 0x34, 0}) --Level 052 (Slot 1)
    table.insert(location_map, {2658053, soras_level_address[game_version]          +    0, 0, 0x35, 0}) --Level 053 (Slot 1)
    table.insert(location_map, {2658054, soras_level_address[game_version]          +    0, 0, 0x36, 0}) --Level 054 (Slot 1)
    table.insert(location_map, {2658055, soras_level_address[game_version]          +    0, 0, 0x37, 0}) --Level 055 (Slot 1)
    table.insert(location_map, {2658056, soras_level_address[game_version]          +    0, 0, 0x38, 0}) --Level 056 (Slot 1)
    table.insert(location_map, {2658057, soras_level_address[game_version]          +    0, 0, 0x39, 0}) --Level 057 (Slot 1)
    table.insert(location_map, {2658058, soras_level_address[game_version]          +    0, 0, 0x3A, 0}) --Level 058 (Slot 1)
    table.insert(location_map, {2658059, soras_level_address[game_version]          +    0, 0, 0x3B, 0}) --Level 059 (Slot 1)
    table.insert(location_map, {2658060, soras_level_address[game_version]          +    0, 0, 0x3C, 0}) --Level 060 (Slot 1)
    table.insert(location_map, {2658061, soras_level_address[game_version]          +    0, 0, 0x3D, 0}) --Level 061 (Slot 1)
    table.insert(location_map, {2658062, soras_level_address[game_version]          +    0, 0, 0x3E, 0}) --Level 062 (Slot 1)
    table.insert(location_map, {2658063, soras_level_address[game_version]          +    0, 0, 0x3F, 0}) --Level 063 (Slot 1)
    table.insert(location_map, {2658064, soras_level_address[game_version]          +    0, 0, 0x40, 0}) --Level 064 (Slot 1)
    table.insert(location_map, {2658065, soras_level_address[game_version]          +    0, 0, 0x41, 0}) --Level 065 (Slot 1)
    table.insert(location_map, {2658066, soras_level_address[game_version]          +    0, 0, 0x42, 0}) --Level 066 (Slot 1)
    table.insert(location_map, {2658067, soras_level_address[game_version]          +    0, 0, 0x43, 0}) --Level 067 (Slot 1)
    table.insert(location_map, {2658068, soras_level_address[game_version]          +    0, 0, 0x44, 0}) --Level 068 (Slot 1)
    table.insert(location_map, {2658069, soras_level_address[game_version]          +    0, 0, 0x45, 0}) --Level 069 (Slot 1)
    table.insert(location_map, {2658070, soras_level_address[game_version]          +    0, 0, 0x46, 0}) --Level 070 (Slot 1)
    table.insert(location_map, {2658071, soras_level_address[game_version]          +    0, 0, 0x47, 0}) --Level 071 (Slot 1)
    table.insert(location_map, {2658072, soras_level_address[game_version]          +    0, 0, 0x48, 0}) --Level 072 (Slot 1)
    table.insert(location_map, {2658073, soras_level_address[game_version]          +    0, 0, 0x49, 0}) --Level 073 (Slot 1)
    table.insert(location_map, {2658074, soras_level_address[game_version]          +    0, 0, 0x4A, 0}) --Level 074 (Slot 1)
    table.insert(location_map, {2658075, soras_level_address[game_version]          +    0, 0, 0x4B, 0}) --Level 075 (Slot 1)
    table.insert(location_map, {2658076, soras_level_address[game_version]          +    0, 0, 0x4C, 0}) --Level 076 (Slot 1)
    table.insert(location_map, {2658077, soras_level_address[game_version]          +    0, 0, 0x4D, 0}) --Level 077 (Slot 1)
    table.insert(location_map, {2658078, soras_level_address[game_version]          +    0, 0, 0x4E, 0}) --Level 078 (Slot 1)
    table.insert(location_map, {2658079, soras_level_address[game_version]          +    0, 0, 0x4F, 0}) --Level 079 (Slot 1)
    table.insert(location_map, {2658080, soras_level_address[game_version]          +    0, 0, 0x50, 0}) --Level 080 (Slot 1)
    table.insert(location_map, {2658081, soras_level_address[game_version]          +    0, 0, 0x51, 0}) --Level 081 (Slot 1)
    table.insert(location_map, {2658082, soras_level_address[game_version]          +    0, 0, 0x52, 0}) --Level 082 (Slot 1)
    table.insert(location_map, {2658083, soras_level_address[game_version]          +    0, 0, 0x53, 0}) --Level 083 (Slot 1)
    table.insert(location_map, {2658084, soras_level_address[game_version]          +    0, 0, 0x54, 0}) --Level 084 (Slot 1)
    table.insert(location_map, {2658085, soras_level_address[game_version]          +    0, 0, 0x55, 0}) --Level 085 (Slot 1)
    table.insert(location_map, {2658086, soras_level_address[game_version]          +    0, 0, 0x56, 0}) --Level 086 (Slot 1)
    table.insert(location_map, {2658087, soras_level_address[game_version]          +    0, 0, 0x57, 0}) --Level 087 (Slot 1)
    table.insert(location_map, {2658088, soras_level_address[game_version]          +    0, 0, 0x58, 0}) --Level 088 (Slot 1)
    table.insert(location_map, {2658089, soras_level_address[game_version]          +    0, 0, 0x59, 0}) --Level 089 (Slot 1)
    table.insert(location_map, {2658090, soras_level_address[game_version]          +    0, 0, 0x5A, 0}) --Level 090 (Slot 1)
    table.insert(location_map, {2658091, soras_level_address[game_version]          +    0, 0, 0x5B, 0}) --Level 091 (Slot 1)
    table.insert(location_map, {2658092, soras_level_address[game_version]          +    0, 0, 0x5C, 0}) --Level 092 (Slot 1)
    table.insert(location_map, {2658093, soras_level_address[game_version]          +    0, 0, 0x5D, 0}) --Level 093 (Slot 1)
    table.insert(location_map, {2658094, soras_level_address[game_version]          +    0, 0, 0x5E, 0}) --Level 094 (Slot 1)
    table.insert(location_map, {2658095, soras_level_address[game_version]          +    0, 0, 0x5F, 0}) --Level 095 (Slot 1)
    table.insert(location_map, {2658096, soras_level_address[game_version]          +    0, 0, 0x60, 0}) --Level 096 (Slot 1)
    table.insert(location_map, {2658097, soras_level_address[game_version]          +    0, 0, 0x61, 0}) --Level 097 (Slot 1)
    table.insert(location_map, {2658098, soras_level_address[game_version]          +    0, 0, 0x62, 0}) --Level 098 (Slot 1)
    table.insert(location_map, {2658099, soras_level_address[game_version]          +    0, 0, 0x63, 0}) --Level 099 (Slot 1)
    table.insert(location_map, {2658100, soras_level_address[game_version]          +    0, 0, 0x64, 0}) --Level 100 (Slot 1)
    table.insert(location_map, {2658101, soras_level_address[game_version]          +    0, 0, 0x01, 0}) --Level 001 (Slot 2)
    table.insert(location_map, {2658102, soras_level_address[game_version]          +    0, 0, 0x02, 0}) --Level 002 (Slot 2)
    table.insert(location_map, {2658103, soras_level_address[game_version]          +    0, 0, 0x03, 0}) --Level 003 (Slot 2)
    table.insert(location_map, {2658104, soras_level_address[game_version]          +    0, 0, 0x04, 0}) --Level 004 (Slot 2)
    table.insert(location_map, {2658105, soras_level_address[game_version]          +    0, 0, 0x05, 0}) --Level 005 (Slot 2)
    table.insert(location_map, {2658106, soras_level_address[game_version]          +    0, 0, 0x06, 0}) --Level 006 (Slot 2)
    table.insert(location_map, {2658107, soras_level_address[game_version]          +    0, 0, 0x07, 0}) --Level 007 (Slot 2)
    table.insert(location_map, {2658108, soras_level_address[game_version]          +    0, 0, 0x08, 0}) --Level 008 (Slot 2)
    table.insert(location_map, {2658109, soras_level_address[game_version]          +    0, 0, 0x09, 0}) --Level 009 (Slot 2)
    table.insert(location_map, {2658110, soras_level_address[game_version]          +    0, 0, 0x0A, 0}) --Level 010 (Slot 2)
    table.insert(location_map, {2658111, soras_level_address[game_version]          +    0, 0, 0x0B, 0}) --Level 011 (Slot 2)
    table.insert(location_map, {2658112, soras_level_address[game_version]          +    0, 0, 0x0C, 0}) --Level 012 (Slot 2)
    table.insert(location_map, {2658113, soras_level_address[game_version]          +    0, 0, 0x0D, 0}) --Level 013 (Slot 2)
    table.insert(location_map, {2658114, soras_level_address[game_version]          +    0, 0, 0x0E, 0}) --Level 014 (Slot 2)
    table.insert(location_map, {2658115, soras_level_address[game_version]          +    0, 0, 0x0F, 0}) --Level 015 (Slot 2)
    table.insert(location_map, {2658116, soras_level_address[game_version]          +    0, 0, 0x10, 0}) --Level 016 (Slot 2)
    table.insert(location_map, {2658117, soras_level_address[game_version]          +    0, 0, 0x11, 0}) --Level 017 (Slot 2)
    table.insert(location_map, {2658118, soras_level_address[game_version]          +    0, 0, 0x12, 0}) --Level 018 (Slot 2)
    table.insert(location_map, {2658119, soras_level_address[game_version]          +    0, 0, 0x13, 0}) --Level 019 (Slot 2)
    table.insert(location_map, {2658120, soras_level_address[game_version]          +    0, 0, 0x14, 0}) --Level 020 (Slot 2)
    table.insert(location_map, {2658121, soras_level_address[game_version]          +    0, 0, 0x15, 0}) --Level 021 (Slot 2)
    table.insert(location_map, {2658122, soras_level_address[game_version]          +    0, 0, 0x16, 0}) --Level 022 (Slot 2)
    table.insert(location_map, {2658123, soras_level_address[game_version]          +    0, 0, 0x17, 0}) --Level 023 (Slot 2)
    table.insert(location_map, {2658124, soras_level_address[game_version]          +    0, 0, 0x18, 0}) --Level 024 (Slot 2)
    table.insert(location_map, {2658125, soras_level_address[game_version]          +    0, 0, 0x19, 0}) --Level 025 (Slot 2)
    table.insert(location_map, {2658126, soras_level_address[game_version]          +    0, 0, 0x1A, 0}) --Level 026 (Slot 2)
    table.insert(location_map, {2658127, soras_level_address[game_version]          +    0, 0, 0x1B, 0}) --Level 027 (Slot 2)
    table.insert(location_map, {2658128, soras_level_address[game_version]          +    0, 0, 0x1C, 0}) --Level 028 (Slot 2)
    table.insert(location_map, {2658129, soras_level_address[game_version]          +    0, 0, 0x1D, 0}) --Level 029 (Slot 2)
    table.insert(location_map, {2658130, soras_level_address[game_version]          +    0, 0, 0x1E, 0}) --Level 030 (Slot 2)
    table.insert(location_map, {2658131, soras_level_address[game_version]          +    0, 0, 0x1F, 0}) --Level 031 (Slot 2)
    table.insert(location_map, {2658132, soras_level_address[game_version]          +    0, 0, 0x20, 0}) --Level 032 (Slot 2)
    table.insert(location_map, {2658133, soras_level_address[game_version]          +    0, 0, 0x21, 0}) --Level 033 (Slot 2)
    table.insert(location_map, {2658134, soras_level_address[game_version]          +    0, 0, 0x22, 0}) --Level 034 (Slot 2)
    table.insert(location_map, {2658135, soras_level_address[game_version]          +    0, 0, 0x23, 0}) --Level 035 (Slot 2)
    table.insert(location_map, {2658136, soras_level_address[game_version]          +    0, 0, 0x24, 0}) --Level 036 (Slot 2)
    table.insert(location_map, {2658137, soras_level_address[game_version]          +    0, 0, 0x25, 0}) --Level 037 (Slot 2)
    table.insert(location_map, {2658138, soras_level_address[game_version]          +    0, 0, 0x26, 0}) --Level 038 (Slot 2)
    table.insert(location_map, {2658139, soras_level_address[game_version]          +    0, 0, 0x27, 0}) --Level 039 (Slot 2)
    table.insert(location_map, {2658140, soras_level_address[game_version]          +    0, 0, 0x28, 0}) --Level 040 (Slot 2)
    table.insert(location_map, {2658141, soras_level_address[game_version]          +    0, 0, 0x29, 0}) --Level 041 (Slot 2)
    table.insert(location_map, {2658142, soras_level_address[game_version]          +    0, 0, 0x2A, 0}) --Level 042 (Slot 2)
    table.insert(location_map, {2658143, soras_level_address[game_version]          +    0, 0, 0x2B, 0}) --Level 043 (Slot 2)
    table.insert(location_map, {2658144, soras_level_address[game_version]          +    0, 0, 0x2C, 0}) --Level 044 (Slot 2)
    table.insert(location_map, {2658145, soras_level_address[game_version]          +    0, 0, 0x2D, 0}) --Level 045 (Slot 2)
    table.insert(location_map, {2658146, soras_level_address[game_version]          +    0, 0, 0x2E, 0}) --Level 046 (Slot 2)
    table.insert(location_map, {2658147, soras_level_address[game_version]          +    0, 0, 0x2F, 0}) --Level 047 (Slot 2)
    table.insert(location_map, {2658148, soras_level_address[game_version]          +    0, 0, 0x30, 0}) --Level 048 (Slot 2)
    table.insert(location_map, {2658149, soras_level_address[game_version]          +    0, 0, 0x31, 0}) --Level 049 (Slot 2)
    table.insert(location_map, {2658150, soras_level_address[game_version]          +    0, 0, 0x32, 0}) --Level 050 (Slot 2)
    table.insert(location_map, {2658151, soras_level_address[game_version]          +    0, 0, 0x33, 0}) --Level 051 (Slot 2)
    table.insert(location_map, {2658152, soras_level_address[game_version]          +    0, 0, 0x34, 0}) --Level 052 (Slot 2)
    table.insert(location_map, {2658153, soras_level_address[game_version]          +    0, 0, 0x35, 0}) --Level 053 (Slot 2)
    table.insert(location_map, {2658154, soras_level_address[game_version]          +    0, 0, 0x36, 0}) --Level 054 (Slot 2)
    table.insert(location_map, {2658155, soras_level_address[game_version]          +    0, 0, 0x37, 0}) --Level 055 (Slot 2)
    table.insert(location_map, {2658156, soras_level_address[game_version]          +    0, 0, 0x38, 0}) --Level 056 (Slot 2)
    table.insert(location_map, {2658157, soras_level_address[game_version]          +    0, 0, 0x39, 0}) --Level 057 (Slot 2)
    table.insert(location_map, {2658158, soras_level_address[game_version]          +    0, 0, 0x3A, 0}) --Level 058 (Slot 2)
    table.insert(location_map, {2658159, soras_level_address[game_version]          +    0, 0, 0x3B, 0}) --Level 059 (Slot 2)
    table.insert(location_map, {2658160, soras_level_address[game_version]          +    0, 0, 0x3C, 0}) --Level 060 (Slot 2)
    table.insert(location_map, {2658161, soras_level_address[game_version]          +    0, 0, 0x3D, 0}) --Level 061 (Slot 2)
    table.insert(location_map, {2658162, soras_level_address[game_version]          +    0, 0, 0x3E, 0}) --Level 062 (Slot 2)
    table.insert(location_map, {2658163, soras_level_address[game_version]          +    0, 0, 0x3F, 0}) --Level 063 (Slot 2)
    table.insert(location_map, {2658164, soras_level_address[game_version]          +    0, 0, 0x40, 0}) --Level 064 (Slot 2)
    table.insert(location_map, {2658165, soras_level_address[game_version]          +    0, 0, 0x41, 0}) --Level 065 (Slot 2)
    table.insert(location_map, {2658166, soras_level_address[game_version]          +    0, 0, 0x42, 0}) --Level 066 (Slot 2)
    table.insert(location_map, {2658167, soras_level_address[game_version]          +    0, 0, 0x43, 0}) --Level 067 (Slot 2)
    table.insert(location_map, {2658168, soras_level_address[game_version]          +    0, 0, 0x44, 0}) --Level 068 (Slot 2)
    table.insert(location_map, {2658169, soras_level_address[game_version]          +    0, 0, 0x45, 0}) --Level 069 (Slot 2)
    table.insert(location_map, {2658170, soras_level_address[game_version]          +    0, 0, 0x46, 0}) --Level 070 (Slot 2)
    table.insert(location_map, {2658171, soras_level_address[game_version]          +    0, 0, 0x47, 0}) --Level 071 (Slot 2)
    table.insert(location_map, {2658172, soras_level_address[game_version]          +    0, 0, 0x48, 0}) --Level 072 (Slot 2)
    table.insert(location_map, {2658173, soras_level_address[game_version]          +    0, 0, 0x49, 0}) --Level 073 (Slot 2)
    table.insert(location_map, {2658174, soras_level_address[game_version]          +    0, 0, 0x4A, 0}) --Level 074 (Slot 2)
    table.insert(location_map, {2658175, soras_level_address[game_version]          +    0, 0, 0x4B, 0}) --Level 075 (Slot 2)
    table.insert(location_map, {2658176, soras_level_address[game_version]          +    0, 0, 0x4C, 0}) --Level 076 (Slot 2)
    table.insert(location_map, {2658177, soras_level_address[game_version]          +    0, 0, 0x4D, 0}) --Level 077 (Slot 2)
    table.insert(location_map, {2658178, soras_level_address[game_version]          +    0, 0, 0x4E, 0}) --Level 078 (Slot 2)
    table.insert(location_map, {2658179, soras_level_address[game_version]          +    0, 0, 0x4F, 0}) --Level 079 (Slot 2)
    table.insert(location_map, {2658180, soras_level_address[game_version]          +    0, 0, 0x50, 0}) --Level 080 (Slot 2)
    table.insert(location_map, {2658181, soras_level_address[game_version]          +    0, 0, 0x51, 0}) --Level 081 (Slot 2)
    table.insert(location_map, {2658182, soras_level_address[game_version]          +    0, 0, 0x52, 0}) --Level 082 (Slot 2)
    table.insert(location_map, {2658183, soras_level_address[game_version]          +    0, 0, 0x53, 0}) --Level 083 (Slot 2)
    table.insert(location_map, {2658184, soras_level_address[game_version]          +    0, 0, 0x54, 0}) --Level 084 (Slot 2)
    table.insert(location_map, {2658185, soras_level_address[game_version]          +    0, 0, 0x55, 0}) --Level 085 (Slot 2)
    table.insert(location_map, {2658186, soras_level_address[game_version]          +    0, 0, 0x56, 0}) --Level 086 (Slot 2)
    table.insert(location_map, {2658187, soras_level_address[game_version]          +    0, 0, 0x57, 0}) --Level 087 (Slot 2)
    table.insert(location_map, {2658188, soras_level_address[game_version]          +    0, 0, 0x58, 0}) --Level 088 (Slot 2)
    table.insert(location_map, {2658189, soras_level_address[game_version]          +    0, 0, 0x59, 0}) --Level 089 (Slot 2)
    table.insert(location_map, {2658190, soras_level_address[game_version]          +    0, 0, 0x5A, 0}) --Level 090 (Slot 2)
    table.insert(location_map, {2658191, soras_level_address[game_version]          +    0, 0, 0x5B, 0}) --Level 091 (Slot 2)
    table.insert(location_map, {2658192, soras_level_address[game_version]          +    0, 0, 0x5C, 0}) --Level 092 (Slot 2)
    table.insert(location_map, {2658193, soras_level_address[game_version]          +    0, 0, 0x5D, 0}) --Level 093 (Slot 2)
    table.insert(location_map, {2658194, soras_level_address[game_version]          +    0, 0, 0x5E, 0}) --Level 094 (Slot 2)
    table.insert(location_map, {2658195, soras_level_address[game_version]          +    0, 0, 0x5F, 0}) --Level 095 (Slot 2)
    table.insert(location_map, {2658196, soras_level_address[game_version]          +    0, 0, 0x60, 0}) --Level 096 (Slot 2)
    table.insert(location_map, {2658197, soras_level_address[game_version]          +    0, 0, 0x61, 0}) --Level 097 (Slot 2)
    table.insert(location_map, {2658198, soras_level_address[game_version]          +    0, 0, 0x62, 0}) --Level 098 (Slot 2)
    table.insert(location_map, {2658199, soras_level_address[game_version]          +    0, 0, 0x63, 0}) --Level 099 (Slot 2)
    table.insert(location_map, {2658200, soras_level_address[game_version]          +    0, 0, 0x64, 0}) --Level 100 (Slot 2)
    table.insert(location_map, {2659001, olympus_flags_address[game_version]        +    0, 0, 0x01, 0}) --Complete Phil Cup
    table.insert(location_map, {2659002, olympus_flags_address[game_version]        +    0, 0, 0x02, 0}) --Complete Phil Cup Solo
    table.insert(location_map, {2659003, olympus_flags_address[game_version]        +    0, 0, 0x03, 0}) --Complete Phil Cup Time Trial
    table.insert(location_map, {2659004, olympus_flags_address[game_version]        +    1, 0, 0x01, 0}) --Complete Pegasus Cup
    table.insert(location_map, {2659005, olympus_flags_address[game_version]        +    1, 0, 0x02, 0}) --Complete Pegasus Cup Solo
    table.insert(location_map, {2659006, olympus_flags_address[game_version]        +    1, 0, 0x03, 0}) --Complete Pegasus Cup Time Trial
    table.insert(location_map, {2659007, olympus_flags_address[game_version]        +    2, 0, 0x01, 0}) --Complete Hercules Cup
    table.insert(location_map, {2659008, olympus_flags_address[game_version]        +    2, 0, 0x02, 0}) --Complete Hercules Cup Solo
    table.insert(location_map, {2659009, olympus_flags_address[game_version]        +    2, 0, 0x03, 0}) --Complete Hercules Cup Time Trial
    table.insert(location_map, {2659010, olympus_flags_address[game_version]        +    3, 0, 0x01, 0}) --Complete Hades Cup
    table.insert(location_map, {2659011, olympus_flags_address[game_version]        +    3, 0, 0x02, 0}) --Complete Hades Cup Solo
    table.insert(location_map, {2659012, olympus_flags_address[game_version]        +    3, 0, 0x03, 0}) --Complete Hades Cup Time Trial
    table.insert(location_map, {2659013, olympus_flags_address[game_version]        +   11, 0, 0x01, 0}) --Hades Cup Defeat Cloud and Leon Event
    table.insert(location_map, {2659014, olympus_flags_address[game_version]        +   12, 0, 0x01, 0}) --Hades Cup Defeat Yuffie Event
    table.insert(location_map, {2659015, olympus_flags_address[game_version]        +   13, 0, 0x01, 0}) --Hades Cup Defeat Cerberus Event
    table.insert(location_map, {2659016, olympus_flags_address[game_version]        +   14, 0, 0x01, 0}) --Hades Cup Defeat Behemoth Event
    table.insert(location_map, {2659017, ansems_reports_address[game_version]       +    0, 1, 0x01, 0}) --Hades Cup Defeat Hades Event
    table.insert(location_map, {2659018, olympus_flags_address[game_version]        +    2, 0, 0x01, 0}) --Hercules Cup Defeat Cloud Event
    table.insert(location_map, {2659019, olympus_flags_address[game_version]        +    2, 0, 0x01, 0}) --Hercules Cup Yellow Trinity Event
end

function write_location_file(location_id)
    if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
        file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
        io.output(file)
        io.write("")
        io.close(file)
    end
end

function send_locations(frame_count)
    for index, data in pairs(location_map) do
        if index % 60 == frame_count then
            location_id      = data[1]
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
                    write_location_file(location_id)
                end
            elseif special_function == 1 then --Leon Gift
                world_flags_address = {0x2DEAA6D, 0x2DEA06D}
                if ReadByte(address) >= compare_value and ReadByte(world_flags_address[game_version]) >= 0x31 then
                    write_location_file(location_id)
                end
            end
        end
    end
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
        fill_location_map()
    end
end

function _OnFrame()
    if canExecute then
        frame_count = (frame_count + 1) % 60
        send_locations(frame_count)
    end
end