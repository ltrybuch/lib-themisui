angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoCtrl", ->
    @disabled = false
    @toggle = -> @disabled = !@disabled
    return
