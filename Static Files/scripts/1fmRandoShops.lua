LUAGUI_NAME = "1fmRandoShops"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Shops"

canExecute = false
shopsWritten = false

shop_addresses = {}

function fill_shop_addresses()
    table.insert(shop_addresses, 1, {0x4FF3C0,0x4FEE00}) --Item Shop Initial
    table.insert(shop_addresses, 2, {0x4FF494,0x4FEED4}) --Item Shop After Guard Armor
    table.insert(shop_addresses, 3, {0x4FF568,0x4FEFA8}) --Item Shop After Agrabah
    table.insert(shop_addresses, 4, {0x4FF63C,0x4FF07C}) --Item Shop After Riku Ansem
    table.insert(shop_addresses, 5, {0x4FF710,0x4FF150}) --Accessory Shop Initial
    table.insert(shop_addresses, 6, {0x4FF7E4,0x4FF224}) --Accessory Shop After Agrabah
    table.insert(shop_addresses, 7, {0x4FF8B8,0x4FF2F8}) --Accessory Shop After Riku Ansem
    table.insert(shop_addresses, 8, {0x4FF98C,0x4FF3CC}) --Agrabah Shop
end

function write_shops()
    for shop_index,address_base in pairs(shop_addresses) do
        WriteByte(address_base[game_version], 8) --Number of items in shop
        WriteByte(address_base[game_version] + 4, 1) --Potion
        WriteByte(address_base[game_version] + 8, 2) --Hi-Potion
        WriteByte(address_base[game_version] + 12, 3) --Ether
        WriteByte(address_base[game_version] + 16, 4) --Elixir
        WriteByte(address_base[game_version] + 20, 142) --Tent
        WriteByte(address_base[game_version] + 24, 143) --Camping Set
        WriteByte(address_base[game_version] + 28, 254) --Mythril
        WriteByte(address_base[game_version] + 32, 255) --Orichalcum
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
            fill_shop_addresses()
        end
        if ReadByte(IsSteamGLVersion) == 0xF0 then
            ConsolePrint("Steam Version Detected")
            game_version = 2
            canExecute = true
            fill_shop_addresses()
        end
    end
end

function _OnFrame()
    if canExecute then
        if not shopsWritten then
            write_shops()
            shopsWritten = true
        end
    end
end