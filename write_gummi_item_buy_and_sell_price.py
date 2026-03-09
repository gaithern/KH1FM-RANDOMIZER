from globals import BASE_DIR, read_csv, read_bytes, write_bytes

def write_gummi_item_buy_and_sell_price():
    kh1_data_path = BASE_DIR / "Working"
    gumi_spec_file = read_bytes(kh1_data_path / "gumi_spec_file.bin")
    gummi_block_prices = read_csv(BASE_DIR / "Documentation" / "KH1FM Documentation - Gummi Block Prices.csv")
    for gummi_block_price in gummi_block_prices:
        offset = int(gummi_block_price["Offset"], 16)
        gumi_spec_file[offset] = 0
    write_bytes(kh1_data_path / "gumi_spec_file.bin", gumi_spec_file)