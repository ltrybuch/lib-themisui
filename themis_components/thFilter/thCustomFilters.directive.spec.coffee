{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thCustomFilters", ->
  FilterSet = filterSet = element = directiveScope = CustomFilterConverter = httpBackend = null
  validTemplate = """
    <th-custom-filters options="options"></th-custom-filters>
  """

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_, _CustomFilterConverter_, $httpBackend) ->
      FilterSet = _FilterSet_
      CustomFilterConverter = _CustomFilterConverter_
      httpBackend = $httpBackend

    filterSet = new FilterSet {onFilterChange: -> return}

    {element} = compileDirective(validTemplate,
      options:
        filterSet: filterSet
        customFilterTypes: []
    )

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

  describe "when specifying custom filter url with no converter", ->
    beforeEach ->
      httpBackend.when("GET", "/custom_filter.json").respond """[
        {"type":"input", "fieldIdentifier":"id0", "name":"input"},
        {"type":"select", "fieldIdentifier":"id1", "name":"select"}
      ]"""
      {element} = compileDirective(validTemplate,
        options:
          filterSet: filterSet
          customFilterUrl: "/custom_filter.json"
      )
      httpBackend.flush()
      directiveElement = element[0].querySelector(".th-custom-filters")
      @customFilters = angular.element(directiveElement).scope().thCustomFilters.customFilterTypes

    it "should fetch custom filters from url", ->
      httpBackend.expectGET "/custom_filter.json"

    it "should set customFilterTypes to response", ->
      expect(@customFilters.length).toBe 2
      expect(@customFilters[0].type).toBe "input"
      expect(@customFilters[0].fieldIdentifier).toBe "id0"
      expect(@customFilters[0].name).toBe "input"
      expect(@customFilters[1].type).toBe "select"
      expect(@customFilters[1].fieldIdentifier).toBe "id1"
      expect(@customFilters[1].name).toBe "select"

  describe "when specifying custom filter url with converter", ->
    describe "when custom filter converter is not valid", ->
      it "should throw an error", ->
        expect(-> compileDirective(validTemplate,
          options:
            filterSet: filterSet
            customFilterUrl: "/custom_filter.json"
            customFilterConverter: null
        )).toThrow()

    describe "when custom filter converter is valid", ->
      beforeEach ->
        class TestCustomFilterConverter extends CustomFilterConverter
          mapToCustomFilterArray: (data) ->
            data.map (item) ->
              fieldIdentifier: "convertedId" + item.id
              name: "convertedName" + item.id
              type: "convertedType" + item.id
        testConverter = new TestCustomFilterConverter
        @convertSpy = spyOn(testConverter, "mapToCustomFilterArray").and.callThrough()

        httpBackend.when("GET", "/custom_filter.json").respond """
          [{"id": 0}, {"id": 1}]
        """

        {element} = compileDirective(validTemplate,
          options:
            filterSet: filterSet
            customFilterUrl: "/custom_filter.json"
            customFilterConverter: testConverter
        )
        httpBackend.flush()

        directiveElement = element[0].querySelector(".th-custom-filters")
        @customFilters = angular.element(directiveElement).scope().thCustomFilters.customFilterTypes

      it "should call 'mapToCustomFilterArray'", ->
        expect(@convertSpy).toHaveBeenCalled()

      it "should set 'customFilterTypes' to converted response", ->
        expect(@customFilters.length).toBe 2
        expect(@customFilters[0].type).toBe "convertedType0"
        expect(@customFilters[0].fieldIdentifier).toBe "convertedId0"
        expect(@customFilters[0].name).toBe "convertedName0"
        expect(@customFilters[1].type).toBe "convertedType1"
        expect(@customFilters[1].fieldIdentifier).toBe "convertedId1"
        expect(@customFilters[1].name).toBe "convertedName1"

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
