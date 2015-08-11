angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ->
    @state = on
    @toggle = -> @state = !@state

    return
