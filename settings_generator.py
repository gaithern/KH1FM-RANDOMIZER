from gooey import Gooey,GooeyParser
import os

@Gooey(program_name='KH1 Randomizer Settings Generator',
        image_dir='./Images/',
        tabbed_groups=True,
        default_size=(720, 480),
        header_bg_color="#efcf78")
def main():
    parser = GooeyParser()
    goal_group = parser.add_argument_group("Goal",
        "Customize how the player can win the game.")
    locations_group = parser.add_argument_group("Locations",
        "Customize which locations can contain non filler items.")
    levels_group = parser.add_argument_group("Levels",
        "Customize what can be found on level ups.")
    keyblades_group = parser.add_argument_group("Keyblades",
        "Customize keyblade stats.")
    misc_group = parser.add_argument_group("Misc",
        "Customize other misc settings.")
    
    misc_group.add_argument('--slot_name',
        action="store",
        default="Player{number}",
        metavar = "Slot Name",
        help = "Defines what the slot name should be for hosting the game on Archipelago.  You can ignore this if you plan to play offline.")
    goal_group.add_argument('--final_rest_door_key',
        choices = ["Lucky Emblems",
            "Puppies",
            "Postcards",
            "Final Rest",
            "Sephiroth",
            "Unknown"],
        default = "Lucky Emblems",
        metavar = "Final Rest Door Key",
        help = "Determines where the key is which manifests the door in Final Rest.")
    goal_group.add_argument('--end_of_the_world_unlock',
        choices = ["Item",
            "Lucky Emblems"],
        default = "Lucky Emblems",
        metavar = "End of the World Unlock",
        help = "Determines how End of the World unlocks.")
    goal_group.add_argument('--required_lucky_emblems_for_end_of_the_world',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 13,
            'increment': 1},
        default = 7,
        metavar = "Required Lucky Emblems for End of the World",
        help = "If End of the World Unlock is set to Lucky Emblems, determines how many Lucky Emblems are required.")
    goal_group.add_argument('--required_lucky_emblems_for_final_rest_door',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 13,
            'increment': 1},
        default = 10,
        metavar = "Required Lucky Emblems for the Final Rest Door",
        help = "If Final Rest Door Key is set to Lucky Emblems, detmermines how many Lucky Emblems are required.")
    goal_group.add_argument('-lucky_emblems_in_item_pool',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 13,
            'increment': 1},
        default = 13,
        metavar = "Lucky Emblems in the item pool",
        help = "If either the Final Rest Door Key or End of the World Unlock are set to Lucky Emblems, determines how many Lucky Emblems are in the pool.")
    goal_group.add_argument('--required_postcards',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 10,
            'increment': 1},
        default = 8,
        metavar = "Required Postcards",
        help = "If Final Rest Door Key is set to Postcards, determines how many Postcards are required.")
    goal_group.add_argument('--required_puppies',
        choices = ["10",
            "20",
            "30",
            "40",
            "50",
            "60",
            "70",
            "80",
            "90",
            "99"],
        default = "80",
        metavar = "Required Puppies",
        help = "If Final Rest Door Key is set to Puppies, determines how many Puppies are required.")
    goal_group.add_argument('--destiny_islands',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Destiny Islands",
        help = "If on, Traverse Town will have an additional place to land - Seashore in Destiny Islands.  Destiny Islands items will be shuffled into the item pool.  Turning in all Destiny Islands items to Kairi sends the player to the final fights.")
    locations_group.add_argument('--super_bosses',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Super Bosses",
        help = "Determines if important items can be behind Super Bosses.")
    locations_group.add_argument('--atlantica',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Atlantica",
        help = "Determines if important items can be in Atlantica.")
    locations_group.add_argument('--cups',
        choices = ["Off",
            "No Hades Cup",
            "All Cups"],
        default = "Off",
        metavar = "Cups",
        help = "Determines which, if any, Olympus Coliseum cups hold important items.")
    locations_group.add_argument('--hundred_acre_wood',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "100 Acre Wood",
        help = "Determines if important items can be found in the 100 Acre Wood.")
    locations_group.add_argument('--jungle_slider',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Jungle Slider",
        help = "Determines if important items can be found in the Jungle Slider minigame.")
    locations_group.add_argument('--randomize_emblem_pieces',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Randomize Emblem Pieces",
        help = "Determines whether the Emblem Piece checks in Hollow Bastion are randomized.")
    locations_group.add_argument('--randomize_postcards',
        choices = ["All",
            "Chests",
            "None"],
        default = "All",
        metavar = "Randomize Postcards",
        help = "Determines if Postcards should be in their vanilla locations, all randomized, or if only the postcard that would appear in chests should be randomized."
        )
    levels_group.add_argument('--exp_multiplier',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 8,
            'increment': 1},
        default = 1,
        metavar = "EXP Multiplier",
        help = "Determines the amount of experience party members need to level up.")
    levels_group.add_argument('--level_checks',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 99,
            'increment': 1},
        default = 99,
        metavar = "Level Checks",
        help = "Determines the latest level for which rewards can be found.")
    levels_group.add_argument('--slot_2_level_checks',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 33,
            'increment': 1},
        default = 10,
        metavar = "Slot 2 Level Checks",
        help = "Determines the amount of secondary bonuses are found on levels.")
    levels_group.add_argument('--force_stats_and_abilities_on_levels',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 100,
            'increment': 1},
        default = 1,
        metavar = "Force Stats and Abilities on Levels Starting at Level",
        help = "Determines at which level can only stat increases or abilities can be found.")
    levels_group.add_argument('--strength_increases',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 100,
            'increment': 1},
        default = 24,
        metavar = "Strength Increases",
        help = "Determines how many strength increases are in the item pool.")
    levels_group.add_argument('--defense_increases',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 100,
            'increment': 1},
        default = 24,
        metavar = "Defense Increases",
        help = "Determines how many defense increases are in the item pool.")
    levels_group.add_argument('--hp_increases',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 100,
            'increment': 1},
        default = 23,
        metavar = "HP Increases",
        help = "Determines how many HP increases are in the item pool.")
    levels_group.add_argument('--ap_increases',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 100,
            'increment': 1},
        default = 18,
        metavar = "AP Increases",
        help = "Determines how many AP increases are in the item pool.")
    levels_group.add_argument('--mp_increases',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 20,
            'increment': 1},
        default = 7,
        metavar = "MP Increases",
        help = "Determines how many MP increases are in the item pool.")
    levels_group.add_argument('--accessory_slot_increases',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 6,
            'increment': 1},
        default = 1,
        metavar = "Accessory Slot Increases",
        help = "Determines how many accessory slot increases are in the item pool.")
    levels_group.add_argument('--item_slot_increases',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 5,
            'increment': 1},
        default = 3,
        metavar = "Item Slot Increases",
        help = "Determines how many item slot increases are in the item pool.")
    keyblades_group.add_argument('--keyblades_unlock_chests',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Keyblades Unlock Chests",
        help = "Determines if chests in worlds can only be opened if you have that world's corresponding keyblade.")
    keyblades_group.add_argument('--keyblade_stats',
        choices = ["Vanilla",
            "Randomize",
            "Shuffle"],
        default = "Shuffle",
        metavar = "Keyblade Stats",
        help = "Determines if keyblade stats be shuffled, randomized, or remain vanilla.")
    keyblades_group.add_argument('--bad_starting_weapons',
        choices = ["Yes",
            "No"],
        default = "Yes",
        metavar = "Bad Starting Weapons",
        help = "Determines if the Kingdom Key and Dream weapons should have vanilla stats.")
    keyblades_group.add_argument('--keyblade_max_strength',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 20,
            'increment': 1},
        default = 14,
        metavar = "Keyblade Max STR",
        help = "If keyblade stats are randomized, determines the max strength increase a keyblade can yield.")
    keyblades_group.add_argument('--keyblade_min_strength',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 20,
            'increment': 1},
        default = 3,
        metavar = "Keyblade Min STR",
        help = "If keyblade stats are randomized, determines the min strength increase a keyblade can yield.")
    keyblades_group.add_argument('--keyblade_max_crit_rate',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 200,
            'increment': 1},
        default = 200,
        metavar = "Keyblade Crit Rate",
        help = "If keyblade stats are randomized, determines the max crit rate a keyblade can yield.")
    keyblades_group.add_argument('--keyblade_min_crit_rate',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 200,
            'increment': 1},
        default = 0,
        metavar = "Keyblade Min Crit Rate",
        help = "If keyblade stats are randomized, determines the min crit rate a keyblade can yield.")
    keyblades_group.add_argument('--keyblade_max_crit_bonus',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 16,
            'increment': 1},
        default = 16,
        metavar = "Keyblade Max Crit Bonus",
        help = "If keyblade stats are randomized, determines the max crit bonus a keyblade can yield.")
    keyblades_group.add_argument('--keyblade_min_crit_bonus',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 16,
            'increment': 1},
        default = 0,
        metavar = "Keyblade Min Crit Bonus",
        help = "If keyblade stats are randomized, determines the min crit bonus a keyblade can yield.")
    keyblades_group.add_argument('--keyblade_max_recoil',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 90,
            'increment': 1},
        default = 90,
        metavar = "Keyblade Max Recoil",
        help = "If keyblade stats are randomized, determines the max recoil a keyblade can yield.")
    keyblades_group.add_argument('--keyblade_min_recoil',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 90,
            'increment': 1},
        default = 1,
        metavar = "Keyblade Min Recoil",
        help = "If keyblade stats are randomized, determines the min recoil a keyblade can yield.")
    keyblades_group.add_argument('--keyblade_max_mp',
        widget='Slider',
        gooey_options={'min': -2,
            'max': 5,
            'increment': 1},
        default = 3,
        metavar = "Keyblade Max MP",
        help = "If keyblade stats are randomized, determines the max MP bonus a keyblade can yield.")
    keyblades_group.add_argument('--keyblade_min_mp',
        widget='Slider',
        gooey_options={'min': -2,
            'max': 5,
            'increment': 1},
        default = -2,
        metavar = "Keyblade Min MP",
        help = "If keyblade stats are randomized, determines the min MP bonus a keyblade can yield.")
    misc_group.add_argument('--starting_worlds',
        widget='Slider',
        gooey_options={'min': 0,
            'max': 10,
            'increment': 1},
        default = 0,
        metavar = "Starting Worlds",
        help = "Determines the amount of worlds the player starts with in addition to Traverse Town.  These are given by the server, and are received after connection.")
    misc_group.add_argument('--starting_tools',
        choices = ["Yes",
            "No"],
        default = "Yes",
        metavar = "Starting Tools",
        help = "Determines if Sora starts with Scan and Dodge Roll.  These are given by the server, and are received after connection.")
    locations_group.add_argument('--randomize_puppies',
        choices = ["Yes",
            "No"],
        default = "Yes",
        metavar = "Randomize Puppies",
        help = "Determines if puppies are randomized.")
    locations_group.add_argument('--puppy_value',
        widget='Slider',
        gooey_options={'min': 1,
            'max': 99,
            'increment': 1},
        default = 3,
        metavar = "Puppy Value",
        help = "If puppies are randomized, determines how many puppies each \"Puppy\" item is worth.")
    misc_group.add_argument('--interact_in_battle',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Interact in Battle",
        help = "Determines if Sora can interact in battle.")
    misc_group.add_argument('--advanced_logic',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Advanced Logic",
        help = "Determines if the player is expected to do advanced tricks to reach certain locations.")
    misc_group.add_argument('--extra_shared_abilities',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Extra Shared Abilities",
        help = "Determines if the item pool contains additional shared abilities, which stack.  For example, more High Jumps make you jump higher, more Glides make you glide faster.")
    misc_group.add_argument('--exp_zero_in_pool',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "EXP Zero in Pool",
        help = "Determines if EXP Zero should be shuffled into the item pool.")
    misc_group.add_argument('--death_link',
        choices = ["Off",
            "Toggle",
            "On"],
        default = "Off",
        metavar = "Death Link",
        help = "If another player is KO'ed, so is Sora.  The opposite is also true.")
    misc_group.add_argument('--donald_death_link',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Donald Death Link",
        help = "If Donald is KO'ed, so is Sora.")
    misc_group.add_argument('--goofy_death_link',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Goofy Death Link",
        help = "If Goofy is KO'ed, so is Sora.")
    misc_group.add_argument('--remote_items',
        choices = ["Off",
            "Allow",
            "Full"],
        default = "Off",
        metavar = "Remote Items",
        help = "Determines if items can be placed on locations in your own world in such a way that will force them to be remote items.\n"\
                + "Off: When your items are placed in your world, they can only be placed in locations that they can be acquired without server connection (stats on levels, items in chests, etc).\n"\
                + "Allow: When your items are placed in your world, items that normally can't be placed in a location in-game are simply made remote (stats in chests, abilities on static events, etc).\n"\
                + "Full: All items are remote.  Use this when doing something like a co-op seed.")
    misc_group.add_argument('--shorten_go_mode',
        choices = ["Yes",
            "No"],
        default = "No",
        metavar = "Shorten Go Mode",
        help = "Determines if the player should be warped to the final cutscene after defeating Ansem 1 > Darkside > Ansem 2.")
    args = parser.parse_args()
    print(create_yaml(args))

