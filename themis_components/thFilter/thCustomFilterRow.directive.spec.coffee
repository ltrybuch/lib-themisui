{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thCustomFilterRow", ->
  FilterSet = filterSet = element = timeout = null
  rowContainerController = rowController = null

  validTemplate = """
    <th-filter options="options">
      <th-custom-filters></th-custom-filters>
    </th-filter>
  """

  filterType = {
    name: 'name'
    type: 'select'
    fieldIdentifier: 'id'
    placeholder: 'placeholder'
    data: [
      {name: '1', value: '1'}
      {name: '2', value: '2'}
    ]
  }

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_, $timeout) ->
      FilterSet = _FilterSet_
      timeout = $timeout

    filterSet = new FilterSet {
      onFilterChange: -> return
    }

    {element} = compileDirective(validTemplate, {
      options: {
        filterSet: filterSet
        customFilterTypes: [filterType]
      }
    })

    rowContainerElement = element[0].querySelector(".th-custom-filters")
    rowContainerScope = angular.element(rowContainerElement).scope()
    rowContainerController = rowContainerScope.thCustomFilters

    rowContainerController.addCustomFilterRow()
    rowContainerScope.$digest()

    rowElement = element[0].querySelector(".row")
    rowScope = angular.element(rowElement).scope()
    rowController = rowScope.thCustomFilterRow

  describe "#onRowSelectChanged", ->
    describe "when selected value is null or undefined", ->
      beforeEach ->
        rowController.rowSelectValue = undefined

      it "should set to empty array", ->
        rowController.onRowSelectChange()
        timeout.flush()
        expect(rowController.rowFilterOptions.length).toBe 0

    describe "when selected value is filter", ->
      beforeEach ->
        rowController.rowSelectValue = filterType

      it "should add filter to array as only element", ->
        rowController.onRowSelectChange()
        timeout.flush()
        expect(rowController.rowFilterOptions.length).toBe 1
        rowController.onRowSelectChange()
        timeout.flush()
        expect(rowController.rowFilterOptions.length).toBe 1
