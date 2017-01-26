angular.module("thFilterDemo")
  .factory "Repo", ($http) ->
    class Repo
      @query: (params) ->
        result = []
        result.loading = true
        result.promise =
          $http
            method: "GET"
            url: "https://api.github.com/search/repositories"
            params:
              q: params.searchString
          .then (response) ->
            response.data.items.forEach (item) ->
              result.push item
            result.loading = false
            return {collection: result}

        return result

  .controller "thFilterDemoCtrl2", (
    FilterSet
  ) ->
    filterTypes = [
      {
        name: "Repo"
        type: "autocomplete"
        fieldIdentifier: "repo"
        placeholder: "Start typing a GitHub Repo name..."
        autocompleteOptions:
          modelClass: "Repo"
          queryField: "searchString"
      }
      {
        name: "Date"
        type: "date"
        fieldIdentifier: "exampleDate"
      }
    ]

    @filterSet = new FilterSet
      onFilterChange: =>
        @query = @filterSet.getState()

    @filterOptions = {
      filterSet: @filterSet
      staticFilters: filterTypes
    }

    return
