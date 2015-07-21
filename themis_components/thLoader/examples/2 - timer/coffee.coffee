angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ->
    @timeout = 0

    @updateTimeout = ->
      @timeout = 4000

    return
