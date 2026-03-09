from shutil import copyfile

from globals import BASE_DIR

def write_icon():
    copyfile(BASE_DIR / "Images" / "program_icon.png", BASE_DIR / "Working" / "icon.png")