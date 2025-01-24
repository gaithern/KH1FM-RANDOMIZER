from write_files_to_output import write_files_to_output
from write_enemy_drop_rewards import write_enemy_drop_rewards
from write_bambi_rewards import write_bambi_rewards
from write_chests_and_rewards import write_chests_and_rewards
from write_level_up_rewards import write_level_up_rewards
from write_mod_zip import write_mod_zip
from write_static_items import write_static_items
from write_keyblade_stats import write_keyblade_stats
from write_item_sort_order_and_sell_price import write_item_sort_order_and_sell_price
from validate_evdl_data import validate_evdl_data

if __name__ == "__main__":
    validate_evdl_data()
    write_files_to_output()
    write_static_items()
    write_enemy_drop_rewards()
    write_bambi_rewards()
    write_chests_and_rewards()
    write_level_up_rewards()
    write_keyblade_stats()
    write_item_sort_order_and_sell_price()
    write_mod_zip()
    print("All jobs complete!  Enjoy!")