def create_yaml(args):
    yaml_str = ""
    yaml_str = yaml_str + get_slot_name_line(args.slot_name)
    yaml_str = yaml_str + get_static_header()
    yaml_str = yaml_str + get_final_rest_door_key_line(args.final_rest_door_key)
    yaml_str = yaml_str + get_end_of_the_world_unlock_line(args.end_of_the_world_unlock)
    yaml_str = yaml_str + get_required_lucky_emblems_door_line(args.required_lucky_emblems_for_final_rest_door)
    yaml_str = yaml_str + get_required_lucky_emblems_eotw_line(args.required_lucky_emblems_for_end_of_the_world)
    yaml_str = yaml_str + get_lucky_emblems_in_pool_line(args.lucky_emblems_in_item_pool)
    yaml_str = yaml_str + get_required_postcards_line(args.required_postcards)
    yaml_str = yaml_str + get_required_puppies_line(args.required_puppies)
    yaml_str = yaml_str + get_destiny_islands_line(args.destiny_islands)
    yaml_str = yaml_str + get_super_bosses_line(args.super_bosses)
    yaml_str = yaml_str + get_atlantica_line(args.atlantica)
    yaml_str = yaml_str + get_cups_line(args.cups)
    yaml_str = yaml_str + get_hundred_acre_wood_line(args.hundred_acre_wood)
    yaml_str = yaml_str + get_jungle_slider_line(args.jungle_slider)
    yaml_str = yaml_str + get_randomize_emblem_pieces_line(args.randomize_emblem_pieces)
    yaml_str = yaml_str + get_randomize_postcards_line(args.randomize_postcards)
    yaml_str = yaml_str + get_exp_multiplier_line(args.exp_multiplier)
    yaml_str = yaml_str + get_level_checks_line(args.level_checks)
    yaml_str = yaml_str + get_slot_2_level_checks_line(args.slot_2_level_checks)
    yaml_str = yaml_str + get_force_stats_and_abilities_on_levels_line(args.force_stats_and_abilities_on_levels)
    yaml_str = yaml_str + get_strength_increase_line(args.strength_increases)
    yaml_str = yaml_str + get_defense_increase_line(args.defense_increases)
    yaml_str = yaml_str + get_hp_increase_line(args.hp_increases)
    yaml_str = yaml_str + get_ap_increase_line(args.ap_increases)
    yaml_str = yaml_str + get_mp_increase_line(args.mp_increases)
    yaml_str = yaml_str + get_accessory_slot_increase_line(args.accessory_slot_increases)
    yaml_str = yaml_str + get_item_slot_increase_line(args.item_slot_increases)
    yaml_str = yaml_str + get_keyblades_unlock_chests_line(args.keyblades_unlock_chests)
    yaml_str = yaml_str + get_keyblade_stats_line(args.keyblade_stats)
    yaml_str = yaml_str + get_bad_starting_weapons_line(args.bad_starting_weapons)
    yaml_str = yaml_str + get_keyblade_max_str_line(args.keyblade_max_strength)
    yaml_str = yaml_str + get_keyblade_min_str_line(args.keyblade_min_strength)
    yaml_str = yaml_str + get_keyblade_max_crit_rate_line(args.keyblade_max_crit_rate)
    yaml_str = yaml_str + get_keyblade_min_crit_rate_line(args.keyblade_min_crit_rate)
    yaml_str = yaml_str + get_keyblade_max_crit_bonus_line(args.keyblade_max_crit_bonus)
    yaml_str = yaml_str + get_keyblade_min_crit_bonus_line(args.keyblade_min_crit_bonus)
    yaml_str = yaml_str + get_keyblade_max_recoil_line(args.keyblade_max_recoil)
    yaml_str = yaml_str + get_keyblade_min_recoil_line(args.keyblade_min_recoil)
    yaml_str = yaml_str + get_keyblade_max_mp_line(args.keyblade_max_mp)
    yaml_str = yaml_str + get_keyblade_min_mp_line(args.keyblade_min_mp)
    yaml_str = yaml_str + get_starting_worlds_line(args.starting_worlds)
    yaml_str = yaml_str + get_starting_tools_line(args.starting_tools)
    yaml_str = yaml_str + get_randomize_puppies_line(args.randomize_puppies)
    yaml_str = yaml_str + get_puppy_value_line(args.puppy_value)
    yaml_str = yaml_str + get_interact_in_battle_line(args.interact_in_battle)
    yaml_str = yaml_str + get_advanced_logic_line(args.advanced_logic)
    yaml_str = yaml_str + get_extra_shared_abilities_line(args.extra_shared_abilities)
    yaml_str = yaml_str + get_exp_zero_in_pool_line(args.exp_zero_in_pool)
    yaml_str = yaml_str + get_death_link_line(args.death_link)
    yaml_str = yaml_str + get_donald_death_link_line(args.donald_death_link)
    yaml_str = yaml_str + get_goofy_death_link_line(args.goofy_death_link)
    yaml_str = yaml_str + get_remote_items_line(args.remote_items)
    yaml_str = yaml_str + get_shorten_go_mode_line(args.shorten_go_mode)
    output_yaml(yaml_str, args.slot_name)

