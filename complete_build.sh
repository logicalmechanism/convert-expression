#!/bin/bash
set -e

mkdir -p contracts
mkdir -p hashes

rm contracts/* || True
rm hashes/* || True

# build out the entire script
echo -e "\033[1;34m\nBuilding Contracts\n\033[0m"
# aiken build
aiken build --keep-traces

# the reference token
pid=$(jq -r '.starterPid' ./start_info.json)
tkn=$(jq -r '.starterTkn' ./start_info.json)

pid_cbor=$(python3 ./convert_to_cbor.py ${pid})
tkn_cbor=$(python3 ./convert_to_cbor.py ${tkn})

# build the lock contract
echo -e "\033[1;33m\nConvert Lock Contract \033[0m"
aiken blueprint apply -o plutus.json -v locker.params "${pid_cbor}" .
aiken blueprint apply -o plutus.json -v locker.params "${tkn_cbor}" .
aiken blueprint convert -v locker.params > contracts/lock_contract.plutus

cardano-cli transaction policyid --script-file contracts/lock_contract.plutus > hashes/lock.hash

echo -e "\033[1;36mLock Contract Hash: $(cat hashes/lock.hash) \033[0m"

ref=$(cat hashes/lock.hash)
ref_cbor=$(python3 ./convert_to_cbor.py ${ref})

# build the mint contract
echo -e "\033[1;33m\nConvert Mint Contract \033[0m"
aiken blueprint apply -o plutus.json -v minter.params "${ref_cbor}" .
aiken blueprint convert -v minter.params > contracts/mint_contract.plutus
cardano-cli transaction policyid --script-file contracts/mint_contract.plutus > hashes/policy.hash

# update the datum file for the starter token
pid=$(cat hashes/policy.hash)
echo -e "\033[1;36mMint Contract Policy: $(cat hashes/policy.hash) \033[0m"

jq \
--arg pid "$pid" \
'.fields[0].bytes=$pid' \
./scripts/data/datum.json | sponge ./scripts/data/datum.json

echo -e "\033[1;32m\nBuild Complete! \033[0m"
