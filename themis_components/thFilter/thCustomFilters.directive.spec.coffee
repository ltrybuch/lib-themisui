{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thCustomFilters", ->
  FilterSet = filterSet = element = directiveScope = CustomFilterConverter = httpBackend = null
  validTemplate = """
    <th-custom-filters options="options"></th-custom-filters>
  """

  findController = (element) ->
    angular.element(element[0].querySelector(
      ".th-custom-filters"
    )).scope().thCustomFilters

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

  describe "when filter set is defined on th-filter", ->
    it "should use filter set from th-filter", ->
      {element} = compileDirective("""
        <th-filter options="options">
          <th-custom-filters></th-custom-filters>
        </th-filter>
      """
      , {
        options: {
          filterSet: filterSet
          customFilterTypes: []
        }
      })
      controller = findController element
      expect(controller.filterSet).toBe filterSet

  describe "when filter set is defined on th-custom-filters", ->
    it "should use filter set from th-custom-filters", ->
      {element} = compileDirective(validTemplate, {
        options: {
          filterSet: filterSet
          customFilterTypes: []
        }
      })
      controller = findController element
      expect(controller.filterSet).toBe filterSet

  describe "when filter set is defined on both th-filter and th-custom-filters", ->
    it "should use filter set from th-custom-filters", ->
      filterSet1 = new FilterSet {onFilterChange: -> return}
      filterSet2 = new FilterSet {onFilterChange: -> return}
      {element} = compileDirective("""
        <th-filter options="options1">
          <th-custom-filters options="options2"></th-custom-filters>
        </th-filter>
      """
      , {
        options1: {
          filterSet: filterSet1
          customFilterTypes: []
        }
        options2: {
          filterSet: filterSet2
          customFilterTypes: []
        }
      })
      controller = findController element
      expect(controller.filterSet).toBe filterSet2

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
          initialState:
            id0: "test"
            idx: "unknown"
      )
      httpBackend.flush()
      directiveElement = element[0].querySelector(".th-custom-filters")
      @controller = angular.element(directiveElement).scope().thCustomFilters

    it "should fetch custom filters from url", ->
      httpBackend.expectGET "/custom_filter.json"

    it "should set customFilterTypes to response", ->
      expect(@controller.customFilterTypes.length).toBe 2
      expect(@controller.customFilterTypes[0].type).toBe "input"
      expect(@controller.customFilterTypes[0].fieldIdentifier).toBe "id0"
      expect(@controller.customFilterTypes[0].name).toBe "input"
      expect(@controller.customFilterTypes[1].type).toBe "select"
      expect(@controller.customFilterTypes[1].fieldIdentifier).toBe "id1"
      expect(@controller.customFilterTypes[1].name).toBe "select"

    it "should add a row for each initial known name/value pair", ->
      expect(@controller.customFilterRows.length).toBe 1
      expect(@controller.customFilterRows[0].value).toBe "test"

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

    describe "when called with invalid index", ->
      it "should throw an error", ->
        expect(->
          directiveScope.thCustomFilters.removeCustomFilterRow(lastIndex + 1)
        ).toThrow()

    describe "when called with index of first element repeatedly", ->
      it "should remove first element from DOM repeatedly", ->
        rows = element[0].querySelectorAll(".row")
        angular.element(rows[0]).scope().thCustomFilterRow.removeRow()
        directiveScope.$digest()

        rows = element[0].querySelectorAll(".row")
        expect(rows.length).toBe 1
        angular.element(rows[0]).scope().thCustomFilterRow.removeRow()
        directiveScope.$digest()

        rows = element[0].querySelectorAll(".row")
        expect(rows.length).toBe 0

    describe "when called with index of last element", ->
      it "should remove last element from DOM", ->
        rows = element[0].querySelectorAll(".row")
        angular.element(rows[1]).scope().thCustomFilterRow.removeRow()
        directiveScope.$digest()

        rows = element[0].querySelectorAll(".row")
        expect(rows.length).toBe 1
