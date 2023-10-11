use convert_expression/helper

test empty_prove_burn() {
  helper.prove_burn([], [], []) == True
}

test empty_prove_mint() {
  helper.prove_mint([], []) == True
}

test single_burn() {
  helper.prove_burn(
    [751397636616587930],
    // integers
    [#"1a4bcc7afed2e17f491a3a2dffe7015bf77d3886c04cec607c546b62318e98bd"],
    // names
    [#"4154bdf08a85aa2f6ff215c7cf340de5399ca0818fc5cf2e133801bef62768f3"],
  ) == // proofs
  True
}

test double_burn() {
  helper.prove_burn(
    [85555417923071379, 32181992827649166],
    [
      #"b7c59b1b6472ba06135df233de871a15c725bd720a8c60d3e5585408a449df33",
      #"a2bf33326cb22ecff093d8a462a3783706198773b8d9ddf8c07513cbae4d92fb",
    ],
    [
      #"69ccb7bddeca35b2d69c39a75e1927f53a053b2292def8d144b61de9a62a8eac",
      #"3e5c625ce895cd7b8fb57f0172cb3d0fa353298d48bc71e0750a81fd51dad2eb",
    ],
  ) == True
}

test triple_burn() {
  helper.prove_burn(
    [250602099261951288, 233848391693077322, 710501442004688010],
    [
      #"0f65c9a118210e1f18996e3b9332f38a745c41c561d39513d07425b8e236fbf0",
      #"09148c9afd9aca46be584fa3cb38d2ce497db19277036a81ee8fc9a9db51c60a",
      #"0ac3f8d3c9eab7ecf20a88d3c81feaec12a61a357bfb4ca3daf273307e958805",
    ],
    [
      #"b0de144bcc4b6c6525d90bdccdd18f25ea1d6dbb98f8ab33c4a3c2950faa1876",
      #"d12abeee69f882517f84bf8dd088efa9eb0b57c84356cfaf8a6c53a60e59ba35",
      #"990c797f35c10a7661273203bec51539a98b3dd2c60817c4811ec7ed693a8f83",
    ],
  ) == True
}

test single_mint() {
  helper.prove_mint(
    [751397636616587930],
    [#"1a4bcc7afed2e17f491a3a2dffe7015bf77d3886c04cec607c546b62318e98bd"],
  ) == True
}

test double_mint() {
  helper.prove_mint(
    [85555417923071379, 32181992827649166],
    [
      #"b7c59b1b6472ba06135df233de871a15c725bd720a8c60d3e5585408a449df33",
      #"a2bf33326cb22ecff093d8a462a3783706198773b8d9ddf8c07513cbae4d92fb",
    ],
  ) == True
}

test triple_mint() {
  helper.prove_mint(
    [250602099261951288, 233848391693077322, 710501442004688010],
    [
      #"0f65c9a118210e1f18996e3b9332f38a745c41c561d39513d07425b8e236fbf0",
      #"09148c9afd9aca46be584fa3cb38d2ce497db19277036a81ee8fc9a9db51c60a",
      #"0ac3f8d3c9eab7ecf20a88d3c81feaec12a61a357bfb4ca3daf273307e958805",
    ],
  ) == True
}
