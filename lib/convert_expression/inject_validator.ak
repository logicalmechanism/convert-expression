use aiken/list
use aiken/transaction.{Input, Transaction}
use aiken/transaction/value.{PolicyId}
use assist/count
use assist/maths
use assist/minting
use assist/payout
use convert_expression/helper
use convert_expression/types.{ConvertData}

pub fn inject_validation(
  redeemer: ConvertData,
  tx: Transaction,
  this_input: Input,
  pid: PolicyId,
) -> Bool {
  let this_value = this_input.output.value
  let script_addr = this_input.output.address
  // this includes mint and burned tokens
  let mint =
    tx.mint
      |> value.from_minted_value()
      |> value.flatten()
  // the publicly known constant
  let public_constant = types.r + types.c * redeemer.syringe
  // add whats being validated to the injected amt
  let cont_value =
    value.add(
      this_value,
      value.ada_policy_id,
      value.ada_asset_name,
      redeemer.syringe,
    )
  // left side
  let left_constant_term = types.r * ( redeemer.left_constant + 1 )
  let complete_leftside = list.push(redeemer.left_ints, left_constant_term)
  // right side
  let right_constant_term = types.r * redeemer.right_constant
  let complete_rightside =
    list.push(redeemer.right_ints, right_constant_term)
      |> list.push(public_constant)
  // calculate length at most 1 time
  let left_name_length = list.length(redeemer.left_names)
  let right_name_length = list.length(redeemer.right_names)
  // calculate the power mods
  let powmod_leftside = maths.list_powmod(complete_leftside, types.g, types.q)
  let powmod_rightside = maths.list_powmod(complete_rightside, types.g, types.q)
  and {
    // mint and burn constant check
    redeemer.left_constant < types.q,
    redeemer.right_constant < types.q,
    // transformation equation
    powmod_leftside == powmod_rightside,
    // conservation equation
    payout.exact(script_addr, cont_value, tx.outputs),
    // everything being minted is minted
    list.all(
      redeemer.left_names,
      fn(n) { minting.exact(mint, pid, n, 1) == True },
    )?,
    // everything being burned is burned
    list.all(
      redeemer.right_names,
      fn(n) { minting.exact(mint, pid, n, -1) == True },
    )?,
    // logical mints and burns
    list.length(redeemer.left_ints) == left_name_length,
    // logical mints and burns
    list.length(redeemer.right_ints) == right_name_length,
    // all burns must have proofs
    right_name_length == list.length(redeemer.name_proofs),
    // injections required at least 2 mints
    left_name_length >= 2,
    // cant hide mints or burns
    list.length(mint) == list.length(
      list.concat(redeemer.left_names, redeemer.right_names),
    ),
    // prove correct mints names
    helper.prove_mint(redeemer.left_ints, redeemer.left_names),
    // prove correct burn names
    helper.prove_burn(
      redeemer.right_ints,
      redeemer.right_names,
      redeemer.name_proofs,
    ),
    // only cont 1 output
    count.outputs_by_addr(tx.outputs, script_addr, 1),
    // must inject at least 1 ADA into the contract
    redeemer.syringe >= left_name_length * 1000000,
  }
}
