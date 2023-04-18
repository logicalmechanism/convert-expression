#  Convert Expression

A contract that allows the minting and burining of tokens if and only if they satisfy the transformation equation

$$ g^{r (K_{i} + 1)} \prod_{j=0}^{M} g^{z_{j}} = g^{z_{b}} g^{rK_{j}} \prod_{i=0}^{N} g^{z_{i}} \mod q $$

where 

$$z_{b} = r + cb$$
$$z_{i} = r\lambda_{i} +c\alpha_{i}$$
$$z_{j} = r\lambda_{j} +c\alpha_{j}$$

$$K_{i} = \sum_{i=0}^{N} \lambda_{i}$$
$$K_{j} = \sum_{j=0}^{M} \lambda_{j}$$

and the token name equation

$$n = H(H(v)+m)$$
$$n \mod v \mod q' = 0$$

where $H$ is the sha3_256 hash function. The constants $g$, $r$, $c$, $q$, and $q'$ are public. The values $v$, $\lambda$, $\alpha$, and $m$ are secret.

`This contract is research purposes only. Do not use.`

A detailed [docs folder](documentation/summary.md) exists for further explaination.