from os import listdir, remove
import json

def get_mint_string(pid):
    mint = ""
    pending_mints = listdir('utxos/pending')
    for m in pending_mints:
        tkn = m.split('.')[0]
        if mint == "":
            mint += "1 " + pid + "." +tkn +" "
        else:
            mint += "+ 1 " + pid + "." +tkn +" "
    print(mint)
    # return mint

def get_burn_string(pid):
    burn = ""
    pending_burns = 'data/extract_redeemer.json'
    with open(pending_burns, 'r') as f:
        file_contents = json.load(f)
    names = file_contents['fields'][0]['fields'][2]['list']
    for n in names:
        tkn = n['bytes']
        if burn == "":
            burn += "-1 " + pid + "." +tkn +" "
        else:
            burn += "+ -1 " + pid + "." +tkn +" "
    print(burn)
    # return burn

def get_change_string():
    pending_burns = 'data/extract_redeemer.json'
    with open(pending_burns, 'r') as f:
        file_contents = json.load(f)
    names = [n['bytes'] for n in file_contents['fields'][0]['fields'][2]['list']]
    
    change = ""
    pending_change = "tmp/seller_utxo.json"
    with open(pending_change, 'r') as f:
        file_contents = json.load(f)
    for utxo in file_contents:
        value = file_contents[utxo]['value']
        for pid in value:
            if pid != "lovelace":
                for tkn in value[pid]:
                    if tkn not in names:
                        # print(pid,tkn, value[pid][tkn])
                        if change == "":
                            change += f"{value[pid][tkn]} {pid}.{tkn} "
                        else:
                            change += f"+ {value[pid][tkn]} {pid}.{tkn} "
    print(change)


def remove_spent():
    pending_burns = 'data/extract_redeemer.json'
    with open(pending_burns, 'r') as f:
        file_contents = json.load(f)
    names = [n['bytes'] for n in file_contents['fields'][0]['fields'][2]['list']]
    for n in names:
        remove('./utxos/owned/'+n+'.json')
    
    

if __name__ == "__main__":
    # get_mint_string("acab")
    # get_burn_string("acab")
    # get_change_string()
    remove_spent()