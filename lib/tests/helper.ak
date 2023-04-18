use hidden_contract/helper

test empty_prove_burn() {
  helper.prove_burn([], [], []) == True
}

test single_burn() {
  helper.prove_burn(
    [1497],
    [#"5fdc6c8d358c47aee3b6237764af9d2f3ae5ca8e406a9511f7a29f01ab9cc2bd"],
    [#"c904f095ab5451515064fc31ff7c818d36a9287d80b6e147d220c0cbf7019582"],
  ) == True
}

test multiple_burn() {
  helper.prove_burn(
    [1497, 376],
    [
      #"5fdc6c8d358c47aee3b6237764af9d2f3ae5ca8e406a9511f7a29f01ab9cc2bd",
      #"500a1641c43b3004a7a3394e2aa698d9f1292dab0c6d0b1f283a8c80978575c0",
    ],
    [
      #"c904f095ab5451515064fc31ff7c818d36a9287d80b6e147d220c0cbf7019582",
      #"76aa57bc1552eaf1f1494e8592cd4f218112848d0a047390ba8b5ba52515daaf",
    ],
  ) == True
}

test empty_prove_mint() {
  helper.prove_mint([], []) == True
}

test single_mint() {
  helper.prove_mint(
    [1497],
    [#"5fdc6c8d358c47aee3b6237764af9d2f3ae5ca8e406a9511f7a29f01ab9cc2bd"],
  ) == True
}

test multiple_mint() {
  helper.prove_mint(
    [1497, 376],
    [
      #"5fdc6c8d358c47aee3b6237764af9d2f3ae5ca8e406a9511f7a29f01ab9cc2bd",
      #"500a1641c43b3004a7a3394e2aa698d9f1292dab0c6d0b1f283a8c80978575c0",
    ],
  ) == True
}

test empty_list_of_mints_and_burns() {
  helper.list_pow_mod([]) == helper.list_pow_mod([])
}

test list_of_mints_and_burns() {
  let left =
    [2835595436209736255, 2997532379697512730, 8494482003699531620]
  let right =
    [4702576305290162895, 4812563786666023419, 8848806375754731735]
  helper.list_pow_mod(left) == helper.list_pow_mod(right)
}

test list_of_only_mints() {
  let left =
    [3688371627213947, 3875644491920815627, 6710886400]
  let right =
    [2167002592491288770, 8929118933177322057]
  helper.list_pow_mod(left) == helper.list_pow_mod(right)
}

test list_for_extraction() {
  let left =
    [4379166847518509761, 3967284141675633404]
  let right =
    [
      7478865128743298826, 7422722409375585999, 6459881879562207830,
      8111245232363053438,
    ]
  helper.list_pow_mod(left) == helper.list_pow_mod(right)
}

test list_for_extraction2() {
  let left =
    [664, 387]
  let right =
    [23, 451, 1039, 1539]
  helper.list_pow_mod(left) != helper.list_pow_mod(right)
}

test correct_to_int() {
  helper.to_int(#"acab") == 44203
}

test correct_int_to_hash() {
  helper.int_to_hash(0) == #"f9e2eaaa42d9fe9e558a9b8ef1bf366f190aacaa83bad2641ee106e9041096e4"
}

test prove_good_mint() {
  let ints =
    [8389463945806726181, 6262004490321260847, 1711566370269089011]
  let strings =
    [
      #"451c070dd856ff6bf3c3e869fcbc9c98f676ba74596fb08cd6ffaee2933ffec3",
      #"d441cd540b03015e009a12422724c7bdb0abcc6650c4bf64b4ffc2f3926cfde3",
      #"d47b6296253ba209ac46ad9bc9582c665822dee0f44632d712eda963607267b1",
    ]
  helper.prove_mint(ints, strings)
}

test prove_good_burn() {
  let ints =
    [6377360274566370311, 4367313094201873331, 4380394588557739228]
  let strings =
    [
      #"695de38f8ee894460425b5647244f2e0a0439c9ee50ac7a2cf75f4c2fd89ec20",
      #"fae9896f3c3e203be99dccb8bf434525b2de3dec2e749663babb93838224f53f",
      #"70f260b669183de039aca179d258870481cae089397292d4d4d992f10b8a46fb",
    ]
  let proofs =
    [
      #"460ca6001d6762a776099fe1bf596edb131ae7642f5edfb27bbb71447784d0a9",
      #"22ee6873d2dfd3be7d968100d019e92c7d31d7dcf3128c4a5466a9903de0929d",
      #"a08f05aaff350f6891724733150af4a88c7d361208f274ad49873c4090784850",
    ]
  helper.prove_burn(ints, strings, proofs)
}
