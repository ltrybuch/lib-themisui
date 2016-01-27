angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ($http) ->
    @repo = null
    @repos = []

    @delegate =
      fetchData: (term) =>
        if term?.length
          $http
            method: 'GET'
            url: 'https://api.github.com/search/repositories'
            params:
              q: term
          .then (response) =>
            @repos = response.data.items.map (item) ->
              angular.extend(item, {
                # Required parameters
                text: item.name
                id: item.id
                })
              
    return
