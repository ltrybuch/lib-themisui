angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ->
    @active = off
    @changeHandler = ->
      console.log "Changed to " + @active

    return
