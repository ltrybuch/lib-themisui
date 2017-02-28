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

  describe "initialization", ->
    it "compiles the directive", ->
      expect(rowController).toBeDefined()
      expect(rowController.onRowSelectChange).toBeDefined()
