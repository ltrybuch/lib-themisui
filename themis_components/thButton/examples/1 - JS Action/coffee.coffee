angular.module('thDemo', ['ThemisComponents'])
  .controller 'TestButtonController', ->
    @action = ->
      console.log 'JS Action clicked!'

    return