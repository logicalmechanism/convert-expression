import json
import os

# system constants
g = 2
r = 91
c = 561
q = 9223372036854775783
qq = 3000029

def product(nums):
    # initialize product variable to 1
    p = 1

    # iterate through each number in the list and multiply them
    for num in nums:
        p *= num
    return p


def get_pending(folder_path):
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


def get_spending(folder_path, amount):
    # Create an empty dictionary to store the global object
    global_object = {}
    total = 0
    if amount == 0:
        return {}
    # Loop through all the files in the folder
    for filename in os.listdir(folder_path):
        if filename.endswith('.json'):  # Check if the file is a JSON file
            # Open the file and load its contents into a Python object
            with open(os.path.join(folder_path, filename), 'r') as f:
                file_contents = json.load(f)
            # Add the file contents to the global object with the key being the file name
            value = file_contents['value']
            total += value
            global_object[filename.split('.')[0]] = file_contents
            if total > amount:
                return global_object
    # not enough to spend
    return {}

def int_obj(n):
    return {"int": n}

def byte_obj(b):
    return {"bytes": b}

def list_int_obj(l):
    obj = {"list": []}
    for n in l:
        obj['list'].append(int_obj(n))
    return obj

def list_byte_obj(l):
    obj = {"list": []}
    for b in l:
        obj['list'].append(byte_obj(b))
    return obj

def redeemer(injection_value, extraction_value):
    inject = pow(g, r + c*injection_value//1000000, q)

    # Create an empty dictionary to store the global object
    folder_path = "utxos/pending/"
    mint_obj = get_pending(folder_path)
    
    folder_path = "utxos/owned/"
    burn_obj = get_spending(folder_path, extraction_value)

    # burns
    K_j = 0
    burn_ints = []
    burn_names = []
    burn_proofs = []
    for tkn in burn_obj:
        K_j += burn_obj[tkn]['first_secret']
        burn_ints.append(burn_obj[tkn]['public_number'])
        name = burn_obj[tkn]['token_name']
        burn_names.append(name)
        burn_proofs.append(burn_obj[tkn]['second_secret'])

    # mints
    K_i = 0
    mint_ints = []
    mint_names = []
    for tkn in mint_obj:
        K_j += mint_obj[tkn]['first_secret']
        mint_ints.append(mint_obj[tkn]['public_number'])
        name = mint_obj[tkn]['token_name']
        mint_names.append(name)
        

    # constants
    alphaC = pow(g, r*(K_i + 1), q)
    alpha = K_i
    betaC = pow(g, r*(K_j), q)
    beta = K_j

    check = (alphaC * product(mint_ints)) % q == (betaC * inject * product(burn_ints)) % q
    if check is True:
        for p, n in zip(mint_ints, mint_names):
            if int(n, 16) % p % qq != 0:
                print('BAD MINT')
                exit(1)
    else:
        print('BAD MINT')
        exit(1)
             
    data = {
        "constructor": 0,
        "fields": [
            {
                "constructor": 0,
                "fields": []
            }
        ]
    }

    data['fields'][0]['fields'].append(int_obj(alpha))
    data['fields'][0]['fields'].append(list_int_obj(mint_ints))
    data['fields'][0]['fields'].append(list_byte_obj(mint_names))
    data['fields'][0]['fields'].append(int_obj(injection_value))
    data['fields'][0]['fields'].append(int_obj(beta))
    data['fields'][0]['fields'].append(list_int_obj(burn_ints))
    data['fields'][0]['fields'].append(list_byte_obj(burn_names))
    data['fields'][0]['fields'].append(list_byte_obj(burn_proofs))
    return data

def create_redeemer(injection_value, extraction_value, redeemer_path):
    data = redeemer(injection_value, extraction_value)
    with open(redeemer_path, "w") as json_file:
    # convert the dictionary object to a JSON string and write it to the file
        json.dump(data, json_file)



if __name__ == "__main__":
    injection_value = 125000000
    extraction_value = 0
    redeemer_path = './data/inject_redeemer.json'
    create_redeemer(injection_value, extraction_value, redeemer_path)