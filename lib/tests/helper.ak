use convert_expression/helper

test empty_prove_burn() {
  helper.prove_burn([], [], []) == True
}

test empty_prove_mint() {
  helper.prove_mint([], []) == True
}

test single_burn() {
  helper.prove_burn(
    [617790847418659252],
    // integers
    [#"8b58d50ba6455e6da8305277ab7e66de275809588b07cf5b2b231e3a7b040ef3"],
    // names
    [#"1e31c3e74f274fe1fd4bb70073afa84c089943e97a5bc68a733e51b0569e1904"],
  ) == // proofs
  True
}

test double_burn() {
  helper.prove_burn(
    [90723832398798458, 663702488330403894],
    [
      #"0e9f09052312484c6ac26d709d557f8942d8de8bf00d77b4d1214fbd60184425",
      #"b7851722dde33b44c98bf62ec6601f6bbf9fa9661e954ddca79d5fb14cec7d8b",
    ],
    [
      #"3a88e77190d69b8783eab55386c98b104e6b88e5af99c760456488e99f30ac75",
      #"bd0723f0ded7946287674ecf3ed99b309f49d9f85da20c005c711725c3c503f7",
    ],
  ) == True
}

test triple_burn() {
  helper.prove_burn(
    [566363984140127211, 729636071669048975, 512378309270210291],
    [
      #"ee50cdf259cfa78f8b15ad98a6a3618fc18d42dde250e27ff5bc81b3a84d953f",
      #"12c429eecaffa7c8b6036bb19600c85ab6823aa8fbc1700478d362c30bf7fb33",
      #"da0db0655bc58b6e5e766aff58a868f56ad816c2d31297f657d1a3ff467ed90a",
    ],
    [
      #"8b5789d049b22e8dd8d9d1604fd452c2550ffcfcf52af8c6bf9a0b3c7c5d676f",
      #"3b5961a75c1f37a43caa12d20932382aab1cb6323d53da0a528a140ea55b6827",
      #"2cb172d8f07e6c1bb7633ef11708f8052b91c433d24c519781f1bce94aaff834",
    ],
  ) == True
}

test single_mint() {
  helper.prove_mint(
    [617790847418659252],
    [#"8b58d50ba6455e6da8305277ab7e66de275809588b07cf5b2b231e3a7b040ef3"],
  ) == True
}

test double_mint() {
  helper.prove_mint(
    [90723832398798458, 663702488330403894],
    [
      #"0e9f09052312484c6ac26d709d557f8942d8de8bf00d77b4d1214fbd60184425",
      #"b7851722dde33b44c98bf62ec6601f6bbf9fa9661e954ddca79d5fb14cec7d8b",
    ],
  ) == True
}

test triple_mint() {
  helper.prove_mint(
    [566363984140127211, 729636071669048975, 512378309270210291],
    [
      #"ee50cdf259cfa78f8b15ad98a6a3618fc18d42dde250e27ff5bc81b3a84d953f",
      #"12c429eecaffa7c8b6036bb19600c85ab6823aa8fbc1700478d362c30bf7fb33",
      #"da0db0655bc58b6e5e766aff58a868f56ad816c2d31297f657d1a3ff467ed90a",
    ],
  ) == True
}
