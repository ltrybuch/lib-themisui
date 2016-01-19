angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', (AutocompleteDelegate, $scope) ->
    $scope.foo = "bar"

    data = fixtures()

    @test = "1"

    @autocompleteDelegate = AutocompleteDelegate
      fetchData: ({term}, updateData) ->
        updateData(data)
        return

    @change = ->
      console.log 'ng-changed'

    @flip = =>
      debugger
      @test = "2"

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
