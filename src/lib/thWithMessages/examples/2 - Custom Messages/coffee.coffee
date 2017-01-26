angular.module("thWithMessagesDemo")
  .controller "thWithMessagesDemoCtrl2", ->
    @messages =
      minlength: "This is a custom minLength message."
      maxlength: "This is a custom maxLength message."
      max: "Please enter a price equal to or less than $100"
      min: "Please enter a price equal to or more than $1"
      number: "This is a custom number validation message."

    @options = [
      {name: "One", value: 1}
      {name: "Two", value: 2}
      {name: "Three", value: 3}
      {name: "Four", value: 4}
    ]

    @reset = ->
      @form.$setPristine()
      @form.$setUntouched()
      @response = ""
      ["text", "textarea", "select", "number"].forEach (el) => @[el] = ""

    @submit = ->
      @response =
        if @form.$valid
          $valid: @form.$valid
        else
          $error:
            text: @form.text.$error
            textarea: @form.textarea.$error
            select: @form.select.$error
            number: @form.number.$error

    return
