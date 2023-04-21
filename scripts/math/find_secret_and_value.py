
def f(secret):
    return 259161613094895701/561 - (91*secret)/561

for i in range(1, pow(10,6)):
    result = g(i)
    if result > 0 and int(result) - result == 0:
        print(i, int(result))
    