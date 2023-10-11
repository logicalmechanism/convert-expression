use assist/maths
use convert_expression/types

test list_power_mod_good() {
  let l =
    [91, 499319296258426758, 371533020831606146, 637880808202577067]
  let r =
    [1508733114072609971, 11220000091]
  let left = maths.list_powmod(l, types.g, types.q)
  let right = maths.list_powmod(r, types.g, types.q)
  left == right
}