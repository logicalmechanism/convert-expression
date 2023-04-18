use aiken/transaction.{ScriptContext}
use aiken/transaction/credential
use hidden_contract/mint_validator

validator(script_hash_data: Data) {
  fn params(_redeemer: Void, context: ScriptContext) -> Bool {
    expect script_hash: ByteArray =
      script_hash_data
    // assume script address is not staked
    let script_addr =
      credential.from_script(script_hash)
    // run the validation function
    mint_validator.validation(context, script_addr)
  }
}