def get_slot_name_line(slot_name):
    return "name: " + str(slot_name) + "\n"

def get_static_header():
    return "game: Kingdom Hearts\nKingdom Hearts:" + "\n"

def get_final_rest_door_key_line(final_rest_door_key):
    return "  final_rest_door_key: " + str(final_rest_door_key).replace(" ", "_").lower() + "\n"

def get_end_of_the_world_unlock_line(end_of_the_world_unlock):
    return "  end_of_the_world_unlock: " + str(end_of_the_world_unlock).replace(" ", "_").lower() + "\n"

def get_required_lucky_emblems_door_line(required_lucky_emblems_for_final_rest_door):
    return "  required_lucky_emblems_door: " + str(required_lucky_emblems_for_final_rest_door) + "\n"

def get_required_lucky_emblems_eotw_line(required_lucky_emblems_for_end_of_the_world):
    return "  required_lucky_emblems_eotw: " + str(required_lucky_emblems_for_end_of_the_world) + "\n"

def get_lucky_emblems_in_pool_line(lucky_emblems_in_item_pool):
    return "  lucky_emblems_in_pool: " + str(lucky_emblems_in_item_pool) + "\n"

def get_required_postcards_line(required_postcards):
    return "  required_postcards: " + str(required_postcards) + "\n"

