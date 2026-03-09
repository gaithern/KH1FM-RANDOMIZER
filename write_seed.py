from globals import BASE_DIR, read_json, write_file

def write_seed(settings_file):
    settings_data = read_json(settings_file)
    seed = settings_data["seed"]
    write_file(BASE_DIR / "Working" / "scripts" / "randofiles" / "seed.txt", seed)