use aiken/list
use aiken/transaction.{Mint, ScriptContext}
use aiken/transaction/credential.{Address}
use aiken/transaction/value
use assist/count

pub fn validation(context: ScriptContext, script_addr: Address) -> Bool {
  when context.purpose is {
    // only allowed to mint
    Mint(currency_symbol) -> {
      let tx = context.transaction
      // get just the policies of minted tokens
      let mint =
        tx.mint
          |> value.from_minted_value()
          |> value.policies()
      and {
        // must be spending one thing from lock script
        count.inputs_by_addr(tx.inputs, script_addr, 1),
        // everything being minted must come from this policy
        list.all(mint, fn(n) { n == currency_symbol }),
      }
    }
    // Everything else fails
    _ -> False
  }
}
