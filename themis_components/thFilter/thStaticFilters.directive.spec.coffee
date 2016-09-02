{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thStaticFilters", ->
  InputFilter = SelectFilter = FilterSet = filterSet = element = null
  validTemplate = """
    <th-static-filters options="options"></th-static-filters>
  """

  findController = (element) ->
    angular.element(element[0].querySelector(
      ".th-static-filters"
    )).scope().thStaticFilters

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _InputFilter_, _SelectFilter_, _FilterSet_) ->
      InputFilter = _InputFilter_
      SelectFilter = _SelectFilter_
      FilterSet = _FilterSet_

    filterSet = new FilterSet {onFilterChange: -> return}

  describe "when filter set is undefined", ->
    it "should throw an error", ->
      expect(-> compileDirective(validTemplate, {
        options: {
          staticFilters: []
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
          <th-static-filters></th-static-filters>
        </th-filter>
      """
      , {
        options: {
          filterSet: filterSet
          staticFilters: []
        }
      })
      controller = findController element
      expect(controller.filterSet).toBe filterSet

  describe "when filter set is defined on th-static-filters", ->
    it "should use filter set from th-static-filters", ->
      {element} = compileDirective(validTemplate, {
        options: {
          filterSet: filterSet
          staticFilters: []
        }
      })
      controller = findController element
      expect(controller.filterSet).toBe filterSet

  describe "when filter set is defined on both th-filter and th-static-filters", ->
    it "should use filter set from th-static-filters", ->
      filterSet1 = new FilterSet {onFilterChange: -> return}
      filterSet2 = new FilterSet {onFilterChange: -> return}
      {element} = compileDirective("""
        <th-filter options="options1">
          <th-static-filters options="options2"></th-static-filters>
        </th-filter>
      """
      , {
        options1: {
          filterSet: filterSet1
          staticFilters: []
        }
        options2: {
          filterSet: filterSet2
          staticFilters: []
        }
      })
      controller = findController element
      expect(controller.filterSet).toBe filterSet2

  describe "when list has zero elements", ->
    it "should should add zero filters to filter set and template", ->
      {element} = compileDirective(validTemplate, {
        options: {
          filterSet: filterSet
          staticFilters: []
        }
      })
      expect(filterSet.length).toBe 0
      expect(element[0].querySelectorAll("th-filter-input").length).toBe 0
      expect(element[0].querySelectorAll("th-filter-select").length).toBe 0

  describe "when list has two elements", ->
    it "should add two filters to filter set and template", ->
      selectfilter = new SelectFilter(fieldIdentifier: 0)
      inputFilter = new InputFilter(fieldIdentifier: 1)
      {element} = compileDirective(validTemplate, {
        options: {
          filterSet: filterSet
          staticFilters: [selectfilter, inputFilter]
        }
      })
      expect(filterSet.length).toBe 2
      expect(element[0].querySelectorAll("th-filter-input").length).toBe 1
      expect(element[0].querySelectorAll("th-filter-select").length).toBe 1
