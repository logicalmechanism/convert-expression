use aiken/transaction.{ScriptContext, Spend}
use assist/find
use assist/values
use convert_expression/extract_validator
use convert_expression/inject_validator
use convert_expression/types.{Datum, Extract, Inject, Redeemer}

validator(start_pid: ByteArray, start_tkn: ByteArray) {
  fn params(datum: Datum, redeemer: Redeemer, context: ScriptContext) -> Bool {
    when context.purpose is {
      Spend(output_reference) -> {
        let tx = context.transaction
        let this_input = find.input_by_ref(tx.inputs, output_reference)
        let this_value = this_input.output.value
        let this_addr = this_input.output.address
        // UTxO must hold the start token
        let value_check =
          values.prove_exact_nft(start_pid, start_tkn, this_value)
        expect cont_datum: Datum =
          find.output_datum_by_addr(tx.outputs, this_addr)
        when redeemer is {
          // add in ada into the contract
          Inject(inject_data) -> and {
              // must hold starter nft
              value_check,
              // datum cant change
              datum == cont_datum,
              // other validation logic
              inject_validator.inject_validation(
                inject_data,
                tx,
                this_input,
                datum.pid,
              ),
            }
          // take ada out of the contract
          Extract(extract_data) -> and {
              // must hold starter nft
              value_check,
              // datum cant change
              datum == cont_datum,
              // other validation logic
              extract_validator.extract_validation(
                extract_data,
                tx,
                this_input,
                datum.pid,
              ),
            }
        }
      }
      // anything else fails
      _ -> False
    }
  }
}
