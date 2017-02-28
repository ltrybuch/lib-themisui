{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thFilterSelect", ->
  SelectFilter = FilterSet = timeout = null
  filterSet = filterOptions = filter = options = element = scope = null

  options =  [
    {name: "One", value: "one"}
    {name: "Two", value: "two"}
    {name: "Three", value: "three"}
  ]

  validTemplate = """
    <th-filter-select
      filter-set="filterSet"
      filter-options="filterOptions"
      initial-state="initialState"
      >
    </th-filter-select>
  """

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_, _SelectFilter_, $timeout) ->
      FilterSet = _FilterSet_
      SelectFilter = _SelectFilter_
      timeout = $timeout

    filterSet = new FilterSet {
      onFilterChange: -> return
    }

    filterOptions = {
      name: "name"
      value: 1
      type: "select"

      fieldIdentifier: "id"
      selectOptions: options
    }

    {element, scope} = compileDirective validTemplate, {
      filterSet
      filterOptions
      initialState: {value: "two"}
    }

  it "should have 'select' element", ->
    expect(element[0].querySelector("select")).not.toBe null

  it "should not have label", ->
    expect(element[0].querySelector(".th-label")).toBe null

  it "should add filter to filter set", ->
    expect(filterSet.length).toBe 1
    expect(filterSet[0]).toBe instanceof SelectFilter
    expect(filterSet[0].getState()).toEqual {name: "Two", value: "two"}

  describe "when value is changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    it "should call onFilterChange and update filter", ->
      select = element.find "select"
      select.val options[1].value
      select.triggerHandler "change"
      timeout.flush()
      expect(filterSet[0].getState()).toEqual
        name: options[1].name
        value: options[1].value
      
      expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when `thFilter:destroyed` is broadcast", ->
    beforeEach ->
      spyOn filterSet, "remove"
      spyOn filterSet, "onFilterChange"

    describe "when value is undefined", ->
      beforeEach ->
        filterSet[0].clearState()

      it "should remove filter from filter set and not call onFilterChange", ->
        scope.$broadcast "thFilter:destroyed"
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).not.toHaveBeenCalled()

    describe "when value is selected", ->
      beforeEach ->
        select = element.find "select"
        select.val options[0].value
        select.triggerHandler "change"
        timeout.flush()

      it "should remove filter from filter set and call onFilterChange", ->
        scope.$broadcast "thFilter:destroyed"
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when 'th.filters.clear' event is received", ->
    it "should clear model", ->
      filter = angular.element(
        element.find "div"
      ).scope().thFilterSelect.filter
      spyOn filter, "clearState"
      scope.$broadcast "th.filters.clear"
      expect(filter.clearState).toHaveBeenCalled()
