angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ->
    @colours = fixtures()
    @colour = null

    @onChange = ->
      console.log 'New value: ' + @colour

    return

fixtures = ->
  return [
    {id: 0, text: "Red"}
    {id: 1, text: "Orange"}
    {id: 2, text: "Yellow"}
    {id: 3, text: "Green"}
    {id: 4, text: "Blue"}
  ]
