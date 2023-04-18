from utxo_management import select_all, total_value

if __name__ == "__main__":
    folder_path = './utxos/owned'
    utxo_set = select_all(folder_path)
    total = total_value(utxo_set)
    print(f"Current Extractable Balance: {total-3-1}")