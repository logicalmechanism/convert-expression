// use aiken/bytearray
// use aiken/hash
// use aiken/list
// use aiken/string
// use aiken/transaction.{InlineDatum, Input, Output, OutputReference, Transaction}
// use aiken/transaction/credential.{Address}
// use aiken/transaction/value.{AssetName, PolicyId, Value}
// use convert_expression/types

// pub fn correct_mint(
//   mint: List<(PolicyId, AssetName, Int)>,
//   pid: PolicyId,
//   tkn: AssetName,
//   amt: Int,
// ) -> Bool {
//   when mint is {
//     [(policy, token_name, quantity), ..rest] ->
//       if list.and([policy == pid, token_name == tkn, quantity == amt]) == True {
//         True
//       } else {
//         correct_mint(rest, pid, tkn, amt)
//       }
//     [] -> False
//   }
// }

// pub fn count_script_inputs(
//   inputs: List<Input>,
//   script_addr: Address,
//   counter: Int,
// ) -> Int {
//   when inputs is {
//     [input, ..rest] ->
//       if input.output.address == script_addr {
//         count_script_inputs(rest, script_addr, counter + 1)
//       } else {
//         count_script_inputs(rest, script_addr, counter)
//       }
//     [] -> counter
//   }
// }

// // need function that counts script outputs
// pub fn count_script_outputs(
//   outputs: List<Output>,
//   script_addr: Address,
//   counter: Int,
// ) -> Int {
//   when outputs is {
//     [output, ..rest] ->
//       if output.address == script_addr {
//         count_script_outputs(rest, script_addr, counter + 1)
//       } else {
//         count_script_outputs(rest, script_addr, counter)
//       }
//     [] -> counter
//   }
// }

// pub fn get_validating_input(
//   inputs: List<Input>,
//   out_ref: OutputReference,
// ) -> Input {
//   when inputs is {
//     [input, ..rest] ->
//       if input.output_reference == out_ref {
//         input
//       } else {
//         get_validating_input(rest, out_ref)
//       }
//     [] -> error @"no script input found"
//   }
// }

// pub fn list_pow_mod(lst: List<Int>) -> Int {
//   list.foldr(lst, fn(n, total) { n * total % types.q }, 1) % types.q
// }

// pub fn find_exact_payout(
//   pay_address: Address,
//   pay_value: Value,
//   outputs: List<Output>,
// ) -> Bool {
//   when outputs is {
//     [output, ..rest] ->
//       if output.address == pay_address && output.value == pay_value {
//         True
//       } else {
//         find_exact_payout(pay_address, pay_value, rest)
//       }
//     [] -> False
//   }
// }

// pub fn create_wallet_address(pkh: ByteArray, sc: ByteArray) -> Address {
//   // empty bytearrays means dont add the sc to the pkh
//   if sc == #"" {
//     credential.from_verification_key(pkh)
//   } else {
//     credential.from_verification_key(pkh)
//       |> credential.with_delegation_key(sc)
//   }
// }

// pub fn create_script_address(pkh: ByteArray, sc: ByteArray) -> Address {
//   // empty bytearrays means dont add the stake script to pkh script
//   if sc == #"" {
//     credential.from_script(pkh)
//   } else {
//     credential.from_script(pkh) |> credential.with_delegation_script(sc)
//   }
// }

// pub fn find_script_output(outputs: List<Output>, script_addr: Address) -> Output {
//   when outputs is {
//     [output, ..rest] ->
//       if output.address == script_addr {
//         output
//       } else {
//         find_script_output(rest, script_addr)
//       }
//     [] -> error @"no script output found"
//   }
// }

// pub fn find_outbound_datum(possible_output: Output) -> Data {
//   when possible_output.datum is {
//     InlineDatum(outbound_datum) -> outbound_datum
//     _ -> error @"expected outbound inline datum"
//   }
// }

// pub fn get_outbound_datum(tx: Transaction, validating_input: Input) -> Data {
//   let script_addr = validating_input.output.address
//   let outbound_output = find_script_output(tx.outputs, script_addr)
//   find_outbound_datum(outbound_output)
// }

// pub fn int_to_hash(num: Int) -> ByteArray {
//   hash.sha3_256(bytearray.from_string(string.from_int(num)))
// }

// pub fn to_int(self: ByteArray) {
//   bytearray.foldl(self, fn(byte, acc) { acc * 256 + byte }, 0)
// }

// pub fn prove_burn(
//   burn_ints: List<Int>,
//   burn_names: List<ByteArray>,
//   burn_proofs: List<ByteArray>,
// ) -> Bool {
//   let outcomes =
//     list.map3(
//       burn_ints,
//       burn_names,
//       burn_proofs,
//       fn(i, n, p) {
//         let num_hash = int_to_hash(powmod(types.g, i, types.q))
//         let combined = bytearray.concat(num_hash, p)
//         // create the hash and modulo and cant be zero
//         hash.sha3_256(combined) == n && i > 1 && i < types.q
//       },
//     )
//   list.all(outcomes, fn(n) { n == True })
// }

// pub fn prove_mint(mint_ints: List<Int>, mint_names: List<ByteArray>) -> Bool {
//   // its ahrd to find n % i so do n % i % qq instead
//   let outcomes =
//     list.map2(
//       mint_ints,
//       mint_names,
//       fn(i, n) {
//         to_int(n) % powmod(types.g, i, types.q) % types.qq == 0 && i > 1 && i < types.q
//       },
//     )
//   list.all(outcomes, fn(n) { n == True })
// }

// // do the mod at each multiplication
// pub fn powmod(self: Int, e: Int, q: Int) -> Int {
//   if e < 0 {
//     0
//   } else if e == 0 {
//     1
//   } else if e % 2 == 0 {
//     powmod(self * self % q, e / 2, q) % q
//   } else {
//     self * powmod(self * self % q, ( e - 1 ) / 2, q) % q
//   }
// }

// pub fn list_power_mod(lst: List<Int>) -> Int {
//   list.foldr(lst, fn(n, total) { total * powmod(types.g, n, types.q) }, 1) % types.q
// }
