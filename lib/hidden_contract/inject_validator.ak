use aiken/list
use aiken/transaction.{Input, Transaction}
use aiken/transaction/value.{PolicyId}
use hidden_contract/helper
use hidden_contract/types.{InjectData}

pub fn inject_validation(
  redeemer: InjectData,
  tx: Transaction,
  validating_input: Input,
  pid: PolicyId,
) -> Bool {
  let validating_value =
    validating_input.output.value
  let script_addr =
    validating_input.output.address
  // this includes mint and burned tokens
  let mint =
    tx.mint
      |> value.without_lovelace()
      |> value.flatten()
  let injection =
    value.from_lovelace(redeemer.inject)
  // doing the real value will take too long
  let reduced_inject =
    redeemer.inject / 1000000
  let public_constant =
    helper.powmod(types.g, types.r + types.c * reduced_inject, types.q)
  // add whats being validated to the injected amt
  let cont_value =
    value.add(validating_value, injection)
  // do the right and left constants
  let left_constant =
    helper.powmod(types.g, types.r * ( redeemer.burn_constant + 1 ), types.q)
  let right_constant =
    helper.powmod(types.g, types.r * redeemer.mint_constant, types.q)
  let leftside =
    list.push(redeemer.mint_ints, left_constant)
  let rightside0 =
    list.push(redeemer.burn_ints, right_constant)
  let rightside =
    list.push(rightside0, public_constant)
  let mint_name_length =
    list.length(redeemer.mint_names)
  let burn_name_length =
    list.length(redeemer.burn_names)
  list.and(
    [
      // mint and burn constant check
      redeemer.mint_constant < types.q,
      redeemer.burn_constant < types.q,
      // transformation equation
      helper.list_pow_mod(leftside) == helper.list_pow_mod(rightside),
      // conservation equation
      helper.find_exact_payout(script_addr, cont_value, tx.outputs),
      // everything being minted is minted
      list.all(
        redeemer.mint_names,
        fn(n) { helper.correct_mint(mint, pid, n, 1) == True },
      ),
      // everything being burned is burned
      list.all(
        redeemer.burn_names,
        fn(n) { helper.correct_mint(mint, pid, n, -1) == True },
      ),
      // logical mints and burns
      list.length(redeemer.mint_ints) == mint_name_length,
      // logical mints and burns
      list.length(redeemer.burn_ints) == burn_name_length,
      // all burns must have proofs
      burn_name_length == list.length(redeemer.burn_proofs),
      // injections required at least 2 mints
      mint_name_length >= 2,
      // cant hind mints or burns
      list.length(mint) == list.length(
        list.concat(redeemer.mint_names, redeemer.burn_names),
      ),
      // prove correct mints names
      helper.prove_mint(redeemer.mint_ints, redeemer.mint_names),
      // prove correct burn names
      helper.prove_burn(
        redeemer.burn_ints,
        redeemer.burn_names,
        redeemer.burn_proofs,
      ),
      // only spend 1 input
      helper.count_script_inputs(tx.inputs, script_addr, 0) == 1,
      // only cont 1 output
      helper.count_script_outputs(tx.outputs, script_addr, 0) == 1,
      // must inject at least 1 ADA into the contract
      redeemer.inject >= mint_name_length * 2000000,
      // must have integer amount of ADA
      reduced_inject * 1000000 == redeemer.inject,
    ],
  )
}
