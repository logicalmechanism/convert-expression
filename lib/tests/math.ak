use aiken/math
use hidden_contract/helper
use hidden_contract/types

test large_pow() {
  let true_value =
    5230 * 1000000
  let reduced_inject =
    true_value / 1000000
  let public_constant =
    math.pow(types.g, types.r + types.c * reduced_inject) % types.q
  public_constant > 0
}

test small_pow() {
  let true_value =
    23 * 1000000
  let reduced_inject =
    true_value / 1000000
  let public_constant =
    math.pow(types.g, types.r + types.c * reduced_inject) % types.q
  public_constant > 0
}

test real_pow() {
  let x =
    66043
  math.pow(types.g, types.r * x) % types.q > 0
}

test small_pow_mod() {
  helper.powmod(2, 62, 3) > 0
}

test big_pow_mod() {
  let x =
    2538512792311776
  helper.powmod(types.g, types.r * x, types.q) == 5318306212124587380
}

test pow_speed_test() {
  let reduced_inject =
    10123
  let public_constant =
    math.pow(types.g, types.r + types.c * reduced_inject) % types.q

  helper.powmod(types.g, types.r + types.c * reduced_inject, types.q) == public_constant
}
