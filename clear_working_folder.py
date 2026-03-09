import shutil
from globals import BASE_DIR

def clear_folder(folder):
    for item in folder.iterdir():
        try:
            if item.is_dir():
                shutil.rmtree(item)
            else:
                item.unlink()
        except Exception as e:
            print(f"Failed to delete {item}: {e}")

def clear_working_folder():
    working = BASE_DIR / "Working"
    working.mkdir(exist_ok=True)
    clear_folder(working)