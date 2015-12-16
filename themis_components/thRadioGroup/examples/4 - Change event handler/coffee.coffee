angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ->
    @value = 'one'
    @changeHandler = ->
      alert "New value: " + @value

    return
