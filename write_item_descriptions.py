import os

from definitions import kh1_hex_to_char_map, new_item_descriptions

def get_item_description_bytes(kh1_data_path):
    with open(kh1_data_path + "/remastered/btltbl.bin/UK_ItemHelp.bin", mode = 'rb') as file:
        return bytearray(file.read())

def get_replacement_byte(char):
    for i in range(len(kh1_hex_to_char_map)):
        if kh1_hex_to_char_map[i] == char:
            return i

def safe_open_wb(path):
    ''' Open "path" for writing, creating any parent directories as needed.
    '''
    os.makedirs(os.path.dirname(path), exist_ok=True)
    return open(path, 'wb')

def output_item_descriptions(new_item_description_bytes):
    with safe_open_wb('./Working/remastered/btltbl.bin/UK_ItemHelp.bin') as file:
        file.write(new_item_description_bytes)

def build_item_description_string(item_description_bytes):
    item_description_string = ""
    for byte in item_description_bytes:
        item_description_string = item_description_string + kh1_hex_to_char_map[byte]
    return item_description_string

def replace_escape_character_byte_substring(item_description_string):
    item_description_string = item_description_string.replace("{0x0D} {eol}", "{escape character}")
    return item_description_string

def build_item_description_string_array(item_description_string):
    item_description_string = replace_escape_character_byte_substring(item_description_string)
    item_descriptions = item_description_string.replace("{lf}", "\n").split("{eol}")
    return item_descriptions

def replace_item_descriptions_with_definitions_new_item_descriptions(item_descriptions):
    for i in range(len(item_descriptions)):
        if i+1 in new_item_descriptions.keys():
            item_descriptions[i] = new_item_descriptions[i+1]
    return item_descriptions

def concat_item_descriptions(item_descriptions):
    item_description_string = ""
    for item_description in item_descriptions:
        item_description_string = item_description_string + item_description + "{eol}"
    return item_description_string[:-5].replace("{escape character}","{0x0D} {eol}").replace("\n", "{lf}")

def build_item_description_bytes(item_description_string):
    item_description_bytes = []
    i = 0
    while i < len(item_description_string):
        if item_description_string[i] == "{":
            j = 0
            char = "{"
            while item_description_string[i + j] != "}":
                j = j + 1
                char = char + item_description_string[i + j]
            i = i + j
        else:
            char = item_description_string[i]
        replacement_byte = get_replacement_byte(char)
        item_description_bytes.append(replacement_byte)
        i = i + 1
    return item_description_bytes

def replace_specific_item_description(item_num, description):
    kh1_data_path = "./Working/"
    item_description_bytes = get_item_description_bytes(kh1_data_path)
    item_description_string = build_item_description_string(item_description_bytes)
    item_descriptions = build_item_description_string_array(item_description_string)
    item_descriptions[item_num-1] = description
    new_item_description_string = concat_item_descriptions(item_descriptions)
    new_item_description_bytes = build_item_description_bytes(new_item_description_string)
    output_item_descriptions(bytes(new_item_description_bytes))

def write_item_descriptions():
    kh1_data_path = "./Working/"
    item_description_bytes = get_item_description_bytes(kh1_data_path)
    item_description_string = build_item_description_string(item_description_bytes)
    item_descriptions = build_item_description_string_array(item_description_string)
    item_descriptions = replace_item_descriptions_with_definitions_new_item_descriptions(item_descriptions)
    new_item_description_string = concat_item_descriptions(item_descriptions)
    new_item_description_bytes = build_item_description_bytes(new_item_description_string)
    output_item_descriptions(bytes(new_item_description_bytes))

if __name__ == "__main__":
    write_item_descriptions()
