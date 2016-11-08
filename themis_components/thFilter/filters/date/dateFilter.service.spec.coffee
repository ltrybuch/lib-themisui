moment = require "moment"

describe "ThemisComponents: Service: DateFilter", ->
  FilterBase = DateFilter = dateFilter = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($injector, _FilterBase_, _DateFilter_) ->
    FilterBase = _FilterBase_
    DateFilter = _DateFilter_

  describe "#constructor", ->
    beforeEach ->
      dateFilter = new DateFilter(
        {placeholder: "placeholder"}
        null
        null
        {value: "2016-11-19"}
      )
    it "should return a new DateFilter object", ->
      expect(dateFilter.placeholder).toBe "placeholder"
      expect(dateFilter.model.format("YYYY-MM-DD")).toBe "2016-11-19"

    it "should inherit from FilterBase", ->
      expect(dateFilter.prototype).toBe instanceof FilterBase

    describe "when operatorOptions specified", ->
      describe "and initial state specified", ->
        beforeEach ->
          dateFilter = new DateFilter(
            {placeholder: "placeholder"}
            [{name: "a", value: "b"}, {name: "c", value: "d"}]
            1
            {value: "2016-10-19T00:00:00+00:00", operator: "d"}
          )

        it "returns an object with operator options", ->
          expect(dateFilter.placeholder).toBe "placeholder"
          expect(dateFilter.defaultOperatorIndex).toBe 1
          expect(dateFilter.model.format()).toBe "2016-10-19T00:00:00+00:00"
          expect(dateFilter.operator).toEqual {name: "c", value: "d"}

      describe "but operator is not specified", ->
        it "should not throw an error", ->
          expect(-> new DateFilter(
            null
            [{name: "a", value: "b"}]
            null
            {}
          )).not.toThrow()

      describe "when operatorOptions specified incorrectly", ->
        it "should throw an error", ->
          expect(-> new DateFilter(
            null
            {}
            null
            {}
          )).toThrow()

      describe "but defaultOperatorIndex is invalid", ->
        it "should throw an error", ->
          expect(-> new DateFilter(
            {placeholder: "placeholder"}
            [{name: "a", value: "b"}]
            1
            {value: "2016-10-19T00:00:00+00:00", operator: "b"}
          )).toThrow()

      describe "but initialState Operator is invalid", ->
        it "should throw an error", ->
          expect(-> new DateFilter(
            {placeholder: "placeholder"}
            [{name: "a", value: "b"}]
            null
            {value: "2016-10-19T00:00:00+00:00", operator: 1}
          )).toThrow()

  describe "#getState", ->
    describe "when no initial value is provided", ->
      it "should return null", ->
        dateFilter = new DateFilter
        expect(dateFilter.getState()).toBe null

    describe "when initial value is provided", ->
      it "should return value", ->
        dateFilter = new DateFilter(
          null
          null
          null
          {value: "2016-10-19T00:00:00+00:00"}
        )
        expect(dateFilter.getState()).toEqual {value: "2016-10-19T00:00:00+00:00"}

  describe "#clearState", ->
    beforeEach ->
      dateFilter = new DateFilter(
        null
        [{name: "=", value: "="}, {name: ">", value: ">"}]
        null
        null
      )

    describe "when value is not null", ->
      beforeEach ->
        dateFilter.model = moment "2016-10-19T00:00:00+00:00"

      it "should set value to null", ->
        expect(dateFilter.getState()).not.toBe null
        dateFilter.clearState()
        expect(dateFilter.getState()).toBe null

    describe "when operator is not null", ->
      beforeEach ->
        dateFilter.operator = dateFilter.operatorOptions[1]

      it "should set operator to default", ->
        dateFilter.clearState()
        expect(dateFilter.operator.value).toBe "="
