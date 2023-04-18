import random
import os
import json


def get_owned(folder_path):
    # Create an empty dictionary to store the global object
    global_object = {}

    # Loop through all the files in the folder
    for filename in os.listdir(folder_path):
        if filename.endswith('.json'):  # Check if the file is a JSON file
            # Open the file and load its contents into a Python object
            with open(os.path.join(folder_path, filename), 'r') as f:
                file_contents = json.load(f)
            # Add the file contents to the global object with the key being the file name
            global_object[filename.split('.')[0]] = file_contents
    return global_object

def random_select(folder_path, value):
    data = get_owned(folder_path)
    total = 0
    utxo_set = {}
    while data:
    # for tkn in data:
        # Select a random key from the dictionary
        random_key = random.choice(list(data.keys()))
        # Get the value associated with the selected key
        random_value = data[random_key]
        # Delete the key-value pair from the dictionary
        rvalue = random_value['value']
        total += rvalue
        utxo_set[random_key] = data[random_key]
        del data[random_key]
        # when the threshold is done return it
        if total > value:
            return utxo_set
    # didn't find enough
    return []

def select_all(folder_path):
    data = get_owned(folder_path)
    utxo_set = {}
    while data:
        # Select a random key from the dictionary
        random_key = random.choice(list(data.keys()))
        # Get the value associated with the selected key
        utxo_set[random_key] = data[random_key]
        del data[random_key]
    return utxo_set
        
def total_value(utxo_set):
    total = 0
    for tkn in utxo_set:
        value = utxo_set[tkn]
        total += value['value']
    return total

if __name__ == "__main__":
    folder_path = './utxos/owned'
    utxo_set = select_all(folder_path)
    # value = random.randint(1,15)
    # utxo_set = random_select(folder_path, value)
    # print(value)
    total = total_value(utxo_set)
    print(total)