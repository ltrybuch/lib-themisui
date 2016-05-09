{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thSearchRow", ->
  InputFilter = FilterSet = filterSet = null
  validTemplate = """
    <th-search-row options="options"></th-search-row>
  """

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_, _InputFilter_) ->
      FilterSet = _FilterSet_
      InputFilter = _InputFilter_

    filterSet = new FilterSet {onFilterChange: -> return}

  describe "when options is undefined", ->
    it "should throw an error", ->
      template = "<th-search-row></th-search-row>"
      expect(-> compileDirective(template)).toThrow()

  describe "when filter set is undefined", ->
    it "should throw an error", ->
      expect(-> compileDirective(validTemplate, {
        options: {}
      })).toThrow()

  describe "when filter set is defined", ->
    beforeEach ->
      compileDirective(validTemplate, {
        options: {
          filterSet: filterSet
        }
      })

    it "should add query filter to filter set", ->
      expect(filterSet.length).toBe 1
      expect(filterSet[0]).toBe instanceof InputFilter
      expect(filterSet[0].fieldIdentifier).toBe "query"
