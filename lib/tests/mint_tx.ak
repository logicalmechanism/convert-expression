use aiken/dict
use aiken/interval.{Interval, IntervalBound, NegativeInfinity, PositiveInfinity}
use aiken/transaction.{
  InlineDatum, Input, Mint, NoDatum, Output, OutputReference, ScriptContext,
  Transaction, TransactionId,
}
use aiken/transaction/credential.{Address}
use aiken/transaction/value.{MintedValue}
use assist/addresses
use convert_expression/types.{Datum}

pub fn datum_a() -> Datum {
  let pid = #"acab"
  Datum { pid }
}

pub fn mint_tx(
  script_input_addr: Address,
  output_addr: Address,
  output_value: MintedValue,
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
            value: value.from_lovelace(100),
            datum: InlineDatum(datum_a()),
            reference_script: None,
          },
        },
      ],
      reference_inputs: [],
      outputs: [
        Output {
          address: output_addr,
          value: output_value |> value.from_minted_value(),
          datum: NoDatum,
          reference_script: None,
        },
      ],
      fee: value.zero(),
      mint: output_value,
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

pub fn mint_context(script_addr: Address, pid: ByteArray) -> ScriptContext {
  let out_addr = addresses.create_address(#"", #"")
  ScriptContext {
    transaction: mint_tx(
      script_addr,
      out_addr,
      value.from_asset(#"beef", #"face", 1) |> value.to_minted_value(),
    ),
    purpose: Mint(pid),
  }
}
