{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thCustomFilters", ->
  FilterSet = filterSet = element = directiveScope = compile = null
  validTemplate = """
    <th-custom-filters options="options"></th-custom-filters>
  """

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_) ->
      FilterSet = _FilterSet_

    filterSet = new FilterSet {onFilterChange: -> return}

    {element} = compileDirective(validTemplate, {
      options: {
        filterSet: filterSet
        customFilterTypes: []
      }
    })

    customFiltersElement = element[0].querySelector(".th-custom-filters")
    directiveScope = angular.element(customFiltersElement).scope()

  describe "when options is undefined", ->
    it "should throw an error", ->
      template = "<th-custom-filters></th-custom-filters>"
      expect(-> compileDirective(template)).toThrow()

  describe "when filter set is undefined", ->
    it "should throw an error", ->
      expect(-> compileDirective(validTemplate, {
        options: {
          customFilterTypes: []
        }
      })).toThrow()

  describe "when list is undefined", ->
    it "should throw an error", ->
      expect(-> compileDirective(validTemplate, {
        options: {
          filterSet: filterSet
        }
      })).toThrow()

  describe "when component is initialized", ->
    it "should have zero rows", ->
      expect(element[0].querySelector("th-custom-filter-row")).toBe null

    it "should have button to add row", ->
      expect(element[0].querySelector(
        "[ng-click='thCustomFilters.addCustomFilterRow()']")
      ).not.toBe null

  describe "#addCustomRow", ->
    it "should add one row", ->
      directiveScope.thCustomFilters.addCustomFilterRow()
      directiveScope.$digest()
      expect(element[0].querySelectorAll("th-custom-filter-row").length).toBe 1

      directiveScope.thCustomFilters.addCustomFilterRow()
      directiveScope.$digest()
      expect(element[0].querySelectorAll("th-custom-filter-row").length).toBe 2

  describe "#removeCustomRow", ->
    firstIndex = lastIndex = null

    beforeEach ->
      directiveScope.thCustomFilters.addCustomFilterRow()
      directiveScope.thCustomFilters.addCustomFilterRow()
      directiveScope.$digest()

      rows = element[0].querySelectorAll("th-custom-filter-row")
      firstIndex = rows[0].getAttribute('index')
      lastIndex = rows[1].getAttribute('index')

    describe "when called with invalid index", ->
      it "should throw an error", ->
        expect(->
          directiveScope.thCustomFilters.removeCustomFilterRow(lastIndex + 1)
        ).toThrow()

    describe "when called with index of first element repeatedly", ->
      it "should remove first element from DOM repeatedly", ->
        directiveScope.thCustomFilters.removeCustomFilterRow(firstIndex)
        directiveScope.$digest()

        rows = element[0].querySelectorAll("th-custom-filter-row")
        expect(rows.length).toBe 1
        expect(rows[0].getAttribute('index')).toBe lastIndex

        directiveScope.thCustomFilters.removeCustomFilterRow(lastIndex)
        directiveScope.$digest()

        rows = element[0].querySelectorAll("th-custom-filter-row")
        expect(rows.length).toBe 0

    describe "when called with index of last element", ->
      it "should remove last element from DOM", ->
        directiveScope.thCustomFilters.removeCustomFilterRow(lastIndex)
        directiveScope.$digest()

        rows = element[0].querySelectorAll("th-custom-filter-row")
        expect(rows.length).toBe 1
        expect(rows[0].getAttribute('index')).toBe firstIndex
