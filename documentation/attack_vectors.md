# Possible Attack Vectors


## Mint 2 and Fake Inject

The goal of this attack is to create real value tokens without injecting any funds into the contract.


$$ \alpha g^{z_{0}} g^{z_{1}} = g^{r} g^{rK_{01}} \mod q $$

There are no burns so the left most constant is open. The values $g^{z_{0}}$ and  $g^{z_{1}}$ are known. The injection amount, $b$, is zero so the inject value is just $g^r$. The value $g^{rK_{01}}$ is known.

Solving for $\alpha$ is just reducing the residue system which means the solutions for $\alpha$ is of the form $c_{0} + c_{1}k$ for $k \in \Z$. The attempted solution is forcing the transaction to expose the $K$ values. So both the mint and burn constants require additional information, increasing the complexity.

$$ g^{r (k + 1)} g^{z_{0}} g^{z_{1}} = g^{r} g^{rK_{01}} \mod q $$

The problem changes into solving for $k$. This solution scales with $q$ so large values should return in very long search times.