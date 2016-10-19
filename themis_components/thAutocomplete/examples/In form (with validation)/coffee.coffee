angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoCtrl', ($http) ->
    @repo = null
    @reset = ->
      @form.$setPristine()
      @form.$setUntouched()
      @response = ""
    @submit = ->
      debugger
      @response =
        if @form.$valid
          $valid: @form.$valid
        else
          $error: @form.repo.$error

    @delegate =
      displayField: 'full_name'
      fetchData: ({searchString}, updateData) ->
        if searchString?.length > 0
          $http
            method: 'GET'
            url: 'https://api.github.com/search/repositories'
            params:
              q: searchString
          .then (response) ->
            updateData response.data.items
        else
          updateData []

    @onChange = -> @counter = @counter + 1

    return
