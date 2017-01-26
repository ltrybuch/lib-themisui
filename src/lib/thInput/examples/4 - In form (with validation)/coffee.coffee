angular.module("thInputDemo")
  .controller "thInputDemoCtrl4", ->
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
