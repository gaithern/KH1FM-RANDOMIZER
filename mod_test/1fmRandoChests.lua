-------------------------------------------
------ Kingdom Hearts 1 FM Randomizer -----
------              by Gicu           -----
-------------------------------------------

LUAGUI_NAME = "1fmRandoChests"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts 1FM Randomizer Chests"

canExecute = false
chests = {[0] = 16, [40] = 2800, [42] = 2976, [44] = 2672, [46] = 2464, [48] = 16, [50] = 2480, [52] = 2896, [54] = 2976, [58] = 2736, [60] = 2816, [62] = 2112, [64] = 3664, [66] = 2976, [68] = 560, [70] = 1136, [72] = 992, [80] = 2304, [176] = 128, [178] = 2672, [180] = 2672, [182] = 2272, [184] = 1440, [186] = 16, [188] = 3680, [190] = 3680, [192] = 112, [200] = 2816, [202] = 3680, [204] = 2672, [206] = 3680, [208] = 2272, [210] = 1712, [212] = 3376, [214] = 2432, [216] = 1408, [220] = 288, [222] = 3472, [224] = 112, [226] = 64, [228] = 96, [244] = 3680, [246] = 2304, [248] = 480, [250] = 112, [252] = 48, [256] = 2688, [258] = 688, [260] = 1088, [264] = 64, [266] = 3680, [268] = 1056, [270] = 2464, [272] = 2880, [274] = 960, [276] = 112, [278] = 2064, [280] = 2672, [282] = 2272, [284] = 1728, [334] = 16, [336] = 16, [338] = 16, [340] = 16, [394] = 2848, [396] = 2832, [398] = 384, [400] = 2672, [402] = 1472, [404] = 64, [406] = 1376, [408] = 2304, [410] = 3680, [412] = 2672, [414] = 2272, [416] = 2912, [418] = 2432, [420] = 64, [422] = 2592, [424] = 2128, [426] = 48, [428] = 2304, [430] = 1952, [432] = 48, [434] = 2656, [436] = 1456, [438] = 16, [440] = 3632, [442] = 2976, [444] = 1040, [446] = 848, [448] = 2832, [450] = 3376, [452] = 2672, [454] = 3376, [456] = 2672, [458] = 2432, [460] = 368, [462] = 16, [464] = 1024, [466] = 2672, [606] = 784, [608] = 3680, [610] = 3680, [612] = 3680, [614] = 2928, [616] = 672, [618] = 3680, [620] = 976, [622] = 112, [624] = 2848, [626] = 768, [628] = 2672, [630] = 624, [632] = 3680, [634] = 3680, [656] = 2288, [658] = 2304, [660] = 2752, [662] = 2672, [666] = 3376, [668] = 528, [670] = 2672, [672] = 2672, [674] = 2432, [676] = 2288, [484] = 496, [486] = 1424, [488] = 112, [490] = 1072, [694] = 48, [696] = 2864, [698] = 2432, [700] = 1616, [702] = 64, [710] = 1856, [712] = 3680, [724] = 96, [726] = 2288, [728] = 2608, [730] = 1664, [732] = 64, [746] = 2432, [748] = 1744, [750] = 3680, [752] = 3680, [1018] = 3680, [754] = 3680, [756] = 3680, [758] = 3808, [760] = 2464, [762] = 2672, [764] = 432, [766] = 2832, [806] = 2672, [808] = 2672, [810] = 3680, [812] = 352, [814] = 928, [816] = 1808, [818] = 2464, [820] = 2672, [822] = 1536, [824] = 2672, [826] = 1792, [828] = 3680, [830] = 2016, [832] = 2720, [834] = 2800, [836] = 3680, [838] = 64, [840] = 1936, [842] = 3808, [844] = 3680, [854] = 2288, [856] = 944, [858] = 2784, [860] = 1360, [862] = 3568, [864] = 2624, [866] = 720, [868] = 3680, [870] = 656, [872] = 2576, [874] = 48, [876] = 2816, [878] = 112, [894] = 336, [896] = 3808, [898] = 1920, [902] = 2896, [904] = 1104, [906] = 1824, [908] = 1584, [910] = 2880, [912] = 2960, [914] = 2672, [916] = 2432, [918] = 1488, [920] = 128, [922] = 1680, [924] = 3680, [926] = 3680, [928] = 400, [930] = 2976, [932] = 3376, [934] = 3680, [936] = 2672, [938] = 3808, [940] = 112, [942] = 2496, [944] = 896, [946] = 3680, [948] = 816, [950] = 128, [952] = 16, [954] = 16}
chests_written = false

function randomize_chests()
    chest_table_address = {0x529A60, 0x528D60}
    for offset,chest_short in pairs(chests) do
        WriteShort(chest_table_address[game_version] + offset, chest_short)
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
end

function _OnFrame()
    if chests[0] ~= nil and not chests_written then
        randomize_chests()
    end
end