def get_required_puppies_line(required_puppies):
    return "  required_puppies: " + str(required_puppies) + "\n"

def get_destiny_islands_line(destiny_islands):
    return "  destiny_islands: " + str(destiny_islands).replace("Yes", "true").replace("No", "false") + "\n"

def get_super_bosses_line(super_bosses):
    return "  super_bosses: " + str(super_bosses).replace("Yes", "true").replace("No", "false") + "\n"

def get_atlantica_line(atlantica):
    return "  atlantica: " + str(atlantica).replace("Yes", "true").replace("No", "false") + "\n"

def get_cups_line(cups):
    if cups == "All Cups":
        cups = "hades_cup"
    if cups == "No Hades Cup":
        cups = "cups"
    return "  cups: " + str(cups).replace(" ", "_").lower() + "\n"

def get_hundred_acre_wood_line(hundred_acre_wood):
    return "  hundred_acre_wood: " + str(hundred_acre_wood).replace("Yes", "true").replace("No", "false") + "\n"

def get_jungle_slider_line(jungle_slider):
    return "  jungle_slider: " + str(jungle_slider).replace("Yes", "true").replace("No", "false") + "\n"

def get_randomize_emblem_pieces_line(randomize_emblem_pieces):
    return "  randomize_emblem_pieces: " + str(randomize_emblem_pieces).replace("Yes", "true").replace("No", "false") + "\n"

