#!/bin/bash
set -e

if [[ $# -lt 2 ]] ; then
    echo 'Please Supply A Extract Amount and Mint Amount'
    echo './03_extractADA.sh 10000000 4'
    exit 1
fi

if [ "$1" -lt 0 ]; then
    echo 'Extract Value Must Be Greater Than 1 ADA'
    exit 1
fi

if [ "$2" -lt 0 ]; then
    echo 'Must Mint At Least Two Tokens'
    exit 1
fi
source .env

extract_value=$1

# reduced_extract="$((${extract_value} / 1000000))"

hidden_pid=$(cat ../hashes/policy.hash)

echo "Calculating Token Names"
rm ./utxos/pending/* || true
redeemer_path="./data/extract_redeemer.json"
python3 -c "from py.create_extract_redeemer import create_redeemer;create_redeemer(${extract_value}, ${2}, '${redeemer_path}')"

# script info
script_path="../contracts/lock_contract.plutus"
script_address=$(${cli} address build --payment-script-file ${script_path} ${network})

# seller
seller_address=$(cat wallets/seller-wallet/payment.addr)
seller_pkh=$(${cli} address key-hash --payment-verification-key-file wallets/seller-wallet/payment.vkey)

# collateral
collat_address=$(cat wallets/collat-wallet/payment.addr)
collat_pkh=$(${cli} address key-hash --payment-verification-key-file wallets/collat-wallet/payment.vkey)

# a payout for the extract
if [ "${extract_value}" -eq 0 ]; then    
    extract_address_out="${seller_address} + 1000000"
else
    extract_address_out="${seller_address} + ${extract_value}"
fi
echo -e "\nExtract OUTPUT: "${extract_address_out}

# starter asset
pid=$(jq -r '.starterPid' ../start_info.json)
tkn=$(jq -r '.starterTkn' ../start_info.json)
asset="1 ${pid}.${tkn}"

echo -e "\033[0;36m Gathering Script UTxO Information  \033[0m"
${cli} query utxo \
    --address ${script_address} \
    ${network} \
    --out-file tmp/script_utxo.json

# transaction variables
TXNS=$(jq length tmp/script_utxo.json)
if [ "${TXNS}" -eq "0" ]; then
   echo -e "\n \033[0;31m NO UTxOs Found At ${script_address} \033[0m \n";
   exit;
fi
alltxin=""
TXIN=$(jq -r --arg alltxin "" --arg pid "${pid}" --arg tkn "${tkn}" 'to_entries[] | select(.value.value[$pid][$tkn] == 1) | .key | . + $alltxin + " --tx-in"' tmp/script_utxo.json)
script_tx_in=${TXIN::-8}

CURRENT_VALUE=$(jq -r --arg pid "${pid}" --arg tkn "${tkn}" 'to_entries[] | select(.value.value[$pid][$tkn] == 1) | .value.value.lovelace' tmp/script_utxo.json)
cont_value=$((${CURRENT_VALUE} - ${extract_value}))
script_address_out="${script_address} + ${cont_value} + ${asset}"
echo -e "\nScript OUTPUT: "${script_address_out}


# new incoming assets
mint_assets=$(python3 -c "from py.create_mint_str import get_mint_string;get_mint_string('${hidden_pid}')")
burn_assets=$(python3 -c "from py.create_mint_str import get_burn_string;get_burn_string('${hidden_pid}')")

echo -e "\nMinting: " $mint_assets

echo -e "\nBurning: " $burn_assets

new_assets="${mint_assets} + ${burn_assets}"

# echo "Mint and Burning:" $new_assets

echo -e "\033[0;36m Gathering Seller UTxO Information  \033[0m"
${cli} query utxo \
    ${network} \
    --address ${seller_address} \
    --out-file tmp/seller_utxo.json
TXNS=$(jq length tmp/seller_utxo.json)
if [ "${TXNS}" -eq "0" ]; then
   echo -e "\n \033[0;31m NO UTxOs Found At ${seller_address} \033[0m \n";
   exit;
fi
alltxin=""
TXIN=$(jq -r --arg alltxin "" 'keys[] | . + $alltxin + " --tx-in"' tmp/seller_utxo.json)
seller_tx_in=${TXIN::-8}

change_assets=$(python3 -c "from py.create_mint_str import get_change_string;get_change_string()")
# echo $change_assets

if [ -z "$change_assets" ]; then
    return_assets="${mint_assets}"

else
    return_assets="${mint_assets} + ${change_assets}"
fi

# echo $return_assets

utxo_value=$(${cli} transaction calculate-min-required-utxo \
    --babbage-era \
    --protocol-params-file tmp/protocol.json \
    --tx-out="${seller_address} + 5000000 + ${return_assets}" | tr -dc '0-9')

seller_address_out="${seller_address} + ${utxo_value} + ${return_assets}"
echo -e "\nMint OUTPUT: "${seller_address_out}

#
# exit
#

echo -e "\033[0;36m Gathering Collateral UTxO Information  \033[0m"
${cli} query utxo \
    ${network} \
    --address ${collat_address} \
    --out-file tmp/collat_utxo.json
TXNS=$(jq length tmp/collat_utxo.json)
if [ "${TXNS}" -eq "0" ]; then
   echo -e "\n \033[0;31m NO UTxOs Found At ${collat_address} \033[0m \n";
   exit;
fi
collat_utxo=$(jq -r 'keys[0]' tmp/collat_utxo.json)

script_ref_utxo=$(${cli} transaction txid --tx-file tmp/tx-reference-utxo.signed)

echo -e "\033[0;36m Building Tx \033[0m"
FEE=$(${cli} transaction build \
    --babbage-era \
    --protocol-params-file tmp/protocol.json \
    --out-file tmp/tx.draft \
    --change-address ${seller_address} \
    --tx-in-collateral="${collat_utxo}" \
    --tx-in ${seller_tx_in} \
    --tx-in ${script_tx_in} \
    --spending-tx-in-reference="${script_ref_utxo}#1" \
    --spending-plutus-script-v2 \
    --spending-reference-tx-in-inline-datum-present \
    --spending-reference-tx-in-redeemer-file data/extract_redeemer.json \
    --tx-out="${seller_address_out}" \
    --tx-out="${extract_address_out}" \
    --tx-out="${script_address_out}" \
    --tx-out-inline-datum-file data/datum.json  \
    --mint="${new_assets}" \
    --mint-tx-in-reference="${script_ref_utxo}#2" \
    --mint-plutus-script-v2 \
    --policy-id="${hidden_pid}" \
    --mint-reference-tx-in-redeemer-file data/minter_redeemer.json \
    --required-signer-hash ${seller_pkh} \
    --required-signer-hash ${collat_pkh} \
    ${network})

IFS=':' read -ra VALUE <<< "${FEE}"
IFS=' ' read -ra FEE <<< "${VALUE[1]}"
FEE=${FEE[1]}
echo -e "\033[1;32m Fee: \033[0m" $FEE
#
# exit
#
echo -e "\033[0;36m Signing \033[0m"
${cli} transaction sign \
    --signing-key-file wallets/seller-wallet/payment.skey \
    --signing-key-file wallets/collat-wallet/payment.skey \
    --tx-body-file tmp/tx.draft \
    --out-file tmp/tx.signed \
    ${network}
#    
# exit
#
echo -e "\033[0;36m Submitting \033[0m"
${cli} transaction submit \
    ${network} \
    --tx-file tmp/tx.signed

python3 -c "from py.create_mint_str import remove_spent;remove_spent()"
cp utxos/pending/* utxos/owned/