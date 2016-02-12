angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @reset = ->
      @text = ""
      @form.$setPristine()
      @response = ""
    @submit = ->
      @response =
        if @form.$valid
          $valid: @form.$valid
        else
          $error: @form.text.$error

    return
