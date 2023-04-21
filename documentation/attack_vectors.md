# Possible Attack Vectors

There are going to be some attack vectors to this system. The top prioirty is ensuring the safety of funds locked in the contract. The worst case is getting all the funds drained. The goal of this write up is trying to circumvent or make difficult these possible attack vectors.

## Mint 2 and Fake Inject

The goal of this attack is to create real value tokens without injecting any funds into the contract. Then tokens can be minted that can spend the entire contract balance.

The transformation equation can be reduced into


$$ \alpha g^{z_{0}} g^{z_{1}} = g^{r} g^{rK_{01}} \mod q $$

There are no burns so the left most constant is open. The values $g^{z_{0}}$ and  $g^{z_{1}}$ are known. The injection amount, $b$, is zero so the inject value is just $g^r$. The value $g^{rK_{01}}$ is known.

Solving for $\alpha$ is just reducing the residue system which means the solutions for $\alpha$ is of the form $c_{0} + c_{1}k$ for $k \in \Z$. The attempted solution is forcing the transaction to expose the $K$ values. So both the mint and burn constants require additional information, increasing the complexity.

$$ g^{r (k + 1)} g^{z_{0}} g^{z_{1}} = g^{r} g^{rK_{01}} \mod q $$

The problem changes into solving for $k$. This solution scales with $q$ so large values should return in very long search times. Approximate crunch time using Mathematica 13 with a $q$ with 19 digits should take about 30 years.

## Fake Mint Value/Name

The idea is injecting $b$ ada into the contract and minting two tokens but of the tokens will be faked so that the value is different.

$$ g^{r} g^{z_{0}} g^{z_{1}}  = g^{z_{b}} g^{rK_{01}} \mod q $$

For honest, $K_{j}$, $K_{i}$, and $b$, inputs there is only one solution to $\alpha$ within $q$ that satisfies the equation. The issue comes when b is set to zero. The equation reduces to

$$g^{z_{0}} g^{z_{1}} =  g^{x} \mod q $$

Which does not have a solution that isn't the real values.