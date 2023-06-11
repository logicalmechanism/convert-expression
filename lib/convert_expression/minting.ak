use aiken/bytearray
use aiken/hash
use aiken/list
use aiken/string
use aiken/transaction/value.{AssetName, PolicyId}
use assist/maths
use convert_expression/types

pub fn int_to_hash(num: Int) -> ByteArray {
  hash.sha3_256(bytearray.from_string(string.from_int(num)))
}

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
        let num_hash = int_to_hash(maths.powmod(types.g, i, types.q))
        let combined = bytearray.concat(num_hash, p)
        // create the hash and modulo and cant be zero
        hash.sha3_256(combined) == n && i > 1 && i < types.q
      },
    )
  list.all(outcomes, fn(n) { n == True })
}

pub fn prove_mint(mint_ints: List<Int>, mint_names: List<ByteArray>) -> Bool {
  // its ahrd to find n % i so do n % i % qq instead
  let outcomes =
    list.map2(
      mint_ints,
      mint_names,
      fn(i, n) {
        maths.to_int(n) % maths.powmod(types.g, i, types.q) % types.qq == 0 && i > 1 && i < types.q
      },
    )
  list.all(outcomes, fn(n) { n == True })
}

pub fn correct_mint(
  mint: List<(PolicyId, AssetName, Int)>,
  pid: PolicyId,
  tkn: AssetName,
  amt: Int,
) -> Bool {
  when mint is {
    [(policy, token_name, quantity), ..rest] ->
      if list.and([policy == pid, token_name == tkn, quantity == amt]) == True {
        True
      } else {
        correct_mint(rest, pid, tkn, amt)
      }
    [] -> False
  }
}
