use aiken/list
use aiken/transaction.{Mint, ScriptContext}
use aiken/transaction/credential.{Address}
use aiken/transaction/value
use hidden_contract/helper

pub fn validation(context: ScriptContext, script_addr: Address) -> Bool {
  when context.purpose is {
    // only allowed to mint
    Mint(own_currency_symbol) -> {
      let tx =
        context.transaction
      // get just the policies of minted tokens
      let mint =
        tx.mint
          |> value.without_lovelace()
          |> value.policies()
      list.and(
        [
          // must be spending something from lock script
          helper.count_script_inputs(tx.inputs, script_addr, 0) == 1,
          // everything being minted must come from this policy
          list.all(mint, fn(n) { n == own_currency_symbol }),
        ],
      )
    }
    // Everything else fails
    _ ->
      False
  }
}