def get_randomize_postcards_line(randomize_postcards):
    return "  randomize_postcards: " + str(randomize_postcards).replace(" ", "_").lower() + "\n"

def get_exp_multiplier_line(exp_multiplier):
    return "  exp_multiplier: " + str(int(exp_multiplier) * 16) + "\n"

def get_level_checks_line(level_checks):
    return "  level_checks: " + str(level_checks) + "\n"

def get_slot_2_level_checks_line(slot_2_level_checks):
    return "  slot_2_level_checks: " + str(slot_2_level_checks) + "\n"

def get_force_stats_and_abilities_on_levels_line(force_stats_and_abilities_on_levels):
    return "  force_stats_and_abilities_on_levels: " + str(force_stats_and_abilities_on_levels) + "\n"

def get_strength_increase_line(strength_increases):
    return "  strength_increase: " + str(strength_increases) + "\n"

def get_defense_increase_line(defense_increases):
    return "  defense_increase: " + str(defense_increases) + "\n"

def get_hp_increase_line(hp_increases):
    return "  hp_increase: " + str(hp_increases) + "\n"

def get_ap_increase_line(ap_increases):
    return "  ap_increase: " + str(ap_increases) + "\n"

def get_mp_increase_line(mp_increases):
    return "  mp_increase: " + str(mp_increases) + "\n"

