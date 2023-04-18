# Covert Expression

This contract is designed to mint or burns NFTs that satisfy the equations below. Each NFT represents a real value of ada that is hidden using a variation of Schnorr signatures. Under the correct parameters, values should remain hidden and be computationally difficult to reveal.

## Equations

The transformation equation

$$ g^{r (K_{i} + 1)} \prod_{j=0}^{M} g^{z_{j}} = g^{z_{b}} g^{rK_{j}} \prod_{i=0}^{N} g^{z_{i}} \mod q $$

where 

$$z_{b} = r + cb$$
$$z_{i} = r\lambda_{i} +c\alpha_{i}$$
$$z_{j} = r\lambda_{j} +c\alpha_{j}$$

$$K_{i} = \sum_{i=0}^{N} \lambda_{i}$$
$$K_{j} = \sum_{j=0}^{M} \lambda_{j}$$

The values $\lambda$ and $\alpha$ are secret. The equation represents different things depending on the flow direction. If funds are being injected into the contract then there will be M mints and N burns. Conversely, if funds are being extracted then there are M burns and N mints. The value being injected or extracted is always known. 

The conservation equation

$$g^{z_{x}} g^{z_{b}} = g^{r} g^{z_{y}} \mod q$$

where

$$z_{x} = r + cx$$
$$z_{y} = r + cy$$

The values x,y,and b are public. The values of x and y during an injection represent the funds currently inside the contract and the funds continuing to the contract and during an extraction represent the functions continuing to th contract and the funds currently in the contract. 

The token name equation

$$n = H(H(m), H(v))$$
$$n \mod v \mod q' = 0$$

where H is the hash function, m is a one time use secret, and v is the public value. The example code in this repo uses the sha3_256 hash function.