angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @reset = ->
      @form.$setPristine()
      @form.$setUntouched()
      @response = ""
      # Reset input fields.
      ["text", "textarea", "checkbox", "radio", "number"].forEach (el) =>
        @[el] = ""

    @submit = ->
      @response =
        if @form.$valid
          $valid: @form.$valid
        else
          $error:
            text: @form.text.$error
            textarea: @form.textarea.$error
            number: @form.number.$error
            checkbox: @form.checkbox.$error
            radio: @form.radio.$error

    return
