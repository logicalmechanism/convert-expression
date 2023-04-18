use hidden_contract/helper
use hidden_contract/mint_validator
use tests/mint_tx

test good_mint_validation() {
  // The correct script is being spent from and the token being minted comes
  // from the the minting policy
  let script_addr =
    helper.create_script_address(#"acab", #"")
  let context =
    mint_tx.mint_context(script_addr, #"beef")
  mint_validator.validation(context, script_addr) == True
}

test bad_script_address() {
  let script_addr =
    helper.create_script_address(#"", #"")
  let out_addr =
    helper.create_script_address(#"acab", #"")
  let context =
    mint_tx.mint_context(script_addr, #"beef")
  mint_validator.validation(context, out_addr) == False
}

test bad_mint_pid() {
  let script_addr =
    helper.create_script_address(#"", #"")
  let context =
    mint_tx.mint_context(script_addr, #"acab")
  mint_validator.validation(context, script_addr) == False
}
