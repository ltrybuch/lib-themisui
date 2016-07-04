{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thFilterNumber", ->
  NumberFilter = FilterSet = timeout = null
  filterSet = filterOptions = filter = element = scope = null
  operatorOptions = [
    {name: "<", value: "<"}
    {name: "=", value: "="}
    {name: ">", value: ">"}
  ]

  validTemplate = """
    <th-filter-number
      filter-set="filterSet"
      filter-options="filterOptions"
      operator-options="operatorOptions"
      >
    </th-filter-number>
  """

  setInputValue = (value) ->
    input = element.find "input"
    input.val value
    input.triggerHandler "change"

  selectOperator = (option) ->
    select = element.find "select"
    select.val option.value
    select.triggerHandler "change"
    timeout.flush()

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject ($injector, _FilterSet_, _NumberFilter_, $timeout) ->
      FilterSet = _FilterSet_
      NumberFilter = _NumberFilter_
      timeout = $timeout

    filterSet = new FilterSet {
      onFilterChange: -> return
    }

    filterOptions = {
      fieldIdentifier: 'id'
      name: 'number'
    }

    {element, scope} = compileDirective(validTemplate, {
      filterSet
      filterOptions
      operatorOptions
    })

  it "should add filter to filter set", ->
    expect(filterSet.length).toBe 1
    expect(filterSet[0]).toBe instanceof NumberFilter

  describe "when value is changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    it "should call onFilterChange and update filter value", ->
      setInputValue "1000"
      keypress = angular.element.Event("keypress")
      keypress.which = 13
      input = element.find "input"
      input.trigger keypress
      timeout.flush()
      expect(filterSet.onFilterChange).toHaveBeenCalled()
      expect(filterSet[0].getValue()).toBe "<1000"

  describe "when operator is changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    describe "when value is undefined", ->
      it "should not call onFilterChange", ->
        selectOperator operatorOptions[1].value
        expect(filterSet.onFilterChange).not.toHaveBeenCalled()

    describe "when value is defined", ->
      beforeEach ->
        setInputValue "1000"

      it "should call onFilterChange", ->
        selectOperator operatorOptions[1].value
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
        setInputValue "1000"

      it "should remove filter from filter set and call onFilterChange", ->
        scope.$destroy()
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when 'th.filters.clear' event is received", ->
    it "should clear model", ->
      filter = angular.element(
        element.find("div")
      ).scope().thFilterNumber.filter
      spyOn filter, "clearValue"
      scope.$broadcast "th.filters.clear"
      expect(filter.clearValue).toHaveBeenCalled()
