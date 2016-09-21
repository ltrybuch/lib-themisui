{
  compileDirective
} = require "spec_helpers"
moment = require "moment"

describe "ThemisComponents: Directive: thFilterTime", ->
  TimeFilter = FilterSet = timeout = null
  filterSet = filterOptions = filter = element = scope = null
  operatorOptions = [
    {name: "<", value: "<"}
    {name: "=", value: "="}
    {name: ">", value: ">"}
  ]

  validTemplate = """
    <th-filter-time
      filter-set="filterSet"
      filter-options="filterOptions"
      operator-options="operatorOptions"
      >
    </th-filter-time>
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
    inject ($injector, _FilterSet_, _TimeFilter_, $timeout) ->
      FilterSet = _FilterSet_
      TimeFilter = _TimeFilter_
      timeout = $timeout

    filterSet = new FilterSet {
      onFilterChange: -> return
    }

    filterOptions = {
      fieldIdentifier: 'time'
      name: 'time'
    }

    {element, scope} = compileDirective(validTemplate, {
      filterSet
      filterOptions
      operatorOptions
    })
    @controller = angular.element(element.querySelectorAll(".inner")[0]).scope().thFilterTime

  it "should add filter to filter set", ->
    expect(filterSet.length).toBe 1
    expect(filterSet[0]).toBe instanceof TimeFilter

  describe "when initial value is specified", ->
    beforeEach ->
      filterSet = new FilterSet {
        onFilterChange: -> return
      }
      @initialState =
        value: "6:21 PM"
        operator: ">"

      {element, scope} = compileDirective("""
        <th-filter-time
          filter-set="filterSet"
          filter-options="filterOptions"
          operator-options="operatorOptions"
          initial-state="initialState"
          >
        </th-filter-time>
      """
      , {
        filterSet
        filterOptions
        operatorOptions
        @initialState
      })

    it "should parse initial value", ->
      expect(filterSet[0].getState()).toEqual @initialState

  describe "#validateInput", ->
    beforeEach ->
      spyOn @controller.filter, "validate"
      spyOn @controller.filterSet, "onFilterChange"

    it "should validate filter and call 'onFilterChange'", ->
      @controller.validateInput()
      expect(@controller.filter.validate).toHaveBeenCalled()
      expect(@controller.filterSet.onFilterChange).toHaveBeenCalled()

  describe "when enter is pressed on input", ->
    beforeEach ->
      spyOn @controller, "validateInput"

    it "should call 'validateInput'", ->
      setInputValue "10:00"
      keypress = angular.element.Event("keypress")
      keypress.which = 13
      input = element.find "input"
      input.trigger keypress
      timeout.flush()
      expect(@controller.validateInput).toHaveBeenCalled()

  describe "when operator is changed", ->
    beforeEach ->
      spyOn filterSet, "onFilterChange"

    describe "when value is undefined", ->
      it "should not call onFilterChange", ->
        selectOperator operatorOptions[1]
        expect(filterSet.onFilterChange).not.toHaveBeenCalled()

    describe "when value is defined", ->
      beforeEach ->
        @controller.filter.time = moment()

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
        @controller.filter.time = moment()

      it "should remove filter from filter set and call onFilterChange", ->
        scope.$destroy()
        expect(filterSet.remove).toHaveBeenCalled()
        expect(filterSet.onFilterChange).toHaveBeenCalled()

  describe "when 'th.filters.clear' event is received", ->
    it "should clear model", ->
      filter = @controller.filter
      spyOn filter, "clearState"
      scope.$broadcast "th.filters.clear"
      expect(filter.clearState).toHaveBeenCalled()
