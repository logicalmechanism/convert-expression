import binascii
import hashlib
import secrets

# system constants
g = 2
r = 91
c = 561
q = 9_223_372_036_854_775_783
qq = 3_000_029

def from_int(integer):
    base_256 = []
    while integer > 0:
        remainder = integer % 256
        base_256.append(remainder)
        integer = integer // 256

    # Convert the list of remainders to bytes
    byteArray = bytes(reversed(base_256)).hex()
    return byteArray


def print_hex(number):
    input_str = str(number)
    hex_str = binascii.hexlify(input_str.encode()).decode()
    txBytes = binascii.unhexlify(hex_str)
    h = hashlib.new('sha3_256')
    h.update(txBytes)
    txHash = h.hexdigest()
    return txHash

def print_token(txHash):
    txBytes = binascii.unhexlify(txHash)
    h = hashlib.new('sha3_256')
    h.update(txBytes)
    txHash = h.hexdigest()
    return txHash

def get_proof_and_tkn(public_number):
    # public known number hash
    pmod = powmod(public_number)
    num_hash = from_int(pmod)
    
    while True:
        # find a secret that works
        secret = secrets.randbelow(pow(2,63)-1)

        s_hash = print_hex(secret)
        
        # create the potential token name
        token_name = print_token(num_hash + s_hash)

        # get the base 10 value of the token name
        tval = int(token_name, 16)
        
        # check if the name condition is correct
        if tval % pmod % qq == 0:
            return s_hash, token_name

def pub_num(value, secret):
    return r * secret + c * value

def powmod(value):
    return pow(g, value, q)

def create_token(value):
    secret_number = secrets.randbelow(pow(10,16))        # this is lambda value
    public_number = pub_num(value, secret_number)        # this is what is publicily known
    proof, token_name = get_proof_and_tkn(public_number) # the proof for the token name
    return secret_number, public_number, token_name, proof

if __name__ == "__main__":
    
    value = secrets.randbelow(9876543210) + 1000000 # this is the lovelace amount

    import time
    start_time = time.time()
    print(f"The hidden value is {value/1000000} ₳")
    secret_number, public_number, token_name, proof = create_token(value)
    print(f'The secret number is {secret_number}')
    print(f'\nThe public number is {public_number}')
    print(f'The token name is {token_name}')
    print(f'The proof is {proof}')
    
    end_time = time.time()
    elapsed_time = end_time - start_time
    print(f"Elapsed time: {elapsed_time} seconds")
    
    import timeit

    # n = 100
    # execution_time = timeit.timeit(lambda: create_token(value), number=n)
    # print(f"Average execution time: {execution_time} seconds")
    # print(f"Average execution time per run: {execution_time / n} seconds")