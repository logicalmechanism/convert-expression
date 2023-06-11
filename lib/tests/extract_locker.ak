use aiken/list
use aiken/transaction/value
use assist/addresses
use convert_expression/extract_validator
use convert_expression/types.{ExtractData}
use tests/extract_tx

test good_simple_extract() {
  let script_addr = addresses.create_script_address(#"", #"")
  let mint_value =
    value.from_asset(
      #"acab",
      #"7abf1f78c5a5cf5ae4a8b3d43d31d46d34ec7924ae1ff1bef26b7305135d9bb0",
      -1,
    )
      |> value.merge(
           value.from_asset(
             #"acab",
             #"815ea4e9a055e6ce9d6f2112234462f1fa57e7dd23dc17ff176b4e48a5704a9e",
             1,
           ),
         )
      |> value.merge(
           value.from_asset(
             #"acab",
             #"057e62f5e8ccab99f0d74eea003c0b93095d32c75625ee1b4302f44c8c74bcf0",
             1,
           ),
         )
      |> value.to_minted_value()

  let tx =
    extract_tx.extract_tx(
      script_addr,
      script_addr,
      value.from_lovelace(130000000),
      mint_value,
    )
  let redeemer =
    ExtractData {
      mint_constant: 387,
      burn_ints: [664],
      burn_names: [
        #"7abf1f78c5a5cf5ae4a8b3d43d31d46d34ec7924ae1ff1bef26b7305135d9bb0",
      ],
      burn_proofs: [
        #"f41196cca15bc3d7e1026f5827c838b10519ba74c346a1727381bb40db7f376d",
      ],
      extract: 20000000,
      burn_constant: 1539,
      mint_ints: [23, 451],
      mint_names: [
        #"815ea4e9a055e6ce9d6f2112234462f1fa57e7dd23dc17ff176b4e48a5704a9e",
        #"057e62f5e8ccab99f0d74eea003c0b93095d32c75625ee1b4302f44c8c74bcf0",
      ],
    }
  list.and(
    [
      extract_validator.extract_math_validation(redeemer) == True,
      extract_validator.extract_mint_validation(tx.mint, redeemer, #"acab") == True,
    ],
  )
}

test bad_pid_simple_extract() {
  let script_addr = addresses.create_script_address(#"", #"")
  let mint_value =
    value.from_asset(
      #"acab",
      #"7abf1f78c5a5cf5ae4a8b3d43d31d46d34ec7924ae1ff1bef26b7305135d9bb0",
      -1,
    )
      |> value.merge(
           value.from_asset(
             #"acab",
             #"815ea4e9a055e6ce9d6f2112234462f1fa57e7dd23dc17ff176b4e48a5704a9e",
             1,
           ),
         )
      |> value.merge(
           value.from_asset(
             #"acab",
             #"057e62f5e8ccab99f0d74eea003c0b93095d32c75625ee1b4302f44c8c74bcf0",
             1,
           ),
         )
      |> value.to_minted_value()
  let tx =
    extract_tx.extract_tx(
      script_addr,
      script_addr,
      value.from_lovelace(130000000),
      mint_value,
    )
  let redeemer =
    ExtractData {
      mint_constant: 387,
      burn_ints: [664],
      burn_names: [
        #"7abf1f78c5a5cf5ae4a8b3d43d31d46d34ec7924ae1ff1bef26b7305135d9bb0",
      ],
      burn_proofs: [
        #"f41196cca15bc3d7e1026f5827c838b10519ba74c346a1727381bb40db7f376d",
      ],
      extract: 20000000,
      burn_constant: 1539,
      mint_ints: [23, 451],
      mint_names: [
        #"815ea4e9a055e6ce9d6f2112234462f1fa57e7dd23dc17ff176b4e48a5704a9e",
        #"057e62f5e8ccab99f0d74eea003c0b93095d32c75625ee1b4302f44c8c74bcf0",
      ],
    }
  list.and(
    [
      extract_validator.extract_math_validation(redeemer) == False,
      extract_validator.extract_mint_validation(tx.mint, redeemer, #"acab") == False,
    ],
  )
}
