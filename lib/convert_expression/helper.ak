use aiken/bytearray
use aiken/hash
use aiken/list
use assist/maths
use convert_expression/types

pub fn prove_burn(
  burn_ints: List<Int>,
  burn_names: List<ByteArray>,
  burn_proofs: List<ByteArray>,
) -> Bool {
  let outcomes =
    list.map3(
      burn_ints,
      burn_names,
      burn_proofs,
      fn(i, n, p) {
        // this corrects g and q into i instead of just being i
        let num_hash = maths.from_int(i)
        let combined = bytearray.concat(num_hash, p)
        // create the hash and modulo and cant be zero
        and {
          hash.sha3_256(combined) == n,
          i > 1,
          i < types.q,
        }
      },
    )
  list.all(outcomes, fn(n) { n == True })
}

pub fn prove_mint(mint_ints: List<Int>, mint_names: List<ByteArray>) -> Bool {
  // its hard to find n % i so do n % i % qq instead
  let outcomes = list.map2(mint_ints, mint_names, fn(i, n) { and {
          (maths.to_int(n) % i % types.qq == 0)?,
          i > 1,
          i < types.q,
        } })
  list.all(outcomes, fn(n) { n == True })
}
