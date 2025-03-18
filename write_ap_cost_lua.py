from tkinter import filedialog
import json

def get_ap_cost_data(ap_cost_file = None):
    while not ap_cost_file:
        ap_cost_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 AP Cost JSON")
        if not ap_cost_file:
            print("Error, please select a valid KH1 seed file")
    with open(ap_cost_file, mode='r') as file:
        ap_cost_data = json.load(file)
    return ap_cost_data

def get_settings_data(settings_file = None):
    while not settings_file:
        settings_file = filedialog.askopenfilename(filetypes =[('JSON', '*.json')], title = "KH1 Randomizer Settings JSON")
        if not settings_file:
            print("Error, please select a valid KH1 settings file")
    with open(settings_file, mode='r') as file:
        settings_data = json.load(file)
    return settings_data

def get_ap_cost_template_lua():
    with open('./Template Luas/1fmRandoAPCosts.lua', mode = 'r') as file:
        ap_costs_lua_str = file.read()
    return ap_costs_lua_str

def output_ap_cost_template_lua(ap_costs_lua_str):
    with open('./Working/scripts/1fmRandoAPCosts.lua', mode = 'w') as file:
        file.write(ap_costs_lua_str)

def update_ap_costs_template_lua(ap_cost_data, ap_costs_lua_str):
    costs_string = ""
    for ap_cost in ap_cost_data:
        costs_string = costs_string + str(ap_cost["AP Cost"]) + ","
    costs_string = costs_string[:-1]
    ap_costs_lua_str = ap_costs_lua_str.replace("ability_costs = {}", "ability_costs = {" + costs_string + "}")
    return ap_costs_lua_str

def write_ap_cost_lua(settings_file = None, ap_cost_file = None):
    settings_data = get_settings_data(settings_file)
    if settings_data["randomize_ap_costs"] != "off":
        ap_cost_data = get_ap_cost_data(ap_cost_file)
        ap_costs_lua_str = get_ap_cost_template_lua()
        ap_costs_lua_str = update_ap_costs_template_lua(ap_cost_data, ap_costs_lua_str)
        output_ap_cost_template_lua(ap_costs_lua_str)

if __name__ == "__main__":
    write_ap_cost_lua()