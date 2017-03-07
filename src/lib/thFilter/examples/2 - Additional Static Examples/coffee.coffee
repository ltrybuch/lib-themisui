angular.module("thFilterDemo")
  .service "Repo", ($http, DataSource) ->
    {
      create: ->
        DataSource.createDataSource({
          serverFiltering: true
          transport: {
            read: {
              url: "//api.github.com/search/repositories"
              type: "get"
              dataType: "json"
            },
            parameterMap: (data, action) ->
              if action is "read" and data.filter
                return {
                  q: if data.filter.filters[0] then data.filter.filters[0].value else ""
                };
              else
                return data
          },
          schema: {
            data: "items"
          }
      })
    }
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
          modelClass: "Repo",
          displayField: "full_name"
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
