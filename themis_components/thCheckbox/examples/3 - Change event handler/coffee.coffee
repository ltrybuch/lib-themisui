angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ->
    @checked = false
    @changeHandler = ->
      alert "New value: " + @checked

    return
