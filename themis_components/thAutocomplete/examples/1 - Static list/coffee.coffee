angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', (AutocompleteDelegate, $scope, $http) ->
    data = fixtures()

    @colour = null

    # @fetchData = ({term}, updateData) ->
    #   $http
    #     method: 'GET'
    #     url: 'https://api.github.com/search/repositories'
    #     params:
    #       q: term
    #   .then (response) ->
    #     updateData response.data.items.map (item) ->
    #       text: item.name
    #       id: item.id
    #   return

    @onChange = ->
      console.log 'New value: ' + @colour

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
