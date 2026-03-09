import shutil
from globals import BASE_DIR

def write_seed_file(seed_json_file):
    target_dir = BASE_DIR / "Working"
    target_dir.mkdir(parents=True, exist_ok=True)
    target_path = target_dir / seed_json_file.name
    shutil.copy2(seed_json_file, target_path)
    print(f"Copied settings file to: {target_path}")
    return target_path