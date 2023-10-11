use aiken/transaction.{Mint, ScriptContext}
use aiken/transaction/credential
use assist/count

validator(script_hash_data: Data) {
  fn params(_redeemer: Void, context: ScriptContext) -> Bool {
    expect script_hash: ByteArray = script_hash_data
    // assume script address is not staked
    let script_addr = credential.from_script(script_hash)
    // run the validation function
    when context.purpose is {
      // only allowed to mint
      Mint(_) ->
        // must be spending one thing from lock script
        count.inputs_by_addr(context.transaction.inputs, script_addr, 1)
      // Everything else fails
      _ -> False
    }
  }
}
