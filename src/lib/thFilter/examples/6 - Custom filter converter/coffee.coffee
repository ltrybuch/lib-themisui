angular.module("thFilterDemo")
.factory "MyCustomFilterConverter", (CustomFilterConverter) ->
  class MyCustomFilterConverter extends CustomFilterConverter
    mapToCustomFilterArray: (data) ->
      convertedResults = data.map (item) ->
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
            when "checkbox", "email", "url", "currency", "autocomplete", "date", "time"
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
          rowTemplate: item.autocomplete_options?.row_template

      return [convertedResults, showSearchHint: true]

.service "Repo2", (DataSource) ->
  {
    create: ->
      DataSource.createDataSource {
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
              }
            else
              return data
        },
        schema: {
          data: "items"
        }
    }
  }

.controller "thFilterDemoCtrl6", (
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
      @query = @filterSet.getState()
      @filterChangeEvents += 1
    onInitialized: =>
      @query = @filterSet.getState()

  @filterOptions = {
    filterSet: @filterSet
    customFilterUrl: "/components/thFilter/examples/6 - Custom filter converter/customFields.json"
    customFilterConverter: new MyCustomFilterConverter
    initialState:
      numeric:
        value: 12.34
        operator: "<="
      currency:
        value: 12
        operator: ">"
      email:
        value: "email example text"
      text_line:
        value: "text line example text"
      text_area:
        value: "text area example text"
      url:
        value: "url example text"
      picklist:
        value: "0"
      checkbox:
        value: "true"
      autocomplete:
        name: "autocomplete example text"
        value: 123456
      time:
        value: "10:01 AM"
        operator: ">"
      date:
        value: "2016-09-19T11:05:00-06:00"
        operator: "<"
  }

  return
