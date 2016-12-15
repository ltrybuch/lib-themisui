angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @reset = ->
      @form.$setPristine()
      @form.$setUntouched()
      @text = ""
      @response = ""
    @submit = ->
      @response =
        if @form.$valid
          $valid: @form.$valid
        else
          $error: @form.text.$error

    return
