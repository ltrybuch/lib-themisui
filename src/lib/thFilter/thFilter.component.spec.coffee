{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thFilter", ->
  FilterSet = filterSet = null
  validTemplate = """
    <th-filter options="options"></th-filter>
  """

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_) ->
      FilterSet = _FilterSet_

    filterSet = new FilterSet {onFilterChange: -> return}

  describe "when filter set is undefined", ->
    it "should throw an error", ->
      expect(-> compileDirective validTemplate, options: {}).toThrow()

  describe "#clearFilters", ->
    beforeEach ->
      {@element} = compileDirective validTemplate, options: {filterSet}

      @scope = angular.element(
        @element[0].querySelector ".th-filter"
      ).scope()
      controller = @scope.thFilter

      spyOn @scope, "$broadcast"
      spyOn filterSet, "onFilterChange"
      controller.clearFilters()

    it "should broadcast 'th.filters.clear' event", ->
      expect(@scope.$broadcast).toHaveBeenCalledWith "th.filters.clear"

    it "should call 'onFilterChange'", ->
      expect(filterSet.onFilterChange).toHaveBeenCalled()
