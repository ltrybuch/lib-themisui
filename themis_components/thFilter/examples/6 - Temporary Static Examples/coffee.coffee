angular.module "thDemo", ["ThemisComponents"]
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

  .controller "DemoController", (
    FilterSet
  ) ->
    @filterChangeEvents = 0

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
    ]

    @filterSet = new FilterSet
      onFilterChange: =>
        @query = @filterSet.getState()
        @filterChangeEvents += 1

    @filterOptions = {
      filterSet: @filterSet
      staticFilters: filterTypes
    }

    return
