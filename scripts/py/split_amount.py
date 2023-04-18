import random
import secrets

def random_splits(n, k):
    while True:
        split = [secrets.randbelow(int(2*n/k))+1 for _ in range(k-1)]
        addition = n - sum(split)
        if addition > 0:
            split.append(addition)
            if sum(split) == n:
                return split
            


if __name__ == "__main__":
    split = random_splits(125, 11)
    print(split)
