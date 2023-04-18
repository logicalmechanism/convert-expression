use aiken/dict
use aiken/interval.{Interval, IntervalBound, NegativeInfinity, PositiveInfinity}
use aiken/transaction.{
  InlineDatum, Input, NoDatum, Output, OutputReference, Transaction,
  TransactionId,
}
use aiken/transaction/credential.{Address}
use aiken/transaction/value.{Value}
use hidden_contract/types.{Datum}

pub fn datum_a() -> Datum {
  let pid =
    #"acab"
  Datum { pid }
}

pub fn extract_tx(
  script_input_addr: Address,
  script_output_addr: Address,
  output_value: Value,
  mint_value: Value,
) -> Transaction {
  let tx =
    Transaction {
      inputs: [
        Input {
          output_reference: OutputReference {
            transaction_id: TransactionId { hash: #"" },
            output_index: 0,
          },
          output: Output {
            address: script_input_addr,
            value: value.from_lovelace(150000000),
            datum: InlineDatum(datum_a()),
            reference_script: None,
          },
        },
      ],
      reference_inputs: [],
      outputs: [
        Output {
          address: script_output_addr,
          value: output_value,
          datum: NoDatum,
          reference_script: None,
        },
      ],
      fee: value.zero(),
      mint: mint_value,
      certificates: [],
      withdrawals: dict.new(),
      validity_range: Interval {
        lower_bound: IntervalBound {
          bound_type: NegativeInfinity,
          is_inclusive: True,
        },
        upper_bound: IntervalBound {
          bound_type: PositiveInfinity,
          is_inclusive: True,
        },
      },
      extra_signatories: [],
      redeemers: dict.new(),
      datums: dict.new(),
      id: TransactionId { hash: #"" },
    }
  tx
}
