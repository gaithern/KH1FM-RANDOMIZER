-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------              by Gicu           -----
-------------------------------------------

LUAGUI_NAME = "1fmRandoReceiveAPItems"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Receive AP Items"

canExecute = false
game_version = 1
initializing = true

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

item_categories = {
    equipment = 0,
    consumable = 1,
    unlock = 2,
    ability = 3,
    magic = 4,
    trinity = 5,
    summon = 6,
    statsUp = 7,
    synthesis = 8,
}
message_cache = {
    items = {},
    sent  = {},
    debug = { {} },
    locationID = -1,
}
prompt_colours = {
    blue_donald = -8,
    green_goofy = -4,
    red_sora = 0,
    purple_evil = 4,
    green_goofy_dark = 8,
    purple_pink = 12,
    blue_light = 16,
    green_mint = 20,
    orange = 24,
    violet = 28,
    green_goofy_intensiv = 32,
    purple_pink_intensiv = 36,
    blue_light_intensiv = 40,
    red_rose = 64,
    red_trap = 140
}
item_usefulness = {
    trap = 0,
    useless = 1,
    normal = 2,
    progression = 3,
    special = 4,
}
colourOffsetIterator = -8

function define_items()
  items = {
  { ID = 2640000, Name = "Victory",                   Usefulness = item_usefulness.special },
  { ID = 2641001, Name = "Potion", },
  { ID = 2641002, Name = "Hi-Potion", },
  { ID = 2641003, Name = "Ether", },
  { ID = 2641004, Name = "Elixir", },
  { ID = 2641005, Name = "BO5" },
  { ID = 2641006, Name = "Mega-Potion", },
  { ID = 2641007, Name = "Mega-Ether", },
  { ID = 2641008, Name = "Megalixir", },
  { ID = 2641009, Name = "Torn Page",                 Usefulness = item_usefulness.progression },
  { ID = 2641010, Name = "Final Door Key",            Usefulness = item_usefulness.progression },
  { ID = 2641011, Name = "Energy Stone" },
  { ID = 2641012, Name = "Blazing Stone" },
  { ID = 2641013, Name = "Frost Stone" },
  { ID = 2641014, Name = "Lightning Stone" },
  { ID = 2641015, Name = "Dazzling Stone" },
  { ID = 2641016, Name = "Stormy Stone" },
  { ID = 2641017, Name = "Protect Chain" },
  { ID = 2641018, Name = "Protera Chain" },
  { ID = 2641019, Name = "Protega Chain" },
  { ID = 2641020, Name = "Fire Ring" },
  { ID = 2641021, Name = "Fira Ring" },
  { ID = 2641022, Name = "Firaga Ring" },
  { ID = 2641023, Name = "Blizzard Ring" },
  { ID = 2641024, Name = "Blizzara Ring" },
  { ID = 2641025, Name = "Blizzaga Ring" },
  { ID = 2641026, Name = "Thunder Ring" },
  { ID = 2641027, Name = "Thundara Ring" },
  { ID = 2641028, Name = "Thundaga Ring" },
  { ID = 2641029, Name = "Ability Stud" },
  { ID = 2641030, Name = "Guard Earring" },
  { ID = 2641031, Name = "Master Earring" },
  { ID = 2641032, Name = "Chaos Ring" },
  { ID = 2641033, Name = "Dark Ring" },
  { ID = 2641034, Name = "Element Ring" },
  { ID = 2641035, Name = "Three Stars" },
  { ID = 2641036, Name = "Power Chain" },
  { ID = 2641037, Name = "Golem Chain" },
  { ID = 2641038, Name = "Titan Chain" },
  { ID = 2641039, Name = "Energy Bangle" },
  { ID = 2641040, Name = "Angel Bangle" },
  { ID = 2641041, Name = "Gaia Bangle" },
  { ID = 2641042, Name = "Magic Armlet" },
  { ID = 2641043, Name = "Rune Armlet" },
  { ID = 2641044, Name = "Atlas Armlet" },
  { ID = 2641045, Name = "Heartguard" },
  { ID = 2641046, Name = "Ribbon" },
  { ID = 2641047, Name = "Crystal Crown" },
  { ID = 2641048, Name = "Brave Warrior" },
  { ID = 2641049, Name = "Ifrit's Horn" },
  { ID = 2641050, Name = "Inferno Band" },
  { ID = 2641051, Name = "White Fang" },
  { ID = 2641052, Name = "Ray of Light" },
  { ID = 2641053, Name = "Holy Circlet" },
  { ID = 2641054, Name = "Raven's Claw" },
  { ID = 2641055, Name = "Omega Arts" },
  { ID = 2641056, Name = "EXP Earring" },
  { ID = 2641057, Name = "A41" },
  { ID = 2641058, Name = "EXP Ring" },
  { ID = 2641059, Name = "EXP Bracelet" },
  { ID = 2641060, Name = "EXP Necklace" },
  { ID = 2641061, Name = "Firagun Band" },
  { ID = 2641062, Name = "Blizzagun Band" },
  { ID = 2641063, Name = "Thundagun Band" },
  { ID = 2641064, Name = "Ifrit Belt" },
  { ID = 2641065, Name = "Shiva Belt" },
  { ID = 2641066, Name = "Ramuh Belt" },
  { ID = 2641067, Name = "Moogle Badge" },
  { ID = 2641068, Name = "Cosmic Arts" },
  { ID = 2641069, Name = "Royal Crown" },
  { ID = 2641070, Name = "Prime Cap" },
  { ID = 2641071, Name = "Obsidian Ring" },
  { ID = 2641072, Name = "A56" },
  { ID = 2641073, Name = "A57" },
  { ID = 2641074, Name = "A58" },
  { ID = 2641075, Name = "A59" },
  { ID = 2641076, Name = "A60" },
  { ID = 2641077, Name = "A61" },
  { ID = 2641078, Name = "A62" },
  { ID = 2641079, Name = "A63" },
  { ID = 2641080, Name = "A64" },
  { ID = 2641081, Name = "Kingdom Key" },
  { ID = 2641082, Name = "Dream Sword" },
  { ID = 2641083, Name = "Dream Shield" },
  { ID = 2641084, Name = "Dream Rod" },
  { ID = 2641085, Name = "Wooden Sword" },
  { ID = 2641086, Name = "Jungle King" ,            Usefulness = item_usefulness.progression },
  { ID = 2641087, Name = "Three Wishes",            Usefulness = item_usefulness.progression },
  { ID = 2641088, Name = "Fairy Harp",              Usefulness = item_usefulness.progression },
  { ID = 2641089, Name = "Pumpkinhead",             Usefulness = item_usefulness.progression },
  { ID = 2641090, Name = "Crabclaw"},
  { ID = 2641091, Name = "Divine Rose",             Usefulness = item_usefulness.progression },
  { ID = 2641092, Name = "Spellbinder" },
  { ID = 2641093, Name = "Olympia",                 Usefulness = item_usefulness.progression },
  { ID = 2641094, Name = "Lionheart",               Usefulness = item_usefulness.progression },
  { ID = 2641095, Name = "Metal Chocobo" },
  { ID = 2641096, Name = "Oathkeeper",              Usefulness = item_usefulness.progression },
  { ID = 2641097, Name = "Oblivion",                Usefulness = item_usefulness.progression },
  { ID = 2641098, Name = "Lady Luck",               Usefulness = item_usefulness.progression },
  { ID = 2641099, Name = "Wishing Star",            Usefulness = item_usefulness.progression },
  { ID = 2641100, Name = "Ultima Weapon" },
  { ID = 2641101, Name = "Diamond Dust" },
  { ID = 2641102, Name = "One-Winged Angel" },
  { ID = 2641103, Name = "Mage's Staff" },
  { ID = 2641104, Name = "Morning Star" },
  { ID = 2641105, Name = "Shooting Star" },
  { ID = 2641106, Name = "Magus Staff" },
  { ID = 2641107, Name = "Wisdom Staff" },
  { ID = 2641108, Name = "Warhammer" },
  { ID = 2641109, Name = "Silver Mallet" },
  { ID = 2641110, Name = "Grand Mallet" },
  { ID = 2641111, Name = "Lord Fortune" },
  { ID = 2641112, Name = "Violetta" },
  { ID = 2641113, Name = "Dream Rod (Donald)" },
  { ID = 2641114, Name = "Save the Queen" },
  { ID = 2641115, Name = "Wizard's Relic" },
  { ID = 2641116, Name = "Meteor Strike" },
  { ID = 2641117, Name = "Fantasista" },
  { ID = 2641118, Name = "Unused (Donald)" },
  { ID = 2641119, Name = "Knight's Shield" },
  { ID = 2641120, Name = "Mythril Shield" },
  { ID = 2641121, Name = "Onyx Shield" },
  { ID = 2641122, Name = "Stout Shield" },
  { ID = 2641123, Name = "Golem Shield" },
  { ID = 2641124, Name = "Adamant Shield" },
  { ID = 2641125, Name = "Smasher" },
  { ID = 2641126, Name = "Gigas Fist" },
  { ID = 2641127, Name = "Genji Shield" },
  { ID = 2641128, Name = "Herc's Shield" },
  { ID = 2641129, Name = "Dream Shield (Goofy)" },
  { ID = 2641130, Name = "Save the King" },
  { ID = 2641131, Name = "Defender" },
  { ID = 2641132, Name = "Mighty Shield" },
  { ID = 2641133, Name = "Seven Elements" },
  { ID = 2641134, Name = "Unused (Goofy)" },
  { ID = 2641135, Name = "Spear" },
  { ID = 2641136, Name = "No Weapon" },
  { ID = 2641137, Name = "Genie" },
  { ID = 2641138, Name = "No Weapon" },
  { ID = 2641139, Name = "No Weapon" },
  { ID = 2641140, Name = "Tinker Bell" },
  { ID = 2641141, Name = "Claws" },
  { ID = 2641142, Name = "Tent" },
  { ID = 2641143, Name = "Camping Set" },
  { ID = 2641144, Name = "Cottage" },
  { ID = 2641145, Name = "C04" },
  { ID = 2641146, Name = "C05" },
  { ID = 2641147, Name = "C06" },
  { ID = 2641148, Name = "C07" },
  { ID = 2641149, Name = "Wonderland",              Usefulness = item_usefulness.progression },
  { ID = 2641150, Name = "Olympus Coliseum",        Usefulness = item_usefulness.progression },
  { ID = 2641151, Name = "Deep Jungle",             Usefulness = item_usefulness.progression },
  { ID = 2641152, Name = "Power Up" },
  { ID = 2641153, Name = "Defense Up" },
  { ID = 2641154, Name = "AP Up" },
  { ID = 2641155, Name = "Agrabah",                 Usefulness = item_usefulness.progression },
  { ID = 2641156, Name = "Monstro",                 Usefulness = item_usefulness.progression },
  { ID = 2641157, Name = "Atlantica",               Usefulness = item_usefulness.progression },
  { ID = 2641158, Name = "Fire Arts" ,              Usefulness = item_usefulness.progression },
  { ID = 2641159, Name = "Blizzard Arts" ,          Usefulness = item_usefulness.progression },
  { ID = 2641160, Name = "Thunder Arts" ,           Usefulness = item_usefulness.progression },
  { ID = 2641161, Name = "Cure Arts" ,              Usefulness = item_usefulness.progression },
  { ID = 2641162, Name = "Gravity Arts" ,           Usefulness = item_usefulness.progression },
  { ID = 2641163, Name = "Stop Arts" ,              Usefulness = item_usefulness.progression },
  { ID = 2641164, Name = "Aero Arts" ,              Usefulness = item_usefulness.progression },
  { ID = 2641165, Name = "Neverland" ,              Usefulness = item_usefulness.progression },
  { ID = 2641166, Name = "Halloween Town",          Usefulness = item_usefulness.progression },
  { ID = 2641167, Name = "Puppy",                   Usefulness = item_usefulness.progression },
  { ID = 2641168, Name = "Hollow Bastion",          Usefulness = item_usefulness.progression },
  { ID = 2641169, Name = "End of the World",        Usefulness = item_usefulness.progression },
  { ID = 2641170, Name = "Blue Trinity",            Usefulness = item_usefulness.progression },
  { ID = 2641171, Name = "Red Trinity",             Usefulness = item_usefulness.progression },
  { ID = 2641172, Name = "Green Trinity",           Usefulness = item_usefulness.progression },
  { ID = 2641173, Name = "Yellow Trinity",          Usefulness = item_usefulness.progression },
  { ID = 2641174, Name = "White Trinity",           Usefulness = item_usefulness.progression },
  { ID = 2641175, Name = "Progressive Fire",        Usefulness = item_usefulness.progression },
  { ID = 2641176, Name = "Progressive Blizzard",    Usefulness = item_usefulness.progression },
  { ID = 2641177, Name = "Progressive Thunder",     Usefulness = item_usefulness.progression },
  { ID = 2641178, Name = "Progressive Cure" ,       Usefulness = item_usefulness.progression },
  { ID = 2641179, Name = "Progressive Gravity" ,    Usefulness = item_usefulness.progression },
  { ID = 2641180, Name = "Progressive Stop" ,       Usefulness = item_usefulness.progression },
  { ID = 2641181, Name = "Progressive Aero" ,       Usefulness = item_usefulness.progression },
  { ID = 2641182, Name = "Phil Cup" ,               Usefulness = item_usefulness.progression },
  { ID = 2641183, Name = "Theon Vol. 6" ,           Usefulness = item_usefulness.progression },
  { ID = 2641184, Name = "Pegasus Cup",             Usefulness = item_usefulness.progression },
  { ID = 2641185, Name = "Hercules Cup",            Usefulness = item_usefulness.progression },
  { ID = 2641186, Name = "Empty Bottle" ,           Usefulness = item_usefulness.progression },
  { ID = 2641187, Name = "Old Book" ,               Usefulness = item_usefulness.progression },
  { ID = 2641188, Name = "Emblem Piece (Flame)",    Usefulness = item_usefulness.progression },
  { ID = 2641189, Name = "Emblem Piece (Chest)",    Usefulness = item_usefulness.progression },
  { ID = 2641190, Name = "Emblem Piece (Statue)",   Usefulness = item_usefulness.progression },
  { ID = 2641191, Name = "Emblem Piece (Fountain)", Usefulness = item_usefulness.progression },
  { ID = 2641192, Name = "Log" },
  { ID = 2641193, Name = "Cloth" },
  { ID = 2641194, Name = "Rope" },
  { ID = 2641195, Name = "Seagull Egg" },
  { ID = 2641196, Name = "Fish" },
  { ID = 2641197, Name = "Mushroom" },
  { ID = 2641198, Name = "Coconut" },
  { ID = 2641199, Name = "Drinking Water" },
  { ID = 2641200, Name = "Navi-G Piece 1" },
  { ID = 2641201, Name = "Navi-G Piece 2" },
  { ID = 2641202, Name = "Navi-Gummi Unused" },
  { ID = 2641203, Name = "Navi-G Piece 3" },
  { ID = 2641204, Name = "Navi-G Piece 4" },
  { ID = 2641205, Name = "Navi-Gummi" },
  { ID = 2641206, Name = "Watergleam" ,             Usefulness = item_usefulness.progression },
  { ID = 2641207, Name = "Naturespark" ,            Usefulness = item_usefulness.progression },
  { ID = 2641208, Name = "Fireglow",                Usefulness = item_usefulness.progression },
  { ID = 2641209, Name = "Earthshine" },
  { ID = 2641210, Name = "Crystal Trident",         Usefulness = item_usefulness.progression },
  { ID = 2641211, Name = "Postcard",                Usefulness = item_usefulness.progression },
  { ID = 2641212, Name = "Torn Page" ,              Usefulness = item_usefulness.progression },
  { ID = 2641213, Name = "Torn Page" ,              Usefulness = item_usefulness.progression },
  { ID = 2641214, Name = "Torn Page" ,              Usefulness = item_usefulness.progression },
  { ID = 2641215, Name = "Torn Page" ,              Usefulness = item_usefulness.progression },
  { ID = 2641216, Name = "Torn Page" ,              Usefulness = item_usefulness.progression },
  { ID = 2641217, Name = "Slides",                  Usefulness = item_usefulness.progression },
  { ID = 2641218, Name = "Slide 2" },
  { ID = 2641219, Name = "Slide 3" },
  { ID = 2641220, Name = "Slide 4" },
  { ID = 2641221, Name = "Slide 5" },
  { ID = 2641222, Name = "Slide 6" },
  { ID = 2641223, Name = "Footprints",              Usefulness = item_usefulness.progression },
  { ID = 2641224, Name = "Claw Marks" },
  { ID = 2641225, Name = "Stench" },
  { ID = 2641226, Name = "Antenna" },
  { ID = 2641227, Name = "Forget-Me-Not",           Usefulness = item_usefulness.progression },
  { ID = 2641228, Name = "Jack-In-The-Box",         Usefulness = item_usefulness.progression },
  { ID = 2641229, Name = "Entry Pass",              Usefulness = item_usefulness.progression },
  { ID = 2641230, Name = "AP Item" },
  { ID = 2641231, Name = "Dumbo",                   Usefulness = item_usefulness.progression },
  { ID = 2641232, Name = "N41" },
  { ID = 2641233, Name = "Bambi",                   Usefulness = item_usefulness.progression },
  { ID = 2641234, Name = "Genie",                   Usefulness = item_usefulness.progression },
  { ID = 2641235, Name = "Tinkerbell",              Usefulness = item_usefulness.progression },
  { ID = 2641236, Name = "Mushu",                   Usefulness = item_usefulness.progression },
  { ID = 2641237, Name = "Simba",                   Usefulness = item_usefulness.progression },
  { ID = 2641238, Name = "Lucky Emblem",            Usefulness = item_usefulness.progression },
  { ID = 2641239, Name = "Power Gem" },
  { ID = 2641240, Name = "Power Crystal" },
  { ID = 2641241, Name = "Blaze Shard" },
  { ID = 2641242, Name = "Blaze Gem" },
  { ID = 2641243, Name = "Frost Shard" },
  { ID = 2641244, Name = "Frost Gem" },
  { ID = 2641245, Name = "Thunder Shard" },
  { ID = 2641246, Name = "Thunder Gem" },
  { ID = 2641247, Name = "Shiny Crystal" },
  { ID = 2641248, Name = "Bright Shard" },
  { ID = 2641249, Name = "Bright Gem" },
  { ID = 2641250, Name = "Bright Crystal" },
  { ID = 2641251, Name = "Mystery Goo" },
  { ID = 2641252, Name = "Gale" },
  { ID = 2641253, Name = "Mythril Shard" },
  { ID = 2641254, Name = "Mythril",                 Usefulness = item_usefulness.progression },
  { ID = 2641255, Name = "Orichalcum",              Usefulness = item_usefulness.progression },
  { ID = 2642001, Name = "High Jump",               Usefulness = item_usefulness.progression },
  { ID = 2642002, Name = "Mermaid Kick",            Usefulness = item_usefulness.progression },
  { ID = 2642003, Name = "Progressive Glide",       Usefulness = item_usefulness.progression },
  { ID = 2642004, Name = "Superglide",              Usefulness = item_usefulness.progression },
  { ID = 2643005, Name = "Treasure Magnet" },
  { ID = 2643006, Name = "Combo Plus" },
  { ID = 2643007, Name = "Air Combo Plus" },
  { ID = 2643008, Name = "Critical Plus" },
  { ID = 2643009, Name = "Second Wind" },
  { ID = 2643010, Name = "Scan" },
  { ID = 2643011, Name = "Sonic Blade" },
  { ID = 2643012, Name = "Ars Arcanum" },
  { ID = 2643013, Name = "Strike Raid" },
  { ID = 2643014, Name = "Ragnarok" },
  { ID = 2643015, Name = "Trinity Limit" },
  { ID = 2643016, Name = "Cheer" },
  { ID = 2643017, Name = "Vortex" },
  { ID = 2643018, Name = "Aerial Sweep" },
  { ID = 2643019, Name = "Counterattack" },
  { ID = 2643020, Name = "Blitz" },
  { ID = 2643021, Name = "Guard" ,                  Usefulness = item_usefulness.progression },
  { ID = 2643022, Name = "Dodge Roll" ,             Usefulness = item_usefulness.progression },
  { ID = 2643023, Name = "MP Haste" },
  { ID = 2643024, Name = "MP Rage",                 Usefulness = item_usefulness.progression },
  { ID = 2643025, Name = "Second Chance",           Usefulness = item_usefulness.progression },
  { ID = 2643026, Name = "Berserk" },
  { ID = 2643027, Name = "Jackpot" },
  { ID = 2643028, Name = "Lucky Strike" },
  { ID = 2643029, Name = "Charge" },
  { ID = 2643030, Name = "Rocket" },
  { ID = 2643031, Name = "Tornado" },
  { ID = 2643032, Name = "MP Gift" },
  { ID = 2643033, Name = "Raging Boar" },
  { ID = 2643034, Name = "Asp's Bite" },
  { ID = 2643035, Name = "Healing Herb" },
  { ID = 2643036, Name = "Wind Armor" },
  { ID = 2643037, Name = "Crescent" },
  { ID = 2643038, Name = "Sandstorm" },
  { ID = 2643039, Name = "Applause!" },
  { ID = 2643040, Name = "Blazing Fury" },
  { ID = 2643041, Name = "Icy Terror" },
  { ID = 2643042, Name = "Bolts of Sorrow" },
  { ID = 2643043, Name = "Ghostly Scream" },
  { ID = 2643044, Name = "Humming Bird" },
  { ID = 2643045, Name = "Time-Out" },
  { ID = 2643046, Name = "Storm's Eye" },
  { ID = 2643047, Name = "Ferocious Lunge" },
  { ID = 2643048, Name = "Furious Bellow" },
  { ID = 2643049, Name = "Spiral Wave" },
  { ID = 2643050, Name = "Thunder Potion" },
  { ID = 2643051, Name = "Cure Potion" },
  { ID = 2643052, Name = "Aero Potion" },
  { ID = 2643053, Name = "Slapshot" },
  { ID = 2643054, Name = "Sliding Dash" },
  { ID = 2643055, Name = "Hurricane Blast" },
  { ID = 2643056, Name = "Ripple Drive" },
  { ID = 2643057, Name = "Stun Impact" },
  { ID = 2643058, Name = "Gravity Break" },
  { ID = 2643059, Name = "Zantetsuken" },
  { ID = 2643060, Name = "Tech Boost" },
  { ID = 2643061, Name = "Encounter Plus" },
  { ID = 2643062, Name = "Leaf Bracer",             Usefulness = item_usefulness.progression },
  { ID = 2643063, Name = "Evolution" },
  { ID = 2643064, Name = "EXP Zero" },
  { ID = 2643065, Name = "Combo Master",            Usefulness = item_usefulness.progression },
  { ID = 2644001, Name = "Max HP Increase" },
  { ID = 2644002, Name = "Max MP Increase" },
  { ID = 2644003, Name = "Max AP Increase" },
  { ID = 2644004, Name = "Strength Increase" },
  { ID = 2644005, Name = "Defense Increase" },
  { ID = 2644006, Name = "Accessory Slot Increase" },
  { ID = 2644007, Name = "Item Slot Increase" },
}
    return items
