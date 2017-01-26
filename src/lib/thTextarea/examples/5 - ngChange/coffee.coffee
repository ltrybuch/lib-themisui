angular.module("thTextareaDemo")
  .controller "thTextareaDemoCtrl5", ->
    @counter = 0

    @reset = ->
      @text = ""
      @modelValueOnChange = ""
      @counter = 0

    @onChange = ->
      @counter += 1
      @modelValueOnChange = @text

    return
