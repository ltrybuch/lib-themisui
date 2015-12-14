angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ->
    @value = 'one'

    @changeHandler = ->
      alert "New value: " + @value

    @buttonClicked = ->
      console.log "Button two clicked"

    return
