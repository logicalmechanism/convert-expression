// use aiken/transaction.{OutputReference, TransactionId}
// use aiken/transaction/value
// use hidden_contract/helper
// use hidden_contract/inject_validator
// use hidden_contract/types.{InjectData}
// use tests/inject_tx

// test good_complex_inject() {
//   let script_addr =
//     helper.create_script_address(#"", #"")
//   let mint_value =
//     value.add(
//       value.from_asset(
//         #"acab",
//         #"4179f53eeff366272337cce5e51a4b599c6cd3396b5e675d742d33e551c963fa",
//         1,
//       ),
//       value.add(
//         value.from_asset(
//           #"acab",
//           #"74de2d45700c572d474e08416dba5bad5123c33e25dd0a677bba9fc696a2676a",
//           1,
//         ),
//         value.from_asset(
//           #"acab",
//           #"2cc3371c6ef99a891866b8eb4741adda9e18b91c09d690f7272389a0d3047cd2",
//           -1,
//         ),
//       ),
//     )
//   let tx =
//     inject_tx.inject_tx(
//       script_addr,
//       script_addr,
//       value.from_lovelace(16000000),
//       mint_value,
//     )
//   let output_reference =
//     OutputReference {
//       transaction_id: TransactionId { hash: #"" },
//       output_index: 0,
//     }
//   let validating_input =
//     helper.get_validating_input(tx.inputs, output_reference)
//   let redeemer =
//     InjectData {
//       burn_constant: 128,
//       mint_ints: [234, 885],
//       mint_names: [
//         #"4179f53eeff366272337cce5e51a4b599c6cd3396b5e675d742d33e551c963fa",
//         #"74de2d45700c572d474e08416dba5bad5123c33e25dd0a677bba9fc696a2676a",
//       ],
//       inject: 15000000,
//       mint_constant: 474,
//       burn_ints: [1226],
//       burn_names: [
//         #"2cc3371c6ef99a891866b8eb4741adda9e18b91c09d690f7272389a0d3047cd2",
//       ],
//       burn_proofs: [
//         #"157f561b70cecf3c3877dd9b85db189b36f12b001ef0226cf1b2ed093fa999e6",
//       ],
//     }
//   inject_validator.inject_validation(redeemer, tx, validating_input, #"acab") == True
// }

// test good_simple_inject() {
//   let script_addr =
//     helper.create_script_address(#"", #"")
//   let mint_value =
//     value.add(
//       value.from_asset(
//         #"acab",
//         #"fb4ac62088f136d4002dd9549c7169f9fa07d1f7a4c3310f620803cd27cd801c",
//         1,
//       ),
//       value.from_asset(
//         #"acab",
//         #"910f2137cc7d13a00e35c142ff64a8c409c998cc7275eef2c91a99eb144290e0",
//         1,
//       ),
//     )
//   let tx =
//     inject_tx.inject_tx(
//       script_addr,
//       script_addr,
//       value.from_lovelace(31000000),
//       mint_value,
//     )
//   let output_reference =
//     OutputReference {
//       transaction_id: TransactionId { hash: #"" },
//       output_index: 0,
//     }
//   let validating_input =
//     helper.get_validating_input(tx.inputs, output_reference)
//   let redeemer =
//     InjectData {
//       burn_constant: 1570,
//       mint_ints: [1084, 368],
//       mint_names: [
//         #"fb4ac62088f136d4002dd9549c7169f9fa07d1f7a4c3310f620803cd27cd801c",
//         #"910f2137cc7d13a00e35c142ff64a8c409c998cc7275eef2c91a99eb144290e0",
//       ],
//       inject: 30000000,
//       mint_constant: 1610,
//       burn_ints: [],
//       burn_names: [],
//       burn_proofs: [],
//     }
//   inject_validator.inject_validation(redeemer, tx, validating_input, #"acab") == True
// }

// test bad_pid_simple_inject() {
//   let script_addr =
//     helper.create_script_address(#"", #"")
//   let mint_value =
//     value.add(
//       value.from_asset(
//         #"acab",
//         #"fb4ac62088f136d4002dd9549c7169f9fa07d1f7a4c3310f620803cd27cd801c",
//         1,
//       ),
//       value.from_asset(
//         #"acab",
//         #"910f2137cc7d13a00e35c142ff64a8c409c998cc7275eef2c91a99eb144290e0",
//         1,
//       ),
//     )
//   let tx =
//     inject_tx.inject_tx(
//       script_addr,
//       script_addr,
//       value.from_lovelace(31000000),
//       mint_value,
//     )
//   let output_reference =
//     OutputReference {
//       transaction_id: TransactionId { hash: #"" },
//       output_index: 0,
//     }
//   let validating_input =
//     helper.get_validating_input(tx.inputs, output_reference)
//   let redeemer =
//     InjectData {
//       burn_constant: 1570,
//       mint_ints: [1084, 368],
//       mint_names: [
//         #"fb4ac62088f136d4002dd9549c7169f9fa07d1f7a4c3310f620803cd27cd801c",
//         #"910f2137cc7d13a00e35c142ff64a8c409c998cc7275eef2c91a99eb144290e0",
//       ],
//       inject: 30000000,
//       mint_constant: 1610,
//       burn_ints: [],
//       burn_names: [],
//       burn_proofs: [],
//     }
//   inject_validator.inject_validation(redeemer, tx, validating_input, #"beef") == False
// }
