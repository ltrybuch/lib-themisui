angular.module("thTabsetDemo")
  .controller "thTabsetDemoCtrl8", ->
    @alphabet = [
      "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
      "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
    ]
    # Initialize to "E"
    @initialLetter = @alphabet[4]

    return
