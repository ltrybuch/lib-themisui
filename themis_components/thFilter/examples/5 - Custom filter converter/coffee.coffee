angular.module "thDemo", ["ThemisComponents"]
.factory 'MyCustomFilterConverter', (CustomFilterConverter) ->
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
            when "checkbox", "email", "url", "currency"
              item.field_type
            else
              throw new Error "unsupported field_type"
        selectOptions: do ->
          if item.custom_field_picklist_options?
            item.custom_field_picklist_options.map (option) ->
              name: option.option
              value: option.id

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
