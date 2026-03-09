from globals import extract_zip

def unzip_ap_output(ap_zip_file):
    extract_zip(ap_zip_file)
    return ap_zip_file.with_suffix("")