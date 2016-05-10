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
      name: 'name'
      value: 1
      type: 'input'

      fieldIdentifier: 'id'
    }

    {element, scope} = compileDirective(validTemplate, {
      filterSet
      filterOptions
    })

  it "should have 'input' element", ->
    expect(element[0].querySelector("input")).not.toBe null

  it "should not have label", ->
    expect(element[0].querySelector(".th-label")).toBe null

  it "should add filter to filter set", ->
    expect(filterSet.length).toBe 1
    expect(filterSet[0]).toBe instanceof InputFilter

  describe "when value is changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    it "should call onFilterChange and update filter", ->
      input = element.find "input"
      input.val "test"
      input.triggerHandler "change"
      expect(filterSet[0].getValue()).toBe "test"
      keypress = angular.element.Event("keypress")
      keypress.which = 13
      input.trigger keypress
      timeout.flush()
      expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when scope is destroyed", ->
    beforeEach ->
      spyOn filterSet, "remove"
      spyOn filterSet, "onFilterChange"

    describe "when value is undefined", ->
      it "should remove filter from filter set and not call onFilterChange", ->
        scope.$destroy()
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).not.toHaveBeenCalled()

    describe "when value is defined", ->
      beforeEach ->
        input = element.find "input"
        input.val "test"
        input.triggerHandler "change"

      it "should remove filter from filter set and call onFilterChange", ->
        scope.$destroy()
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when 'th.filters.clear' event is received", ->
    it "should clear model", ->
      filter = angular.element(
        element.find("div")
      ).scope().thFilterInput.filter
      spyOn filter, "clearValue"
      scope.$broadcast "th.filters.clear"
      expect(filter.clearValue).toHaveBeenCalled()
