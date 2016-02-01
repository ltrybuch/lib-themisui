angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ($http) ->
    @repo = null

    @delegate =
      fetchData: (searchString, updateData) ->
        if searchString?.length
          $http
            method: 'GET'
            url: 'https://api.github.com/search/repositories'
            params:
              q: searchString
          .then (response) ->
            repos = response.data.items.map (item) ->
              Object.assign(item, {
                # Required parameters
                text: item.name
                id: item.id
              })
            updateData(repos)
              
    return
