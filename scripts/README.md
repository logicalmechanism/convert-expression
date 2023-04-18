# Test Scripts

The scripts are designed to be automated. First create the contract reference UTxO then create the starter token known at compile time. This starter token is assumed to be a unique and unreproducible. Users can then inject or extract from the contract by minting and burning.

This contract assumes some wallets exist inside the wallet folder. You can create test wallets with `create_wallet.sh` script. It takes in the path to the new wallet and auto creates the wallet.

### Wallet Prep

Inside the scripts folder there is a folder called `wallets/` and a file called `create_wallets.sh`. Run these commands.

```bash
./create_wallet.sh wallets/seller-wallet
./create_wallet.sh wallets/reference-wallet
./create_wallet.sh wallets/collat-wallet
```

This will create the three wallets required to use this. Just send some tADA to the address in `payment.addr` file in each wallet subfolder. The `tradeToken.sh` script can be used to send funds around.

## Contract Interaction

To inject ADA

```bash
./02_injectADA.sh ${lovelaceAmount} ${mintAmount}
```

where the lovelaceAmount is some integer and whole number of lovelace and the mintAmount is the number of tokens to be minted, it must be more than 1. This will populate the `utxo/owned` folder with secrets to the tokens being minted. This token information is required for a burn to occur. 

To extract ADA

```bash
./03_extractADA.sh ${lovelaceAmount} ${mintAmount}
```

This will extract some amount of lovelace from the contract and mint the change into a mintAmount number of tokens.


## Example

Inject 25 ADA and mint 3 tokens.

```bash
./02_injectADA.sh 25000000 3
```

Extract 15 ADA and mint 5 tokens.

```bash
./03_extractADA.sh 15000000 5
```

The token information generated from these transactions will have the form to something like this example information below.

```json
{
    "value": 11,
    "first_secret": 904487987657883,
    "public_number": 63449245955384197,
    "second_secret": "bbb23e815f26d93afd753b79c81d707a384d03641a9b137edb390171c2951b00",
    "token_name": "3ff7b2d403e32dedf3336cd10dee42b6fad697725a7512d4c294327e54aa90fd"
}
```

`Losing the token information renders that token useless.`