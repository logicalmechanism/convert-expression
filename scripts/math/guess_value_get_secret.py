def s(v):
    return 92243462134608086/13 - (561 * v)/91

if __name__ == '__main__':
    for v in range(1000000):
        secret = s(v)
        print(secret)
        if int(secret) - secret == 0:
            print(v, int(secret))