end

local items = define_items()

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

function read_soras_stats_array()
    --[[Reads an array of Sora's stats]]
    soras_stats_address         = {0x2DE9D66, 0x2DE9366}
    sora_hp_offset              = 0x0
    sora_mp_offset              = 0x2
    sora_ap_offset              = 0x3
    sora_strength_offset        = 0x4
    sora_defense_offset         = 0x5
    sora_accessory_slots_offset = 0x16
    sora_item_slots_offset      = 0x1F
    return {ReadByte(soras_stats_address[game_version] + sora_hp_offset)
          , ReadByte(soras_stats_address[game_version] + sora_mp_offset)
          , ReadByte(soras_stats_address[game_version] + sora_ap_offset)
          , ReadByte(soras_stats_address[game_version] + sora_strength_offset)
          , ReadByte(soras_stats_address[game_version] + sora_defense_offset)
          , ReadByte(soras_stats_address[game_version] + sora_accessory_slots_offset)
          , ReadByte(soras_stats_address[game_version] + sora_item_slots_offset)}
end

function write_soras_stats(soras_stats_array)
    --[[Writes Sora's calculated stats back to memory]]
    soras_stats_address         = {0x2DE9D66, 0x2DE9366}
    sora_hp_offset              = 0x00
    sora_mp_offset              = 0x02
    sora_ap_offset              = 0x03
    sora_strength_offset        = 0x04
    sora_defense_offset         = 0x05
    sora_accessory_slots_offset = 0x16
    sora_item_slots_offset      = 0x1F
    WriteByte(soras_stats_address[game_version] + sora_hp_offset              , soras_stats_array[1])
    WriteByte(soras_stats_address[game_version] + sora_mp_offset              , soras_stats_array[2])
    WriteByte(soras_stats_address[game_version] + sora_ap_offset              , soras_stats_array[3])
    WriteByte(soras_stats_address[game_version] + sora_strength_offset        , soras_stats_array[4])
    WriteByte(soras_stats_address[game_version] + sora_defense_offset         , soras_stats_array[5])
    WriteByte(soras_stats_address[game_version] + sora_accessory_slots_offset , soras_stats_array[6])
    WriteByte(soras_stats_address[game_version] + sora_item_slots_offset      , soras_stats_array[7])
end

function write_item(item_offset)
    --[[Grants the players a specific item defined by the offset]]
    stock_address = {0x2DEA1F9, 0x2DE97F9}
    WriteByte(stock_address[game_version] + item_offset, math.min(ReadByte(stock_address[game_version] + item_offset) + 1, 99))
end

function add_to_soras_stats(value)
    --[[Calculates sora's stats by incrementing the stat based on the stat_increases array]]
    stat_increases = {3, 1, 2, 2, 2, 1, 1}
    soras_stats_array = read_soras_stats_array()
    soras_stats_array[value] = soras_stats_array[value] + stat_increases[value]
    write_soras_stats(soras_stats_array)
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
        if not initializing and read_world() ~= 0 then
            local item = get_item_by_id(received_item_id) or { Name = "UNKNOWN ITEM", ID = -1}
            table.insert(message_cache.items, item)
        end
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
        elseif received_item_id >= 2644000 and received_item_id < 2645000 then
            add_to_soras_stats(received_item_id % 2644000)
        end
        i = i + 1
    end
    initializing = false
    write_check_number(i - 1)
end

--MESSAGE HANDLING BLOCK BY KRUJO--

function receive_sent_msgs()
    --[[Written by Krujo.  Handles the messages coming directly from the server for 
    messages involving sending items to other players]]
    local filename = client_communication_path .. "sent"
    if file_exists(filename) then
        local lines = {}
        local file = io.open(filename, "r")
        local line = file:read("*line")
        while line do
            table.insert(lines, line)
            line = file:read("*line")
        end
        file:close()
        if message_cache.locationID ~= lines[4] then --If the last sent prompt we parsed does not share a location id with this prompt we're reading
            table.insert(message_cache.sent, lines)
            message_cache.locationID = lines[4]
        end
    end
end

function GetKHSCII(INPUT)
    local _charTable = {
        [' '] =  0x01,
        ['\n'] =  0x02,
        ['-'] =  0x6E,
        ['!'] =  0x5F,
        ['?'] =  0x60,
        ['%'] =  0x62,
        ['/'] =  0x66,
        ['.'] =  0x68,
        [','] =  0x69,
        [';'] =  0x6C,
        [':'] =  0x6B,
        ['\''] =  0x71,
        ['('] =  0x74,
        [')'] =  0x75,
        ['['] =  0x76,
        [']'] =  0x77,
        ['¡'] =  0xCA,
        ['¿'] =  0xCB,
        ['À'] =  0xCC,
        ['Á'] =  0xCD,
        ['Â'] =  0xCE,
        ['Ä'] =  0xCF,
        ['Ç'] =  0xD0,
        ['È'] =  0xD1,
        ['É'] =  0xD2,
        ['Ê'] =  0xD3,
        ['Ë'] =  0xD4,
        ['Ì'] =  0xD5,
        ['Í'] =  0xD6,
        ['Î'] =  0xD7,
        ['Ï'] =  0xD8,
        ['Ñ'] =  0xD9,
        ['Ò'] =  0xDA,
        ['Ó'] =  0xDB,
        ['Ô'] =  0xDC,
        ['Ö'] =  0xDD,
        ['Ù'] =  0xDE,
        ['Ú'] =  0xDF,
        ['Û'] =  0xE0,
        ['Ü'] =  0xE1,
        ['ß'] =  0xE2,
        ['à'] =  0xE3,
        ['á'] =  0xE4,
        ['â'] =  0xE5,
        ['ä'] =  0xE6,
        ['ç'] =  0xE7,
        ['è'] =  0xE8,
        ['é'] =  0xE9,
        ['ê'] =  0xEA,
        ['ë'] =  0xEB,
        ['ì'] =  0xEC,
        ['í'] =  0xED,
        ['î'] =  0xEE,
        ['ï'] =  0xEF,
        ['ñ'] =  0xF0,
        ['ò'] =  0xF1,
        ['ó'] =  0xF2,
        ['ô'] =  0xF3,
        ['ö'] =  0xF4,
        ['ù'] =  0xF5,
        ['ú'] =  0xF6,
        ['û'] =  0xF7,
        ['ü'] =  0xF8
    }

    local _returnArray = {}

    local i = 1
    local z = 1

    while z <= #INPUT do
        local _char = INPUT:sub(z, z)

        if _char >= 'a' and _char <= 'z' then
            _returnArray[i] = string.byte(_char) - 0x1C
            z = z + 1
        elseif _char >= 'A' and _char <= 'Z' then
            _returnArray[i] = string.byte(_char) - 0x16
            z = z + 1
        elseif _char >= '0' and _char <= '9' then
            _returnArray[i] = string.byte(_char) - 0x0F
            z = z + 1
        elseif _char == '{' then
            local _str =
            {
                INPUT:sub(z + 1, z + 1),
                INPUT:sub(z + 2, z + 2),
                INPUT:sub(z + 3, z + 3),
                INPUT:sub(z + 4, z + 4),
                INPUT:sub(z + 5, z + 5)
            }

            if _str[1] == '0' and _str[2] == 'x' and _str[5] == '}' then

                local _s = _str[3] .. _str[4]

                _returnArray[i] = tonumber(_s, 16)
                z = z + 6
            end
        else
            if _charTable[_char] ~= nil then
                _returnArray[i] = _charTable[_char]
                z = z + 1
            else
                _returnArray[i] = 0x01
                z = z + 1
            end
        end

        i = i + 1
    end

    table.insert(_returnArray, 0x00)
    return _returnArray
end

function usefulness_to_colour(usefulness)
    --Written by Krujo.  Gets color values for a particular
    --defined usefulness
    if usefulness == item_usefulness.useless then
        return prompt_colours.green_mint
    elseif usefulness == item_usefulness.normal then
        return prompt_colours.red_sora
    elseif usefulness == item_usefulness.progression then
        return prompt_colours.purple_evil
    elseif usefulness == item_usefulness.special then
        return prompt_colours.red_rose
    elseif usefulness == item_usefulness.trap then
        return prompt_colours.red_trap
    end
end

function show_prompt_for_item(item)
    --[[Written by Krujo.  Wrapper for show_prompt.  Pulls output
    color information and formats text accordingly.]]
    local text_1 = ""
    local text_2 = { { item.Name } }
    local category = item_categories.consumables;
    local smallId = item.ID - 2640000
    if smallId > 1000 and smallId < 1009 then
        category = item_categories.consumable
    elseif smallId > 1008 and smallId < 1017 then
        category = item_categories.synthesis
    elseif smallId > 1016 and smallId < 1136 then
        category = item_categories.equipment
    elseif smallId > 2000 and smallId < 4001 then
        if smallId > 2100 and smallId < 2400 then
            category = item_categories.unlock
        else
            category = item_categories.ability
        end
    elseif smallId > 4000 and smallId < 5000 then
        category = item_categories.statsUp
    elseif smallId > 5000 and smallId < 6000 then
        category = item_categories.summon
    elseif smallId > 6000 and smallId < 7000 then
        category = item_categories.magic
    elseif smallId > 8000 and smallId < 9000 then
        category = item_categories.trinity
    elseif smallId > 5000 and smallId < 6000 then
        category = item_categories.summon
    elseif smallId > 7000 and smallId < 10000 then
        category = item_categories.unlock
    end
    local catUsefulness = item_usefulness.useless
    if category == item_categories.consumable then
        text_1 = "Consumable"
        catUsefulness = item_usefulness.useless
    elseif category == item_categories.synthesis then
        text_1 = "Synthesis"
        catUsefulness = item_usefulness.useless
    elseif category == item_categories.equipment then
        text_1 = "Equipment"
        catUsefulness = item_usefulness.normal
    elseif category == item_categories.ability then
        text_1 = "Ability"
        catUsefulness = item_usefulness.normal
    elseif category == item_categories.statsUp then
        text_1 = "Stat Up"
        catUsefulness = item_usefulness.normal
    elseif category == item_categories.summon then
        text_1 = "Summon"
        catUsefulness = item_usefulness.normal
    elseif category == item_categories.magic then
        text_1 = "Magic"
        catUsefulness = item_usefulness.normal
    elseif category == item_categories.trinity then
        text_1 = "Trinity"
        catUsefulness = item_usefulness.progression
    elseif category == item_categories.unlock then
        text_1 = "Unlock"
        catUsefulness = item_usefulness.progression
    end
    local colour = prompt_colours.red_sora;
    if item.Usefulness == nil then
        item.Usefulness = catUsefulness
    end
    colour = usefulness_to_colour(item.Usefulness)
    show_prompt({ text_1 }, text_2, null, colour)
end

function show_prompt(input_title, input_party, duration, colour)
    --[[Writes to memory the message to be displayed in a Level Up prompt.]]
    if colour == nil then
        colour = prompt_colours.red_sora
    end
    local _boxMemory = {0x283BD90, 0x283B390} --changed for EGS 1.0.0.10
    local _textMemory = {0x2DC3068, 0x2DC2668} --changed for EGS 1.0.0.10

    local _partyOffset = 0x3A20

    for i = 1, #input_title do
        if input_title[i] then
            WriteArray(_textMemory[game_version] + 0x20 * (i - 1), GetKHSCII(input_title[i]))
        end
    end

    for z = 1, 3 do
        local _boxArray = input_party[z];
        
        color_box_address = {0x528710, 0x527A10}
        color_text_address = {0x528750, 0x527A50}
        
        local _colorBox  = color_box_address[game_version] + colour
        local _colorText = color_text_address[game_version] + colour

        if _boxArray then
            local _textAddress = (_textMemory[game_version] + 0x70) + (0x140 * (z - 1)) + (0x40 * 0)
            local _boxAddress = _boxMemory[game_version] + (_partyOffset * (z - 1)) + (0xBA0 * 0)

            -- Write the box count.
            WriteInt(_boxMemory[game_version] - 0x10 + 0x04 * (z - 1), 1)

            -- Write the Title Pointer.
            WriteLong(_boxAddress + 0x30, BASE_ADDR  + _textMemory[game_version] + 0x20 * (z - 1))

            if _boxArray[2] then
                -- String Count is 2.
                WriteInt(_boxAddress + 0x18, 0x02)

                -- Second Line Text.
                WriteArray(_textAddress + 0x20, GetKHSCII(_boxArray[2]))
                WriteLong(_boxAddress + 0x28, BASE_ADDR  + _textAddress + 0x20)
            else
                -- String Count is 1
                WriteInt(_boxAddress + 0x18, 0x01)
            end

            -- First Line Text
            WriteArray(_textAddress, GetKHSCII(_boxArray[1]))
            WriteLong(_boxAddress + 0x20, BASE_ADDR  + _textAddress)

            -- Reset box timers.
            WriteInt(_boxAddress + 0x0C, duration)
            WriteFloat(_boxAddress + 0xB80, 1)

            -- Set box colors.
            WriteLong(_boxAddress + 0xB88, BASE_ADDR  + _colorBox)
            WriteLong(_boxAddress + 0xB90, BASE_ADDR  + _colorText)

            -- Show the box.
            WriteInt(_boxAddress, 0x01)
        end
    end
end

function handle_messages()
    --[[Written by Krujo.  Handles received messages in a queue system,
    sending 1 message in the message_cache every main() iteration and removing
    it from the cache.]]
    local msg = message_cache.items[1]
    if msg ~= nil then
        show_prompt_for_item(msg)
        table.remove(message_cache.items, 1)
        return
    end
    msg = message_cache.sent[1]
    if msg ~= nil then
        table.remove(message_cache.sent, 1)
        local info = {
            item = msg[1],
            reciver = msg[2],
            usefulness = math.tointeger(msg[3]),
        }
        --Link's Ocarina
        local item_msg = tostring(info.reciver);
        if (string.sub(item_msg, -1) == 's') then
            item_msg = item_msg .. "'"
        else
            item_msg = item_msg .. "'s"
        end
        item_msg = item_msg .. ' ' .. info.item
        local usefulness;
        if info.usefulness == 0 then
            usefulness = item_usefulness.useless
        elseif info.usefulness == 1 then
            usefulness = item_usefulness.progression
        elseif info.usefulness == 2 then
            usefulness = item_usefulness.normal
        elseif info.usefulness == 3 then
            usefulness = item_usefulness.trap
        end
        ConsolePrint('use multiwork ' .. info.usefulness)
        local colour = usefulness_to_colour(usefulness)
        show_prompt({ "Multiworld" }, { { item_msg } }, null, colour)
    end
end

--END MESSAGE HANDLING BLOCK BY KRUJO--

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
            receive_items()
            handle_messages()
        end
    end
end