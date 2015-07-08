angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ->
    @action = ->
      console.log 'JS Action clicked!'