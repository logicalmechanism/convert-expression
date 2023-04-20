import py.utxo_management as um
import py.split_amount as sa
import py.find_similar_hash as fsh
import os
import json

# system constants
g = 2
r = 91
c = 561
q = 9223372036854775783
qq = 3000029

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

def calc_num(value):
    return pow(g, value, q)

def product(nums):
    # initialize product variable to 1
    p = 1

    # iterate through each number in the list and multiply them
    for num in nums:
        p *= calc_num(num)
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

def redeemer(extraction_value, nMints):
    owned_folder_path = './utxos/owned'
    pending_folder_path = "./utxos/pending/"
    # extract = pow(g, r + c*extraction_value, q)
    moved = extraction_value + nMints*1000000
    burn_obj = um.random_select(owned_folder_path, moved)
    total = um.total_value(burn_obj)
    change = total - extraction_value
    out = sa.random_splits(change, nMints)
    fsh.save_all_utxos(out)
    mint_obj = get_pending(pending_folder_path)
    
      # burns
    total_burn_constant = 0
    burn_ints = []
    burn_names = []
    burn_proofs = []
    for tkn in burn_obj:
        total_burn_constant += burn_obj[tkn]['first_secret']
        pub = r*burn_obj[tkn]['first_secret'] + c*burn_obj[tkn]['value']
        # burn_ints.append(burn_obj[tkn]['public_number'])
        burn_ints.append(pub)
        name = burn_obj[tkn]['token_name']
        burn_names.append(name)
        burn_proofs.append(burn_obj[tkn]['second_secret'])

    # mints
    total_mint_constant = 0
    mint_ints = []
    mint_names = []
    for tkn in mint_obj:
        total_mint_constant += mint_obj[tkn]['first_secret']
        pub = r*mint_obj[tkn]['first_secret'] + c*mint_obj[tkn]['value']
        # mint_ints.append(mint_obj[tkn]['public_number'])
        mint_ints.append(pub)
        name = mint_obj[tkn]['token_name']
        mint_names.append(name)

    # constants
    alphaC = pow(g, r*(total_mint_constant + 1), q)
    alpha = total_mint_constant
    betaC = pow(g, r*(total_burn_constant), q)
    beta = total_burn_constant
    
    left_side = [r*(total_mint_constant + 1)] + burn_ints
    right_side = [r*(total_burn_constant)] + [r + c*extraction_value] + mint_ints
    # print(left_side)
    # print(right_side)
    check = (product(left_side)) % q == (product(right_side)) % q
    if check is True:
        for p, n in zip(mint_ints, mint_names):
            if int(n, 16) % calc_num(p) % qq != 0:
                print('BAD MINT NAME')
                exit(1)
    else:
        print('BAD MINT')
        exit(1)

    # create redeemer
    data = {
        "constructor": 1,
        "fields": [
            {
                "constructor": 0,
                "fields": []
            }
        ]
    }

    data['fields'][0]['fields'].append(int_obj(alpha))
    data['fields'][0]['fields'].append(list_int_obj(burn_ints))
    data['fields'][0]['fields'].append(list_byte_obj(burn_names))
    data['fields'][0]['fields'].append(list_byte_obj(burn_proofs))
    data['fields'][0]['fields'].append(int_obj(extraction_value))
    data['fields'][0]['fields'].append(int_obj(beta))
    data['fields'][0]['fields'].append(list_int_obj(mint_ints))
    data['fields'][0]['fields'].append(list_byte_obj(mint_names))
    return data

def create_redeemer(extraction_value, nMints, redeemer_path):
    data = redeemer(extraction_value, nMints)
    with open(redeemer_path, "w") as json_file:
    # convert the dictionary object to a JSON string and write it to the file
        json.dump(data, json_file)

if __name__ == "__main__":
    extraction_value = 6000000
    nMints = 3
    redeemer_path = './data/extract_redeemer.json'
    create_redeemer(extraction_value, nMints, redeemer_path)

  