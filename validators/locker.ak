use aiken/list
use aiken/transaction.{ScriptContext, Spend}
use aiken/transaction/value
use assist/count
use assist/find
use assist/payout
use assist/values
use convert_expression/extract_validator
use convert_expression/inject_validator
use convert_expression/types.{Datum, Extract, Inject, LockRedeemer}

validator(starter_pid: ByteArray, starter_tkn: ByteArray) {
  fn params(
    datum: Datum,
    redeemer: LockRedeemer,
    context: ScriptContext,
  ) -> Bool {
    when context.purpose is {
      Spend(output_reference) -> {
        // This transaction being validated
        let tx = context.transaction
        let this_input = find.input_by_ref(tx.inputs, output_reference)
        let this_value = this_input.output.value
        let this_addr = this_input.output.address
        // UTxO must hold the starter token
        let value_check =
          values.prove_exact_nft(starter_pid, starter_tkn, this_value)
        expect cont_datum: Datum =
          find.output_datum_by_addr(tx.outputs, this_addr)
        // the value continuing to the contract
        when redeemer is {
          // add in ada into the contract
          Inject(inject_data) -> {
            let cont_value =
              value.merge(this_value, value.from_lovelace(inject_data.inject))
            list.and(
              [
                // must hold starter nft
                value_check,
                // datum cant change
                datum == cont_datum,
                // only spend 1 input
                count.inputs_by_addr(tx.inputs, this_addr, 1),
                // only cont 1 output
                count.outputs_by_addr(tx.outputs, this_addr, 1),
                // conservation equation
                payout.exact(this_addr, cont_value, tx.outputs),
                // math validation logic
                inject_validator.inject_math_validation(inject_data),
                // mint validation logic
                inject_validator.inject_mint_validation(
                  tx.mint,
                  inject_data,
                  datum.pid,
                ),
              ],
            )
          }

          // take ada out of the contract
          Extract(extract_data) -> {
            let cont_value =
              value.merge(
                this_value,
                value.from_lovelace(extract_data.extract) |> value.negate(),
              )
            list.and(
              [
                // must hold starter nft
                value_check,
                // datum cant change
                datum == cont_datum,
                // only spend 1 input
                count.inputs_by_addr(tx.inputs, this_addr, 1),
                // only cont 1 output
                count.outputs_by_addr(tx.outputs, this_addr, 1),
                // conservation equation
                payout.exact(this_addr, cont_value, tx.outputs),
                // other validation logic
                extract_validator.extract_math_validation(extract_data),
                // other validation logic
                extract_validator.extract_mint_validation(
                  tx.mint,
                  extract_data,
                  datum.pid,
                ),
              ],
            )
          }
        }
      }
      _ -> False
    }
  }
}
