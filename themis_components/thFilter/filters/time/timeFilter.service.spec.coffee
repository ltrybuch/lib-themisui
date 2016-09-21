describe "ThemisComponents: Service: TimeFilter", ->
  FilterBase = TimeFilter = timeFilter = null

  defaultOperators = [
    {name: '<', value: '<'},
    {name: '=', value: '='}
    {name: '>', value: '>'}
  ]

  runValidation = (input) ->
    filter = new TimeFilter {}, defaultOperators

    filter.model = input
    valid = filter.validate()

    return {
      valid: valid
      model: filter.model
      time: filter.time isnt null
    }

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($injector, _FilterBase_, _TimeFilter_) ->
    FilterBase = _FilterBase_
    TimeFilter = _TimeFilter_

  describe "#constructor", ->
    describe "when operatorOptions is not specified", ->
      it "should throw an error", ->
        expect(-> new TimeFilter).toThrow()

    describe "when defaultOperatorIndex is invalid", ->
      it "should throw an error", ->
        expect(-> new TimeFilter {}, defaultOperators, 3).toThrow()

    describe "when parameters are valid", ->
      describe "when defaultOperatorIndex is not specified", ->
        beforeEach ->
          timeFilter = new TimeFilter {placeholder: "placeholder"}, defaultOperators

        it "should return a new NumberFilter object", ->
          expect(timeFilter.placeholder).toBe "placeholder"

        it "should inherit from FilterBase", ->
          expect(timeFilter.prototype).toBe instanceof FilterBase

        it "should set operator to first operator", ->
          expect(timeFilter.operator.value).toBe "<"

      describe "when defaultOperatorIndex is specified", ->
        beforeEach ->
          timeFilter = new TimeFilter {}, defaultOperators, 1

        it "should set operator to operator at index 1", ->
          expect(timeFilter.operator.value).toBe "="

    describe "when initial value is specified", ->
      beforeEach ->
        @initialState =
          value: "12:01"
          operator: ">"

        @filter = new TimeFilter {}, defaultOperators, 0, @initialState

      it "should parse operator and value", ->
        expect(@filter.getState()).toEqual @initialState

  describe "#validate", ->
    it "should return expected result", ->
      expect(runValidation(null)).toEqual {valid: true, model: null, time: false}
      expect(runValidation("")).toEqual {valid: true, model: "", time: false}
      expect(runValidation("invalid")).toEqual {valid: false, model: "invalid", time: false}
      expect(runValidation("4:1a")).toEqual {valid: true, model: "4:01 AM", time: true}
      expect(runValidation("4:1z")).toEqual {valid: false, model: "4:1z", time: false}
      expect(runValidation("010AM")).toEqual {valid: true, model: "1:00 AM", time: true}
      expect(runValidation("2361P")).toEqual {valid: false, model: "2361P", time: false}
      expect(runValidation("23:59 pm")).toEqual {valid: true, model: "11:59 PM", time: true}
      expect(runValidation("35:00 A")).toEqual {valid: false, model: "35:00 A", time: false}
      expect(runValidation("0402P")).toEqual {valid: true, model: "4:02 PM", time: true}
      expect(runValidation("945P")).toEqual {valid: false, model: "945P", time: false}
      expect(runValidation("13PM")).toEqual {valid: true, model: "1:00 PM", time: true}
      expect(runValidation("25A")).toEqual {valid: false, model: "25A", time: false}
      expect(runValidation("3 am")).toEqual {valid: true, model: "3:00 AM", time: true}
      expect(runValidation("4 q")).toEqual {valid: false, model: "4 q", time: false}
      expect(runValidation("20:3")).toEqual {valid: true, model: "8:03 PM", time: true}
      expect(runValidation("16:90")).toEqual {valid: false, model: "16:90", time: false}
      expect(runValidation("049")).toEqual {valid: true, model: "4:09 AM", time: true}
      expect(runValidation("02900")).toEqual {valid: false, model: "02900", time: false}
      expect(runValidation("24")).toEqual {valid: true, model: "12:00 AM", time: true}
      expect(runValidation("30")).toEqual {valid: false, model: "30", time: false}

  describe "#getState", ->
    beforeEach ->
      timeFilter = new TimeFilter {}, defaultOperators

    describe "when initialized", ->
      it "should return null", ->
        expect(timeFilter.getState()).toBe null

      describe "when operator is not default", ->
        beforeEach ->
          timeFilter.operator = timeFilter.operatorOptions[0]

        it "should return null", ->
          expect(timeFilter.getState()).toBe null

    describe "when value is not null", ->
      beforeEach ->
        timeFilter.time = {}
        timeFilter.model = "123"
        timeFilter.validate()

      it "should return value and default operator", ->
        expect(timeFilter.getState()).toEqual {value: "12:03", operator: "<"}

      describe "when operator is not default", ->
        beforeEach ->
          timeFilter.operator = timeFilter.operatorOptions[1]

        it "should return value and operator", ->
          expect(timeFilter.getState()).toEqual {value: "12:03", operator: "="}

  describe "#clearState", ->
    beforeEach ->
      timeFilter = new TimeFilter {}, defaultOperators

    describe "when value is not null", ->
      beforeEach ->
        timeFilter.model = "12:32A"
        timeFilter.validate()

      it "should set value to null", ->
        expect(timeFilter.getState()).not.toBe null
        timeFilter.clearState()
        expect(timeFilter.getState()).toBe null

    describe "when operator is not null", ->
      beforeEach ->
        timeFilter.operator = timeFilter.operatorOptions[1]

      it "should set operator to default", ->
        timeFilter.clearState()
        expect(timeFilter.operator.value).toBe "<"
