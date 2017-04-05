{
  compileDirective
} = require "spec_helpers"

# Defined here because the directive uses $injector to instantiate model class.
angular.module "ThemisComponents"
.service "Repo", (DataSource) ->
  create: ->
    DataSource.createDataSource {
      serverFiltering: true
      transport: {
        read: {
          url: "//fake.url/bork"
          type: "get"
          dataType: "json"
        },
        parameterMap: (data, action) ->
          if action is "read" and data.filter
            return {
              q: if data.filter.filters[0] then data.filter.filters[0].value else ""
            }
          else
            return data
      },
      schema: {
        data: "items"
      }
    }

describe "ThemisComponents: Directive: thFilterAutocomplete", ->
  AutocompleteFilter = FilterSet = timeout = null

  validTemplate = """
    <th-filter-autocomplete
      filter-set="filterSet"
      filter-options="filterOptions"
      >
    </th-filter-autocomplete>
  """

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_, _AutocompleteFilter_, $timeout) ->
      FilterSet = _FilterSet_
      AutocompleteFilter = _AutocompleteFilter_
      timeout = $timeout

    @filterSet = new FilterSet {
      onFilterChange: -> return
    }

    @filterOptions = {
      name: "repo"
      type: "autocomplete"

      fieldIdentifier: "id"

      autocompleteOptions:
        modelClass: "Repo"
        queryField: "searchString"
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

  it "should set 'trackField' option on options", ->
    expect(@controller.options.trackField).toBe "id"

  it "should set 'displayField' option on options", ->
    expect(@controller.options.displayField).toBe "name"

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

    it "should set 'trackField' option on options", ->
      expect(@controller.options.trackField).toBe "tracker"

    it "should set 'displayField' option on options", ->
      expect(@controller.options.displayField).toBe "displayer"

  describe "when `thFilter:destroyed` is broadcast", ->
    beforeEach ->
      spyOn @filterSet, "remove"
      spyOn @filterSet, "onFilterChange"

    describe "when value is undefined", ->
      it "should remove filter from filter set and not call onFilterChange", ->
        @scope.$broadcast "thFilter:destroyed"
        expect(@filterSet.remove).toHaveBeenCalled()
        expect(@filterSet.onFilterChange).not.toHaveBeenCalled()

    describe "when value is defined", ->
      beforeEach ->
        @controller.filter.model = {id: "123"}

      it "should remove filter from filter set and call onFilterChange", ->
        @scope.$broadcast "thFilter:destroyed"
        expect(@filterSet.remove).toHaveBeenCalled()
        expect(@filterSet.onFilterChange).toHaveBeenCalled()

  describe "when 'th.filters.clear' event is received", ->
    it "should clear model", ->
      filter = angular.element(
        @element.find("div")
      ).scope().thFilterAutocomplete.filter
      spyOn filter, "clearState"
      @scope.$broadcast "th.filters.clear"
      expect(filter.clearState).toHaveBeenCalled()
