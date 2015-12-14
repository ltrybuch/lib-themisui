angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ->
    @checked = false
    @checked2 = true
    @changeHandler = ->
      alert "New value: " + @checked

    @clickHandler = ->
      console.log 'click'

    return
