use aiken/list
use aiken/transaction.{Input, Transaction}
use aiken/transaction/value.{PolicyId}
use hidden_contract/helper
use hidden_contract/types.{ExtractData}

pub fn extract_validation(
  redeemer: ExtractData,
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
  let extraction =
    value.from_lovelace(redeemer.extract)
  // have to use reduced value
  let reduced_extract =
    redeemer.extract / 1000000
  let public_constant =
    helper.powmod(types.g, types.r + types.c * reduced_extract, types.q)
  let cont_value =
    value.add(validating_value, value.negate(extraction))
  // do the right and left constants
  let left_constant =
    helper.powmod(types.g, types.r * ( redeemer.mint_constant + 1 ), types.q)
  let right_constant =
    helper.powmod(types.g, types.r * redeemer.burn_constant, types.q)
  let leftside =
    list.push(redeemer.burn_ints, left_constant)
  let rightside0 =
    list.push(redeemer.mint_ints, right_constant)
  let rightside =
    list.push(rightside0, public_constant)
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
      // everything being minted must be minted
      list.all(
        redeemer.mint_names,
        fn(n) { helper.correct_mint(mint, pid, n, 1) == True },
      ),
      // everything burned must be burned
      list.all(
        redeemer.burn_names,
        fn(n) { helper.correct_mint(mint, pid, n, -1) == True },
      ),
      // all mints need ints
      list.length(redeemer.mint_ints) == list.length(redeemer.mint_names),
      // all burns needs ints
      list.length(redeemer.burn_ints) == burn_name_length,
      // must burn something to extract value
      burn_name_length >= 1,
      // all burns must have proofs
      burn_name_length == list.length(redeemer.burn_proofs),
      // no mint or burn is unaccounted
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
      // single script input
      helper.count_script_inputs(tx.inputs, script_addr, 0) == 1,
      // single script output
      helper.count_script_outputs(tx.outputs, script_addr, 0) == 1,
      // the extract amount needs to be an integer
      reduced_extract * 1000000 == redeemer.extract,
    ],
  )
}
