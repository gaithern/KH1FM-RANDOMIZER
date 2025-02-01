import shutil
import os

def clear_folder(folder_path):
    """
    Clears a folder of all files and subfolders.

    Args:
        folder_path (str): The path to the folder to clear.
    """

    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print(f"Failed to delete {file_path}. Reason: {e}")

def clear_working_folder():
    output_folder = "./Working"
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    clear_folder(output_folder)

if __name__ == "__main__":
    clear_output_folder()