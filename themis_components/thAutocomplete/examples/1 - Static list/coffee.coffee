angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ($scope, $http, $timeout) ->
    @colours = fixtures()
    @colour = null

    @onChange = ->
      console.log 'New value: ' + @colour

    @fetchData = (term) =>
      if term?.length
        console.log term

        $http
          method: 'GET'
          url: 'https://api.github.com/search/repositories'
          params:
            q: term
        .then (response) =>

          @colours = response.data.items.map (item) ->
            angular.extend(item, {
              # Required parameters
              text: item.name
              id: item.id
              })

    return

fixtures = ->
  return [
    {id: 0, text: "zero"}
    {id: 1, text: "one"}
    {id: 2, text: "two"}
    {id: 3, text: "three"}
    {id: 4, text: "four"}
  ]
