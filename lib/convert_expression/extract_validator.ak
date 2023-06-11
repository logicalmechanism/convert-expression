use aiken/list
use aiken/transaction/value.{MintedValue, PolicyId}
use assist/maths
use convert_expression/minting
use convert_expression/types.{ExtractData}

pub fn extract_mint_validation(
  mint_value: MintedValue,
  redeemer: ExtractData,
  pid: PolicyId,
) {
  let mint =
    mint_value
      |> value.from_minted_value()
      |> value.flatten()
  // calculate length at most 1 time
  let burn_name_length = list.length(redeemer.burn_names)
  list.and(
    [
      // everything being minted must be minted
      list.all(
        redeemer.mint_names,
        fn(n) { minting.correct_mint(mint, pid, n, 1) == True },
      )?,
      // everything burned must be burned
      list.all(
        redeemer.burn_names,
        fn(n) { minting.correct_mint(mint, pid, n, -1) == True },
      )?,
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
      minting.prove_mint(redeemer.mint_ints, redeemer.mint_names)?,
      // prove correct burn names
      minting.prove_burn(
        redeemer.burn_ints,
        redeemer.burn_names,
        redeemer.burn_proofs,
      )?,
    ],
  )
}

pub fn extract_math_validation(redeemer: ExtractData) -> Bool {
  let public_constant = types.r + types.c * redeemer.extract
  // do the right and left constants
  let left_constant = types.r * ( redeemer.mint_constant + 1 )
  let right_constant = types.r * redeemer.burn_constant
  // create the left side and right side lists
  let leftside = list.push(redeemer.burn_ints, left_constant)
  let rightside0 = list.push(redeemer.mint_ints, right_constant)
  let rightside = list.push(rightside0, public_constant)
  list.and(
    [
      // mint and burn constant check
      redeemer.mint_constant < types.q,
      redeemer.burn_constant < types.q,
      // transformation equation
      (maths.list_powmod(leftside, types.g, types.q) == maths.list_powmod(
        rightside,
        types.g,
        types.q,
      ))?,
    ],
  )
}
