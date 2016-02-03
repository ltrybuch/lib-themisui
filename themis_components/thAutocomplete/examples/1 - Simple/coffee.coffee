angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ($http) ->
    @repo = null

    @delegate =
      displayField: 'full_name'
      fetchData: (searchString, updateData) ->
        if searchString?.length
          $http
            method: 'GET'
            url: 'https://api.github.com/search/repositories'
            params:
              q: searchString
          .then (response) ->
            updateData(response.data.items)
              
    return
