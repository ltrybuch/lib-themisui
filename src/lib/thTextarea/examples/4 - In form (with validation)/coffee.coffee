angular.module("thTextareaDemo")
  .controller "thTextareaDemoCtrl4", ->
    @reset = ->
      @form.$setPristine()
      @text = ""
      @response = ""
    @submit = ->
      @response =
        if @form.$valid
          $valid: @form.$valid
        else
          $error: @form.text.$error

    return
