use aiken/list
use aiken/transaction/value.{MintedValue, PolicyId}
use assist/maths
use convert_expression/minting
use convert_expression/types.{InjectData}

pub fn inject_mint_validation(
  mint_value: MintedValue,
  redeemer: InjectData,
  pid: PolicyId,
) {
  let mint =
    mint_value
      |> value.from_minted_value()
      |> value.flatten()
  // calculate length at most 1 time
  let mint_name_length = list.length(redeemer.mint_names)
  let burn_name_length = list.length(redeemer.burn_names)
  // everything being minted is minted
  list.and(
    [
      // everything being minted is minted
      list.all(
        redeemer.mint_names,
        fn(n) { minting.correct_mint(mint, pid, n, 1) == True },
      )?,
      // everything being burned is burned
      list.all(
        redeemer.burn_names,
        fn(n) { minting.correct_mint(mint, pid, n, -1) == True },
      )?,
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
      minting.prove_mint(redeemer.mint_ints, redeemer.mint_names),
      // prove correct burn names
      minting.prove_burn(
        redeemer.burn_ints,
        redeemer.burn_names,
        redeemer.burn_proofs,
      ),
      // must inject at least 1 ADA into the contract
      redeemer.inject >= mint_name_length * 1000000,
    ],
  )
}

pub fn inject_math_validation(redeemer: InjectData) -> Bool {
  // this includes mint and burned tokens
  let public_constant = types.r + types.c * redeemer.inject
  // do the right and left constants
  let left_constant = types.r * ( redeemer.burn_constant + 1 )
  let right_constant = types.r * redeemer.mint_constant
  // create the left side and right side lists
  let leftside = list.push(redeemer.mint_ints, left_constant)
  let rightside0 = list.push(redeemer.burn_ints, right_constant)
  let rightside = list.push(rightside0, public_constant)
  list.and(
    [
      // mint and burn constant check
      redeemer.mint_constant < types.q,
      redeemer.burn_constant < types.q,
      // transformation equation
      maths.list_powmod(leftside, types.g, types.q) == maths.list_powmod(
        rightside,
        types.g,
        types.q,
      ),
    ],
  )
}
