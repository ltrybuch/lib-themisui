angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @reset = ->
      @text = ""
      @form.$setPristine()

    return
