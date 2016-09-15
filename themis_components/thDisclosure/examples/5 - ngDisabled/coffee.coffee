angular.module 'thDemo', ['ThemisComponents']
  .controller 'DemoCtrl', ->
    @expanded = false
    @disabled = true

    @toggle = ->
      @disabled = !@disabled

    return
