use aiken/list
use aiken/transaction.{Input, Transaction}
use aiken/transaction/value.{PolicyId}
use assist/maths
use convert_expression/helper
use convert_expression/types.{ConvertData}

pub fn extract_validation(
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
      -1 * redeemer.syringe,
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
  let mint_name_length = list.length(redeemer.left_names)
  let burn_name_length = list.length(redeemer.right_names)
  // calculate the power mods
  let powmod_leftside = maths.list_powmod(complete_leftside, types.g, types.q)
  let powmod_rightside = maths.list_powmod(complete_rightside, types.g, types.q)
  True
  // list.and(
  //   [
  //     // mint and burn constant check
  //     (redeemer.mint_constant < types.q)?,
  //     (redeemer.burn_constant < types.q)?,
  //     // transformation equation
  //     (helper.list_power_mod(leftside) == helper.list_power_mod(rightside))?,
  //     // conservation equation
  //     helper.find_exact_payout(script_addr, cont_value, tx.outputs)?,
  //     // everything being minted must be minted
  //     list.all(
  //       redeemer.mint_names,
  //       fn(n) { helper.correct_mint(mint, pid, n, 1) == True },
  //     )?,
  //     // everything burned must be burned
  //     list.all(
  //       redeemer.burn_names,
  //       fn(n) { helper.correct_mint(mint, pid, n, -1) == True },
  //     )?,
  //     // all mints need ints
  //     list.length(redeemer.mint_ints) == list.length(redeemer.mint_names),
  //     // all burns needs ints
  //     list.length(redeemer.burn_ints) == burn_name_length,
  //     // must burn something to extract value
  //     burn_name_length >= 1,
  //     // all burns must have proofs
  //     burn_name_length == list.length(redeemer.burn_proofs),
  //     // no mint or burn is unaccounted
  //     list.length(mint) == list.length(
  //       list.concat(redeemer.mint_names, redeemer.burn_names),
  //     ),
  //     // prove correct mints names
  //     helper.prove_mint(redeemer.mint_ints, redeemer.mint_names)?,
  //     // prove correct burn names
  //     helper.prove_burn(
  //       redeemer.burn_ints,
  //       redeemer.burn_names,
  //       redeemer.burn_proofs,
  //     )?,
  //     // single script input
  //     helper.count_script_inputs(tx.inputs, script_addr, 0) == 1,
  //     // single script output
  //     helper.count_script_outputs(tx.outputs, script_addr, 0) == 1,
  //   ],
  // )
}
