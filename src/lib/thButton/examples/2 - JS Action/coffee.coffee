angular.module('thDemo', ['ThemisComponents'])
  .controller 'TestButtonController', ->
    @action = ->
      alert('Hello!')
    return
