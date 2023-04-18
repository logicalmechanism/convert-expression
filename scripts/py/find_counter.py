# system constants
g = 2
r = 91
c = 561
q = 999331
# q = 9223372036854775783

e = 1561


s11=1857440627797117
v1=123
m1 = pow(g,r*s11 + c*v1,q)

s21=4406164623923326
v2=321
m2 = pow(g,r*s21 + c*v2, q)

s31=1241255234235235
v3=134
m3 = pow(g, r*s31 + c*v3, q)

rc = pow(g,r*(s11 + s21 + s31), q)
lc = pow(g, r, q)
b = pow(g, r +c*(v1 + v2 + v3), q)
d = pow(g, r + c, q)

k = s11 + s21 + s31
print(lc, m1*m2*m3 % q, b*rc % q)
exit()
# print(lc*m1*m2 % q == b*rc % q)
# Mint 2 tokens for b amount but only send in 1 then calc V to fake it
print(m1*m2*m3 % q, d*rc % q)
v = 469904417

# print(v % r)
# print(lc % r)

print(v % e, lc % e ==0 , rc % e == 0)
# for v in range(0,100000000000):
    # x = pow(g, r +c*v, q)
    # statement = lc*m1*m2 % q == x*rc % q
statement = v*m1*m2*m3 % q == d*rc % q
if statement is True:
    print(f"The real value {lc} and a faked one {v}")
    print(v*m1*m2*m3 % q == d*rc % q)
    print(lc*m1*m2*m3 % q == b*rc % q)
    # break
# print(v % k == v, lc % k == lc, lc, k,v)
#  Solution in the least residue system   
    
