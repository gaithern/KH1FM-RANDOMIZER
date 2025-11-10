from tkinter import filedialog

from clear_working_folder import clear_working_folder
from write_files_to_working import write_files_to_working
from write_enemy_drop_rewards import write_enemy_drop_rewards
from write_bambi_rewards import write_bambi_rewards
from write_chests_and_rewards import write_chests_and_rewards
from write_level_up_rewards import write_level_up_rewards
from write_mod_zip import write_mod_zip
from write_static_items import write_static_items
from write_keyblade_stats import write_keyblade_stats
from write_item_sort_order_and_sell_price import write_item_sort_order_and_sell_price
from write_synthesis_items import write_synthesis_items
from write_lucky_emblems_lua import write_lucky_emblems_lua
from write_interaction_lua import write_interaction_lua
from write_map_prizes import write_map_prizes
from write_exp_chart import write_exp_chart
from write_fix_combo_master import write_fix_combo_master
from write_map_prize_lua import write_map_prize_lua
from write_toggleable_luas import write_toggleable_luas
from write_handle_items_lua import write_handle_items_lua
from write_death_link_lua import write_death_link_lua
from write_destiny_islands_lua import write_destiny_islands_lua
from write_receive_ap_items_lua import write_receive_ap_items_lua
from write_seed import write_seed
from write_icon import write_icon
from write_synthesis_item_names_lua import write_synthesis_item_names_lua
from write_starting_accessories import write_starting_accessories
from write_ap_cost_lua import write_ap_cost_lua
from write_spell_info import write_spell_info
from validate_evdl_data import validate_evdl_data
from unzip_ap_output import unzip_ap_output

def get_kh1_data_path():
    kh1_data_path = None
    while not kh1_data_path:
        kh1_data_path = filedialog.askdirectory()
        if not kh1_data_path:
            print("Error, please select a valid KH1 data path")
    return kh1_data_path

def write_mod(ap_zip_file_name = None, kh1_data_path = None):
    print("Unzipping AP Output File...")
    json_path = unzip_ap_output(ap_zip_file_name)
    item_location_map_file = json_path + "/item_location_map.json"
    keyblade_stats_file = json_path + "/keyblade_stats.json"
    settings_file = json_path + "/settings.json"
    ap_cost_file = json_path + "/ap_costs.json"
    mp_cost_file = json_path + "/mp_costs.json"
    
    print("Item Location Map File: " + str(item_location_map_file))
    print("Keyblade Stats File: " + str(keyblade_stats_file))
    print("Settings File: " + str(settings_file))
    print("AP Costs File: " + str(ap_cost_file))
    print("MP Costs File: " + str(mp_cost_file))
    
    if kh1_data_path is None:
        print("Getting KH1 data path...")
        kh1_data_path = get_kh1_data_path()
    
    print("Validating KH1 data...")
    validate_evdl_data(kh1_data_path = kh1_data_path)
    
    print("Clearing working folder...")
    clear_working_folder()
    
    print("Writing necessary files to working directory...")
    write_files_to_working(kh1_data_path = kh1_data_path)
    
    print("Writing static items...")
    write_static_items(seed_json_file = item_location_map_file)
    
    print("Writing enemy drops...")
    write_enemy_drop_rewards()
    
    print("Writing bambi drops...")
    write_bambi_rewards()
    
    print("Writing chests and rewards...")
    write_chests_and_rewards(seed_json_file = item_location_map_file)
    
    print("Writing level up rewards...")
    write_level_up_rewards(seed_json_file = item_location_map_file)
    
    print("Writing weapon stats...")
    write_keyblade_stats(seed_json_file = keyblade_stats_file)
    
    print("Writing item sort order and sell price...")
    write_item_sort_order_and_sell_price(settings_file = settings_file)
    
    print("Writing synthesis items...")
    write_synthesis_items(seed_json_file = item_location_map_file)
    
    print("Writing lucky emblem lua...")
    write_lucky_emblems_lua(settings_file = settings_file)
    
    print("Writing interaction lua...")
    write_interaction_lua(settings_file = settings_file)
    
    print("Writing map prizes...")
    write_map_prizes(seed_json_file = item_location_map_file)
    
    print("Writing EXP chart...")
    write_exp_chart(settings_file = settings_file)
    
    print("Writing combo master lua...")
    write_fix_combo_master(seed_json_file = item_location_map_file)
    
    print("Writing map prize lua...")
    write_map_prize_lua(seed_json_file = item_location_map_file)
    
    print("Writing toggleable luas...")
    write_toggleable_luas(settings_file = settings_file)
    
    print("Writing handle items lua...")
    write_handle_items_lua(settings_file = settings_file)
    
    print("Writing death link lua...")
    write_death_link_lua(settings_file = settings_file)
    
    print("Writing Destiny Islands lua...")
    write_destiny_islands_lua(settings_file = settings_file)
    
    print("Writing Receive AP Items lua...")
    write_receive_ap_items_lua(settings_file = settings_file)
    
    print("Writing synthesis item names lua...")
    write_synthesis_item_names_lua(settings_file = settings_file)
    
    print("Writing starting accessories...")
    write_starting_accessories(seed_json_file = item_location_map_file, settings_file = settings_file)
    
    print("Writing AP Costs lua...")
    write_ap_cost_lua(settings_file = settings_file, ap_cost_file = ap_cost_file)
    
    print("Writing spell info...")
    write_spell_info(settings_file = settings_file, mp_cost_file = mp_cost_file)
    
    print("Writing seed...")
    write_seed(settings_file = settings_file)
    
    print("Writing icon...")
    write_icon()
    
    print("Writing mod zip...")
    write_mod_zip(settings_file = settings_file)
    
    print("All jobs complete!  Enjoy!")

if __name__ == "__main__":
    write_mod()