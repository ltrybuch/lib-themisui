angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ->
    @state = off
    @changeHandler = ->
      alert "New value: " + @state

    return
