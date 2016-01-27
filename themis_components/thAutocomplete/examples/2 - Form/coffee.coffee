angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ->
    @colours = [
      {id: 0, text: 'red'},
      {id: 1, text: 'blue'},
      {id: 2, text: 'green'}
    ]
    return
