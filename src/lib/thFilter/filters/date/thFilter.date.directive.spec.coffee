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
    datepicker = input.data "kendoDatePicker"
    datepicker.value value
    datepicker.trigger "change"

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
      dateFormat = "MM/DD/YYYY"
      input = element.find "input"
      today = moment().date().toString()
      $(input).triggerHandler "click"
      $today = $ "table td a:contains('#{ today }')"
      expectedOperator = "<"
      expectedFilterValue = moment().format dateFormat

      # execute
      $today.click()

      # assert
      actualFilterSet = filterSet[0].getState()
      actualFilterValue = moment(actualFilterSet.value).format dateFormat
      actualFilterOperator = actualFilterSet.operator

      expect(filterSet.onFilterChange).toHaveBeenCalled()
      expect(actualFilterValue).toEqual expectedFilterValue
      expect(actualFilterOperator).toEqual expectedOperator


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
        setInputValue "2015-10-21T00:00:00+00:00"

      it "should remove filter from filter set and call onFilterChange", ->
        scope.$broadcast "thFilter:destroyed"
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
