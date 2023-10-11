use aiken/transaction/value.{AssetName, PolicyId}

// a generator g
pub const g = 2

// some constant r
pub const r = 91

// some multiplier c
pub const c = 561

// a prime number q
// 2^63
// 9223372036854775783
//
// 2^64
// 18446744073709551629
//
// 2^256
// 115792089237316195423570985008687907853269984665640564039457584007913129639747
//
pub const q = 9223372036854775783

// a second prime number qq
pub const qq = 3000029

pub type Datum {
  pid: PolicyId,
}

pub type ConvertData {
  left_constant: Int,
  left_ints: List<Int>,
  left_names: List<AssetName>,
  syringe: Int,
  right_constant: Int,
  right_ints: List<Int>,
  right_names: List<AssetName>,
  name_proofs: List<ByteArray>,
}

pub type Redeemer {
  Inject(ConvertData)
  Extract(ConvertData)
}
