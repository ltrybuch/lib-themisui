moment = require "moment"
{
  compileDirective
} = require "spec_helpers"

describe "ThemisComponents: Directive: thFilterDate", ->
  DateFilter = FilterSet = timeout = null
  filterSet = filterOptions = filter = element = scope = null
  operatorOptions = [
    {name: "Before", value: "<"}
    {name: "On", value: "="}
    {name: "After", value: ">"}
  ]

  validTemplate = """
    <th-filter-date
      filter-set="filterSet"
      filter-options="filterOptions"
      operator-options="operatorOptions"
      >
    </th-filter-date>
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
    inject ($injector, _FilterSet_, _DateFilter_, $timeout) ->
      FilterSet = _FilterSet_
      DateFilter = _DateFilter_
      timeout = $timeout

    filterSet = new FilterSet {
      onFilterChange: -> return
    }

    filterOptions = {
      fieldIdentifier: 'aDate'
      name: 'date'
    }

    {element, scope} = compileDirective(validTemplate, {
      filterSet
      filterOptions
      operatorOptions
    })

  it "should add filter to filter set", ->
    expect(filterSet.length).toBe 1
    expect(filterSet[0]).toBe instanceof DateFilter

  describe "when initial value is specified", ->
    beforeEach ->
      filterSet = new FilterSet {
        onFilterChange: -> return
      }

      {element, scope} = compileDirective("""
        <th-filter-date
          filter-set="filterSet"
          filter-options="filterOptions"
          operator-options="operatorOptions"
          initial-state="initialState"
          >
        </th-filter-date>
      """
      , {
        filterSet
        filterOptions
        operatorOptions
        initialState:
          value: "2016-10-19T00:00:00+00:00"
          operator: ">"
      })

    it "should parse initial value", ->
      expect(filterSet[0].operator.value).toEqual ">"
      expect(moment(filterSet[0].model).format()).toBe "2016-10-19T00:00:00+00:00"

  describe "when default operator index is specified", ->
    beforeEach ->
      filterSet = new FilterSet {
        onFilterChange: -> return
      }

      {element, scope} = compileDirective("""
        <th-filter-date
          filter-set="filterSet"
          filter-options="filterOptions"
          operator-options="operatorOptions"
          default-operator-index="1"
          >
        </th-filter-date>
      """
      , {
        filterSet
        filterOptions
        operatorOptions
      })

    it "should parse default operator index", ->
      expect(filterSet[0].operator.value).toEqual "="

  describe "when value is changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    it "should call onFilterChange and update filter value", ->
      setInputValue "2016-09-19T00:00:00+00:00"
      keypress = angular.element.Event("keypress")
      keypress.which = 9
      input = element.find "input"
      input.trigger keypress

      expect(filterSet.onFilterChange).toHaveBeenCalled()
      expect(filterSet[0].getState()).toEqual
        value: "2016-09-19T00:00:00+00:00"
        operator: "<"

  describe "when operator is changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    describe "when value is undefined", ->
      it "should not call onFilterChange", ->
        selectOperator operatorOptions[1]
        expect(filterSet.onFilterChange).not.toHaveBeenCalled()

    describe "when value is defined", ->
      beforeEach ->
        setInputValue "2015-10-21T00:00:00+00:00"

      it "should call onFilterChange", ->
        selectOperator operatorOptions[1]
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
        setInputValue "2015-10-21T00:00:00+00:00"

      it "should remove filter from filter set and call onFilterChange", ->
        scope.$destroy()
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when 'th.filters.clear' event is received", ->
    it "should clear model", ->
      filter = angular.element(
        element.find("div")
      ).scope().thFilterDate.filter
      spyOn filter, "clearState"
      scope.$broadcast "th.filters.clear"
      expect(filter.clearState).toHaveBeenCalled()
