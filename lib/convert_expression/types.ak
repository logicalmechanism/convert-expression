use aiken/hash.{Blake2b_224, Hash}
use aiken/transaction/credential.{VerificationKey}
use aiken/transaction/value.{PolicyId}

// a generator g
pub const g =
  2

// some constant r
pub const r =
  91

// some multiplier c
pub const c =
  561

// a prime number q
pub const q =
  9223372036854775783

// a second prime number q
pub const qq =
  3000029

pub type PublicKeyHash =
  Hash<Blake2b_224, VerificationKey>

pub type Datum {
  pid: PolicyId,
}

pub type InjectData {
  burn_constant: Int,
  mint_ints: List<Int>,
  mint_names: List<PolicyId>,
  inject: Int,
  mint_constant: Int,
  burn_ints: List<Int>,
  burn_names: List<PolicyId>,
  burn_proofs: List<ByteArray>,
}

pub type ExtractData {
  mint_constant: Int,
  burn_ints: List<Int>,
  burn_names: List<PolicyId>,
  burn_proofs: List<ByteArray>,
  extract: Int,
  burn_constant: Int,
  mint_ints: List<Int>,
  mint_names: List<PolicyId>,
}

pub type LockRedeemer {
  Inject(InjectData)
  Extract(ExtractData)
}
