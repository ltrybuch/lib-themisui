angular.module "thDemo", ["ThemisComponents"]
.factory "MyCustomFilterConverter", (CustomFilterConverter) ->
  class MyCustomFilterConverter extends CustomFilterConverter
    mapToCustomFilterArray: (data) ->
      data.map (item) ->
        fieldIdentifier: item.name
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
          queryField: item.autocomplete_options?.query_field

.factory "Repo", ($http) ->
  class Repo
    @query: (params) ->
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
          return {collection: result}

      return result

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
    onFilterChange: =>
      @query = @filterSet.getQueryParameters()
      @filterChangeEvents += 1
    onInitialized: =>
      @query = @filterSet.getQueryParameters()

  @filterOptions = {
    filterSet: @filterSet
    customFilterUrl: "./json/customFields.json"
    customFilterConverter: new MyCustomFilterConverter
    initialState:
      numeric: "<=12.34"
      currency: ">12"
      email: "email example text"
      text_line: "text line example text"
      text_area: "text area example text"
      url: "url example text"
      picklist: "0"
      checkbox: "true"
  }

  return
