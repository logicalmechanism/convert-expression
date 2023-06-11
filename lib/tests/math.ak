use aiken/math
use convert_expression/types

test large_pow() {
  let true_value = 5230 * 1000000
  let reduced_inject = true_value / 1000000
  let public_constant =
    math.pow(types.g, types.r + types.c * reduced_inject) % types.q
  public_constant > 0
}

test small_pow() {
  let true_value = 23 * 1000000
  let reduced_inject = true_value / 1000000
  let public_constant =
    math.pow(types.g, types.r + types.c * reduced_inject) % types.q
  public_constant > 0
}

test real_pow() {
  let x = 66043
  math.pow(types.g, types.r * x) % types.q > 0
}
