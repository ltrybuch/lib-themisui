angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ($http) ->

    @value = null

    @fetchData = ({term}, updateData) ->
      $http
        method: 'GET'
        url: 'https://api.github.com/search/repositories'
        params:
          q: term
      .then (response) ->
        updateData response.data.items.map (item) ->
          text: item.name
          id: item.id
      return

    return
