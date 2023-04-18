import hashlib
import random
import binascii
import json
import math
import secrets

# system constants
g = 2
r = 91
c = 561
q = 9223372036854775783
qq = 3000029

def print_num(value, secret):
    return pow(g, r*secret + c * value, q)

def print_token(txHash):
    txBytes = binascii.unhexlify(txHash)
    h = hashlib.new('sha3_256')
    h.update(txBytes)
    txHash = h.hexdigest()
    return txHash

def print_hex(number):
    input_str = str(number)
    hex_str = binascii.hexlify(input_str.encode()).decode()
    txBytes = binascii.unhexlify(hex_str)
    h = hashlib.new('sha3_256')
    h.update(txBytes)
    txHash = h.hexdigest()
    return txHash

def get_msg_and_tkn(num):
    # public known number hash
    num_hash = print_hex(num)
    
    while True:
        # find a secret that works
        secret = secrets.randbelow(pow(2,63)-1)

        s_hash = print_hex(secret)
        
        # create the potential token name
        token_name = print_token(num_hash + s_hash)

        # get the base 10 value of the token name
        tval = int(token_name, 16)
        
        # check if the name condition is correct
        if (tval % num) % qq == 0:
            return s_hash, token_name

def get_value_info(value):
    # random select integer between 1 and 10^16
    first_secret = secrets.randbelow(pow(10,16))
    public_number = print_num(value, first_secret)
    second_secret, token_name = get_msg_and_tkn(public_number)
    obj = {
        "value": value,
        "first_secret": first_secret,
        "public_number": public_number,
        "second_secret": second_secret,
        "token_name": token_name
    }
    return obj

def save_all_utxos(list_of_values):
    for v in list_of_values:
        print(f"Solving for {v}")
        obj = get_value_info(v)
        with open("utxos/pending/"+obj['token_name']+".json", "w") as fp:
            json.dump(obj, fp)

if __name__ == "__main__":
    value = secrets.randbelow(1024) + 1
    print(f"The hidden value to prove is {value}")

    obj = get_value_info(value)
    num = obj['public_number']
    first_secret = obj['first_secret']
    second_secret = obj['second_secret']
    token_name = obj['token_name']
    
    
    print(f"The first secret is {first_secret}")
    # num = pow(g, r*secret + c * value, q)
    print(f'The secret number is z = {r}*{first_secret} + {c}*{value}')
    print(f'The public value is {g}^z mod {q} = ', num)
    # second_secret, token_name = get_msg_and_tkn(num)
    print(f"The second secret is {second_secret}")
    print(f"The token name must be {token_name}")
    tval = int(token_name, 16)
    check = tval % num % qq == 0
    print(f"because {tval} % {num} % {qq} == 0 is {check}")
    
    exit()
    print("INJECT")
    mints = [15, 15]
    burns = [15]
    inject = 15

    left = []
    left_secrets = []

    right = []
    right_secrets = []

    for b in burns:
        print()
        secret = random.randint(1,pow(10,16))
        num = print_num(b, secret)
        second_secret, token_name = get_msg_and_tkn(num)
        print(f"The value {b} and the first secret {secret}")
        print(f"The burn num is {num}")
        print(f"The second secret is {second_secret}")
        print(f"The token name is {token_name}")

        right.append(num)
        right_secrets.append(secret)

    for m in mints:
        print()
        secret = random.randint(1,pow(10,16))
        num = print_num(m, secret)
        second_secret, token_name = get_msg_and_tkn(num)
        print(f"The value {m} and the first secret {secret}")
        print(f"The mint num is {num}")
        print(f"The second secret is {second_secret}")
        print(f"The token name is {token_name}")

        left.append(num)
        left_secrets.append(secret)

    print()
    print(f"Inject Value {print_num(inject, 1)}")
    right.append(print_num(inject, 1))

    print(f"left constant {print_num(0, sum(right_secrets)+1)}")
    left.append(print_num(0, sum(right_secrets)+1))

    print(f"right constant {print_num(0, sum(left_secrets))}")
    right.append(print_num(0, sum(left_secrets)))

    print(left,)
    print(right)
    print()
    print("EXTRACT")
    mints = [15, 15]
    burns = [50]
    extract = 20

    left = []
    left_secrets = []

    right = []
    right_secrets = []

    for b in burns:
        print()
        secret = random.randint(1,pow(10,16))
        num = print_num(b, secret)
        second_secret, token_name = get_msg_and_tkn(num)
        print(f"The value {b} and the first secret {secret}")
        print(f"The burn num is {num}")
        print(f"The second secret is {second_secret}")
        print(f"The token name is {token_name}")

        left.append(num)
        left_secrets.append(secret)

    for m in mints:
        print()
        secret = random.randint(1,pow(10,16))
        num = print_num(m, secret)
        second_secret, token_name = get_msg_and_tkn(num)
        print(f"The value {m} and the first secret {secret}")
        print(f"The mint num is {num}")
        print(f"The second secret is {second_secret}")
        print(f"The token name is {token_name}")

        right.append(num)
        right_secrets.append(secret)

    print()
    print(f"Extract Value {print_num(extract, 1)}")
    right.append(print_num(extract, 1))

    print(f"left constant {print_num(0, sum(right_secrets)+1)}")
    left.append(print_num(0, sum(right_secrets)+1))

    print(f"right constant {print_num(0, sum(left_secrets))}")
    right.append(print_num(0, sum(left_secrets)))

    print(left,)
    print(right)