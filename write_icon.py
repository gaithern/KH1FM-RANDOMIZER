from shutil import copyfile

def write_icon():
    copyfile("./Images/program_icon.png", "./Working/icon.png")

if __name__ == "__main__":
    write_icon()