use aiken/list
use aiken/transaction.{ScriptContext, Spend}
use aiken/transaction/value
use hidden_contract/extract_validator
use hidden_contract/helper
use hidden_contract/inject_validator
use hidden_contract/types.{Datum, Extract, Inject, LockRedeemer}

validator(starter_pid: ByteArray, starter_tkn: ByteArray) {
  fn params(
    datum: Datum,
    redeemer: LockRedeemer,
    context: ScriptContext,
  ) -> Bool {
    when context.purpose is {
      Spend(output_reference) -> {
        // used by both redeemers
        let tx =
          context.transaction
        let validating_input =
          helper.get_validating_input(tx.inputs, output_reference)
        let validating_value =
          validating_input.output.value
        // UTxO must hold the starter token
        let value_check =
          value.quantity_of(validating_value, starter_pid, starter_tkn) == 1
        expect cont_datum: Datum =
          helper.get_outbound_datum(tx, validating_input)
        when redeemer is {
          // add in ada into the contract
          Inject(inject_data) ->
            list.and(
              [
                // must hold starter nft
                value_check,
                // datum cant change
                datum == cont_datum,
                // other validation logic
                inject_validator.inject_validation(
                  inject_data,
                  tx,
                  validating_input,
                  datum.pid,
                ),
              ],
            )
          // take ada out of the contract
          Extract(extract_data) ->
            list.and(
              [
                // must hold starter nft
                value_check,
                // datum cant change
                datum == cont_datum,
                // other validation logic
                extract_validator.extract_validation(
                  extract_data,
                  tx,
                  validating_input,
                  datum.pid,
                ),
              ],
            )
        }
      }
      _ ->
        False
    }
  }
}
