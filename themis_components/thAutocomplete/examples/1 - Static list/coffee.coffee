angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', (AutocompleteDelegate, $scope) ->
    data = fixtures()

    @colour = '1'

    @options =
      placeholder: "blah blah blah"
      fetchData: ({term}, updateData) ->
        console.log 'updating data'
        updateData(data)
        return

    @change = ->
      console.log 'ng-changed' + @colour

    return

fixtures = ->
  pets = [
    {id: 1, text: "Watson"}
    {id: 2, text: "Willy"}
    {id: 3, text: "Totem"}
    {id: 4, text: "Layla"}
    {id: 10, text: "Champ"}
  ]

  return pets
