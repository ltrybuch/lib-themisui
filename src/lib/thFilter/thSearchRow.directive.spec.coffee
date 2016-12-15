{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thSearchRow", ->
  InputFilter = FilterSet = filterSet = null
  validTemplate = """
    <th-filter options="options">
      <th-search-row></th-search-row>
    </th-filter>
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
      {@element} = compileDirective(validTemplate, {
        options: {
          filterSet: filterSet
        }
      })

    it "should use the supplied filter set", ->
      controller = findController @element
      expect(controller.filterSet).toBe filterSet

    it "should add query filter to filter set", ->
      expect(filterSet.length).toBe 1
      expect(filterSet[0]).toBe instanceof InputFilter
      expect(filterSet[0].fieldIdentifier).toBe "query"
