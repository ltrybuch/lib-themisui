angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ($scope) ->
    @colours = fixtures()
    @colour = @colours[3]

    @onChange = ->
      console.log 'New value: ' + @colour

    return

fixtures = ->
  return [
    {id: 0, text: "zero"}
    {id: 1, text: "one"}
    {id: 2, text: "two"}
    {id: 3, text: "three"}
    {id: 4, text: "four"}
  ]