def get_accessory_slot_increase_line(accessory_slot_increases):
    return "  accessory_slot_increase: " + str(accessory_slot_increases) + "\n"

def get_item_slot_increase_line(item_slot_increases):
    return "  item_slot_increase: " + str(item_slot_increases) + "\n"

def get_keyblades_unlock_chests_line(keyblades_unlock_chests):
    return "  keyblades_unlock_chests: " + str(keyblades_unlock_chests).replace("Yes", "true").replace("No", "false") + "\n"

def get_keyblade_stats_line(keyblade_stats):
    return "  keyblade_stats: " + str(keyblade_stats).replace(" ", "_").lower() + "\n"

def get_bad_starting_weapons_line(bad_starting_weapons):
    return "  bad_starting_weapons: " + str(bad_starting_weapons).replace("Yes", "true").replace("No", "false") + "\n"

def get_keyblade_max_str_line(keyblade_max_strength):
    return "  keyblade_max_str: " + str(keyblade_max_strength) + "\n"

def get_keyblade_min_str_line(keyblade_min_strength):
    return "  keyblade_min_str: " + str(keyblade_min_strength) + "\n"

def get_keyblade_max_crit_rate_line(keyblade_max_crit_rate):
    return "  keyblade_max_crit_rate: " + str(keyblade_max_crit_rate) + "\n"

