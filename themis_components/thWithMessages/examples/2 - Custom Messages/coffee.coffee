angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @messages =
      minlength: "This is a custom minLength message."
      maxlength: "This is a custom maxLength message."

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
      ["text", "textarea", "select"].forEach (el) => @[el] = ""

    @submit = ->
      @response =
        if @form.$valid
          $valid: @form.$valid
        else
          $error:
            text: @form.text.$error
            textarea: @form.textarea.$error
            select: @form.select.$error

    return
