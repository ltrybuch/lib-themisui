angular.module "thDemo", ["ThemisComponents"]
.factory "MyCustomFilterConverter", (CustomFilterConverter) ->
  class MyCustomFilterConverter extends CustomFilterConverter
    mapToCustomFilterArray: (data) ->
      data.map (item) ->
        fieldIdentifier: item.id
        name: item.name
        type: do ->
          switch item.field_type
            when "picklist"
              "select"
            when "text_area", "text_line"
              "input"
            when "numeric"
              "number"
            when "checkbox", "email", "url", "currency", "autocomplete"
              item.field_type
            else
              throw new Error "unsupported field_type"
        selectOptions: do ->
          if item.custom_field_picklist_options?
            item.custom_field_picklist_options.map (option) ->
              name: option.option
              value: option.id
        autocompleteOptions:
          modelClass: item.autocomplete_options?.model_class
          displayField: item.autocomplete_options?.display_field
          trackField: item.autocomplete_options?.track_field
          icon: item.autocomplete_options?.icon

.factory "Repo", ($http) ->
  class Repo
    query: (params) ->
      if params.searchString.length > 1
        result = []
        result.loading = true
        result.promise =
          $http
            method: 'GET'
            url: 'https://api.github.com/search/repositories'
            params:
              q: params.searchString
          .then (response) ->
            response.data.items.forEach (item) ->
              result.push item
            result.loading = false

        return result
      else
        []

.controller "DemoController", (
  SimpleTableDelegate
  TableHeader
  TableSort
  FilterSet
  $http
  MyCustomFilterConverter
) ->
  {sort} = TableSort
  @filterChangeEvents = 0

  @filterSet = new FilterSet
    onFilterChange: (filters) =>
      @query = @filterSet.getQueryParameters()
      @filterChangeEvents += 1

  @filterOptions = {
    filterSet: @filterSet
    customFilterUrl: "./json/customFields.json"
    customFilterConverter: new MyCustomFilterConverter
  }

  return
