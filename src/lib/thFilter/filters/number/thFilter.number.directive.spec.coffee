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
      fieldIdentifier: "id"
      name: "number"
    }

    {element, scope} = compileDirective validTemplate, {
      filterSet
      filterOptions
      operatorOptions
    }

  it "should add filter to filter set", ->
    expect(filterSet.length).toBe 1
    expect(filterSet[0]).toBe instanceof NumberFilter

  describe "when initial value is specified", ->
    beforeEach ->
      filterSet = new FilterSet {
        onFilterChange: -> return
      }

      {element, scope} = compileDirective """
        <th-filter-number
          filter-set="filterSet"
          filter-options="filterOptions"
          operator-options="operatorOptions"
          initial-state="initialState"
          >
        </th-filter-number>
      """
      , {
        filterSet
        filterOptions
        operatorOptions
        initialState:
          value: -1234.56
          operator: ">"
      }

    it "should parse initial value", ->
      expect(filterSet[0].operator.value).toEqual ">"
      expect(filterSet[0].model).toBe -1234.56

  describe "when value is not changed", ->
    beforeEach ->
      filterSet = new FilterSet {
        onFilterChange: -> return
      }

      {element, scope} = compileDirective """
        <th-filter-number
          filter-set="filterSet"
          filter-options="filterOptions"
          operator-options="operatorOptions"
          initial-state="initialState"
          >
        </th-filter-number>
      """
      , {
        filterSet
        filterOptions
        operatorOptions
        initialState:
          value: -1234.56
          operator: "<"
      }
      spyOn filterSet, "onFilterChange"

    it "should NOT call onFilterChange and update filter value", ->
      keypress = angular.element.Event "keypress"
      keypress.which = 13
      input = element.find "input"
      input.trigger keypress
      timeout.flush()
      expect(filterSet.onFilterChange).not.toHaveBeenCalled()
      expect(filterSet[0].getState()).toEqual {value: -1234.56, operator: "<"}

  describe "when value is changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    it "should call onFilterChange and update filter value", ->
      setInputValue "1000"
      keypress = angular.element.Event "keypress"
      keypress.which = 13
      input = element.find "input"
      input.trigger keypress
      timeout.flush()
      expect(filterSet.onFilterChange).toHaveBeenCalled()
      expect(filterSet[0].getState()).toEqual {value: 1000, operator: "<"}

  describe "when operator is changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    describe "when value is undefined", ->
      it "should not call onFilterChange", ->
        selectOperator operatorOptions[1]
        expect(filterSet.onFilterChange).not.toHaveBeenCalled()

    describe "when value is defined", ->
      beforeEach ->
        setInputValue "1000"

      it "should call onFilterChange", ->
        selectOperator operatorOptions[1]
        expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when `thFilter:destroyed` is broadcast", ->
    beforeEach ->
      spyOn filterSet, "remove"
      spyOn filterSet, "onFilterChange"

    describe "when value is undefined", ->
      it "should remove filter from filter set and not call onFilterChange", ->
        scope.$broadcast "thFilter:destroyed"
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).not.toHaveBeenCalled()

    describe "when value is defined", ->
      beforeEach ->
        setInputValue "1000"

      it "should remove filter from filter set and call onFilterChange", ->
        scope.$broadcast "thFilter:destroyed"
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when 'th.filters.clear' event is received", ->
    it "should clear model", ->
      filter = angular.element(
        element.find "div"
      ).scope().thFilterNumber.filter
      spyOn filter, "clearState"
      scope.$broadcast "th.filters.clear"
      expect(filter.clearState).toHaveBeenCalled()