def get_keyblade_min_crit_rate_line(keyblade_min_crit_rate):
    return "  keyblade_min_crit_rate: " + str(keyblade_min_crit_rate) + "\n"

def get_keyblade_max_crit_bonus_line(keyblade_max_crit_bonus):
    return "  keyblade_max_crit_str: " + str(keyblade_max_crit_bonus) + "\n"

def get_keyblade_min_crit_bonus_line(keyblade_min_crit_bonus):
    return "  keyblade_min_crit_str: " + str(keyblade_min_crit_bonus) + "\n"

def get_keyblade_max_recoil_line(keyblade_max_recoil):
    return "  keyblade_max_recoil: " + str(keyblade_max_recoil) + "\n"

def get_keyblade_min_recoil_line(keyblade_min_recoil):
    return "  keyblade_min_recoil: " + str(keyblade_min_recoil) + "\n"

def get_keyblade_max_mp_line(keyblade_max_mp):
    return "  keyblade_max_mp: " + str(keyblade_max_mp) + "\n"

def get_keyblade_min_mp_line(keyblade_min_mp):
    return "  keyblade_min_mp: " + str(keyblade_min_mp) + "\n"

def get_starting_worlds_line(starting_worlds):
    return "  starting_worlds: " + str(starting_worlds) + "\n"

def get_starting_tools_line(starting_tools):
    return "  starting_tools: " + str(starting_tools).replace("Yes", "true").replace("No", "false") + "\n"

def get_randomize_puppies_line(randomize_puppies):
    return "  randomize_puppies: " + str(randomize_puppies).replace("Yes", "true").replace("No", "false") + "\n"

def get_puppy_value_line(puppy_value):
    return "  puppy_value: " + str(puppy_value) + "\n"

def get_interact_in_battle_line(interact_in_battle):
    return "  interact_in_battle: " + str(interact_in_battle).replace("Yes", "true").replace("No", "false") + "\n"

def get_advanced_logic_line(advanced_logic):
    return "  advanced_logic: " + str(advanced_logic).replace("Yes", "true").replace("No", "false") + "\n"

def get_extra_shared_abilities_line(extra_shared_abilities):
    return "  extra_shared_abilities: " + str(extra_shared_abilities).replace("Yes", "true").replace("No", "false") + "\n"

def get_exp_zero_in_pool_line(exp_zero_in_pool):
    return "  exp_zero_in_pool: " + str(exp_zero_in_pool).replace("Yes", "true").replace("No", "false") + "\n"

def get_death_link_line(death_link):
    return "  death_link: " + str(death_link).replace(" ", "_").lower() + "\n"

def get_donald_death_link_line(donald_death_link):
    return "  donald_death_link: " + str(donald_death_link).replace("Yes", "true").replace("No", "false") + "\n"

def get_goofy_death_link_line(goofy_death_link):
    return "  goofy_death_link: " + str(goofy_death_link).replace("Yes", "true").replace("No", "false") + "\n"

def get_remote_items_line(remote_items):
    return "  remote_items: " + str(remote_items).replace(" ", "_").lower() + "\n"

def get_shorten_go_mode_line(shorten_go_mode):
    return "  shorten_go_mode: " + str(shorten_go_mode).replace("Yes", "true").replace("No", "false") + "\n"

def output_yaml(yaml_str, slot_name):
    slot_name = slot_name.replace("{number}", "")
    path = "./Settings/"
    if not os.path.exists(path):
        os.makedirs(path)
    with open(path + slot_name + '.yaml', mode = 'w') as file:
        file.write(yaml_str)
    print("Output newly created yaml to " + path + slot_name)
    print(yaml_str)

if __name__ == "__main__":
    main()