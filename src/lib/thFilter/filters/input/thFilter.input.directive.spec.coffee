{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thFilterInput", ->
  InputFilter = FilterSet = timeout = null
  filterSet = filterOptions = filter = element = scope = null

  validTemplate = """
    <th-filter-input
      filter-set="filterSet"
      filter-options="filterOptions"
      initial-state="initialState"
      >
    </th-filter-input>
  """

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_, _InputFilter_, $timeout) ->
      FilterSet = _FilterSet_
      InputFilter = _InputFilter_
      timeout = $timeout

    filterSet = new FilterSet {
      onFilterChange: -> return
    }

    filterOptions = {
      name: "name"
      value: 1
      type: "input"

      fieldIdentifier: "id"
    }

    {element, scope} = compileDirective validTemplate, {
      filterSet
      filterOptions
      initialState: {value: "value"}
    }

  it "should have 'input' element", ->
    expect(element[0].querySelector("input")).not.toBe null

  it "should not have label", ->
    expect(element[0].querySelector(".th-label")).toBe null

  it "should add filter to filter set", ->
    expect(filterSet.length).toBe 1
    expect(filterSet[0]).toBe instanceof InputFilter
    expect(filterSet[0].getState()).toEqual {value: "value"}

  describe "when value is changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    it "should call onFilterChange and update filter", ->
      input = element.find "input"
      input.val "test"
      input.triggerHandler "change"
      expect(filterSet[0].getState()).toEqual {value: "test"}
      keypress = angular.element.Event "keypress"
      keypress.which = 13
      input.trigger keypress
      timeout.flush()
      expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when value is NOT changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    it "should NOT call onFilterChange and update filter", ->
      input = element.find "input"
      input.val "value"
      input.triggerHandler "change"
      expect(filterSet[0].getState()).toEqual {value: "value"}
      keypress = angular.element.Event "keypress"
      keypress.which = 13
      input.trigger keypress
      timeout.flush()
      expect(filterSet.onFilterChange).not.toHaveBeenCalled()

  describe "when `thFilter:destroyed` is broadcast", ->
    beforeEach ->
      spyOn filterSet, "remove"
      spyOn filterSet, "onFilterChange"

    describe "when value is undefined", ->
      beforeEach ->
        input = element.find "input"
        input.val null
        input.triggerHandler "change"

      it "should remove filter from filter set and not call onFilterChange", ->
        scope.$broadcast "thFilter:destroyed"
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).not.toHaveBeenCalled()

    describe "when value is defined", ->
      it "should remove filter from filter set and call onFilterChange", ->
        scope.$broadcast "thFilter:destroyed"
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when 'th.filters.clear' event is received", ->
    it "should clear model", ->
      filter = angular.element(
        element.find "div"
      ).scope().thFilterInput.filter
      spyOn filter, "clearState"
      scope.$broadcast "th.filters.clear"
      expect(filter.clearState).toHaveBeenCalled()
