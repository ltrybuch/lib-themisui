{
  compileDirective
} = require "spec_helpers"

# Defined here because the directive uses $injector to instantiate model class.
angular.module "ThemisComponents"
.factory "Repo", ->
  class Repo
    # Pass through parameters for validating.
    query: (params) -> params

describe "ThemisComponents: Directive: thFilterAutocomplete", ->
  AutocompleteFilter = FilterSet = null

  validTemplate = """
    <th-filter-autocomplete
      filter-set="filterSet"
      filter-options="filterOptions"
      >
    </th-filter-autocomplete>
  """

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_, _AutocompleteFilter_) ->
      FilterSet = _FilterSet_
      AutocompleteFilter = _AutocompleteFilter_

    @filterSet = new FilterSet {
      onFilterChange: -> return
    }

    @filterOptions = {
      name: "repo"
      type: "autocomplete"

      fieldIdentifier: "id"

      autocompleteOptions:
        modelClass: "Repo"
    }

    {@element, @scope} = compileDirective(validTemplate, {
      @filterSet
      @filterOptions
    })

    @controller = angular.element(
      @element.find("div")
    ).scope().thFilterAutocomplete

  it "should have 'autocomplete' element", ->
    expect(@element[0].querySelector("th-autocomplete")).not.toBe null

  it "should add filter to filter set", ->
    expect(@filterSet.length).toBe 1
    expect(@filterSet[0]).toBe instanceof AutocompleteFilter

  it "should set 'trackField' option on delegate", ->
    expect(@controller.delegate.trackField).toBe "id"

  it "should set 'displayField' option on delegate", ->
    expect(@controller.delegate.displayField).toBe "name"

  describe "when model class is undefined", ->
    beforeEach ->
      @filterOptions.autocompleteOptions = {}

    it "should throw an error", ->
      expect(-> compileDirective(validTemplate, {
        @filterSet
        @filterOptions
      })).toThrow()

  describe "when class is invalid", ->
    beforeEach ->
      @filterOptions.autocompleteOptions = {modelClass: "invalid"}

    it "should throw an error", ->
      expect(-> compileDirective(validTemplate, {
        @filterSet
        @filterOptions
      })).toThrow()

  describe "when 'trackField' and 'displayField' are specified", ->
    beforeEach ->
      @filterOptions.autocompleteOptions = {
        modelClass: "Repo"
        trackField: "tracker"
        displayField: "displayer"
      }
      {@element} = compileDirective(validTemplate, {
        @filterSet
        @filterOptions
      })
      @controller = angular.element(
        @element.find("div")
      ).scope().thFilterAutocomplete

    it "should set 'trackField' option on delegate", ->
      expect(@controller.delegate.trackField).toBe "tracker"

    it "should set 'displayField' option on delegate", ->
      expect(@controller.delegate.displayField).toBe "displayer"

  describe "#fetchData", ->
    beforeEach ->
      @updateData = -> return
      spyOn this, "updateData"

    describe "without query params", ->
      it "should call updateData with search term", ->
        searchParam = {searchString: "test"}
        @controller.delegate.fetchData(searchParam, @updateData)

        expect(@updateData).toHaveBeenCalledWith(searchParam)

    describe "with query params", ->
      it "should call updateData with search term and query params", ->
        searchParam = {searchString: "test"}
        queryParams =
          param1: "test1"
          param2: "test2"
        @filterOptions.autocompleteOptions.queryParams = queryParams

        {@element} = compileDirective(validTemplate, {
          @filterSet
          @filterOptions
        })
        @controller = angular.element(
          @element.find("div")
        ).scope().thFilterAutocomplete

        @controller.delegate.fetchData(searchParam, @updateData)

        Object.assign(queryParams, searchParam)
        expect(@updateData).toHaveBeenCalledWith(queryParams)

  describe "when scope is destroyed", ->
    beforeEach ->
      spyOn @filterSet, "remove"
      spyOn @filterSet, "onFilterChange"

    describe "when value is undefined", ->
      it "should remove filter from filter set and not call onFilterChange", ->
        @scope.$destroy()
        expect(@filterSet.remove).toHaveBeenCalled()
        expect(@filterSet.onFilterChange).not.toHaveBeenCalled()

    describe "when value is defined", ->
      beforeEach ->
        @controller.filter.model = {id: "123"}

      it "should remove filter from filter set and call onFilterChange", ->
        @scope.$destroy()
        expect(@filterSet.remove).toHaveBeenCalled()
        expect(@filterSet.onFilterChange).toHaveBeenCalled()

  describe "when 'th.filters.clear' event is received", ->
    it "should clear model", ->
      filter = angular.element(
        @element.find("div")
      ).scope().thFilterAutocomplete.filter
      spyOn filter, "clearValue"
      @scope.$broadcast "th.filters.clear"
      expect(filter.clearValue).toHaveBeenCalled()
