{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thSearchRow", ->
  InputFilter = FilterSet = filterSet = null
  validTemplate = """
    <th-search-row options="options"></th-search-row>
  """

  findController = (element) ->
    angular.element(element[0].querySelector(
      ".th-search-row"
    )).scope().thSearchRow

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_, _InputFilter_) ->
      FilterSet = _FilterSet_
      InputFilter = _InputFilter_

    filterSet = new FilterSet {onFilterChange: -> return}

  describe "when filter set is undefined", ->
    it "should throw an error", ->
      expect(-> compileDirective(validTemplate, {
        options: {}
      })).toThrow()

  describe "when filter set is defined on th-filter", ->
    beforeEach ->
      {@element} = compileDirective("""
        <th-filter options="options">
          <th-search-row></th-search-row>
        </th-filter>
      """
      , {
        options: {
          filterSet: filterSet
        }
      })

    it "should use filter set from th-filter", ->
      controller = findController @element
      expect(controller.filterSet).toBe filterSet

    it "should add query filter to filter set", ->
      expect(filterSet.length).toBe 1
      expect(filterSet[0]).toBe instanceof InputFilter
      expect(filterSet[0].fieldIdentifier).toBe "query"

  describe "when filter set is defined on th-search-row", ->
    it "should use filter set from th-search-row", ->
      {element} = compileDirective(validTemplate, {
        options: {
          filterSet: filterSet
        }
      })
      controller = findController element
      expect(controller.filterSet).toBe filterSet

  describe "when filter set is defined on both th-filter and th-search-row", ->
    it "should use filter set from th-search-row", ->
      filterSet1 = new FilterSet {onFilterChange: -> return}
      filterSet2 = new FilterSet {onFilterChange: -> return}
      {element} = compileDirective("""
        <th-filter options="options1">
          <th-search-row options="options2"></th-search-row>
        </th-filter>
      """
      , {
        options1: {
          filterSet: filterSet1
        }
        options2: {
          filterSet: filterSet2
        }
      })
      controller = findController element
      expect(controller.filterSet).toBe filterSet2
