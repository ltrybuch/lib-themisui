describe "ThemisComponents: Service: NumberFilter", ->
  FilterBase = NumberFilter = numberFilter = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($injector, _FilterBase_, _NumberFilter_) ->
    FilterBase = _FilterBase_
    NumberFilter = _NumberFilter_

  describe "#constructor", ->
    describe "when operatorOptions is not specified", ->
      it "should throw an error", ->
        expect(-> new NumberFilter {placeholder: "placeholder"}).toThrow()

    describe "when defaultOperatorIndex is invalid", ->
      it "should throw an error", ->
        expect(-> new NumberFilter(
          {placeholder: "placeholder"}
          [{name: 'a', value: 'b'}]
          2
        )).toThrow()

    describe "when parameters are valid", ->
      describe "when defaultOperatorIndex is not specified", ->
        beforeEach ->
          numberFilter = new NumberFilter {
            placeholder: "placeholder"
          }, [
            {name: 'a', value: 'a'},
            {name: 'b', value: 'b'}
          ]

        it "should return a new NumberFilter object", ->
          expect(numberFilter.placeholder).toBe "placeholder"

        it "should inherit from FilterBase", ->
          expect(numberFilter.prototype).toBe instanceof FilterBase

        it "should set operator to first operator", ->
          expect(numberFilter.operator.value).toBe "a"

      describe "when defaultOperatorIndex is specified", ->
        beforeEach ->
          numberFilter = new NumberFilter {
            placeholder: "placeholder"
          }, [
            {name: 'a', value: 'a'},
            {name: 'b', value: 'b'}
          ],
          1

        it "should set operator to operator at index 1", ->
          expect(numberFilter.operator.value).toBe "b"

  describe "#getValue", ->
    beforeEach ->
      numberFilter = new NumberFilter {}, [
        {name: '=', value: '='},
        {name: '>', value: '>'}
      ]

    describe "when initialized", ->
      it "should return null", ->
        expect(numberFilter.getValue()).toBe null

      describe "when operator is not default", ->
        beforeEach ->
          numberFilter.operator = numberFilter.operatorOptions[0]

        it "should return null", ->
          expect(numberFilter.getValue()).toBe null

    describe "when value is not null", ->
      beforeEach ->
        numberFilter.model = "test"

      it "should return default operator prepended to value", ->
        expect(numberFilter.getValue()).toBe "=test"

      describe "when operator is not default", ->
        beforeEach ->
          numberFilter.operator = numberFilter.operatorOptions[1]

        it "should return operator preprended to value", ->
          expectedValue = numberFilter.operatorOptions[1].value + "test"
          expect(numberFilter.getValue()).toBe expectedValue

  describe "#clearValue", ->
    beforeEach ->
      numberFilter = new NumberFilter {}, [
        {name: '=', value: '='},
        {name: '>', value: '>'}
      ]

    describe "when value is not null", ->
      beforeEach ->
        numberFilter.model = "test"

      it "should set value to null", ->
        numberFilter.clearValue()
        expect(numberFilter.model).toBe null

    describe "when operator is not null", ->
      beforeEach ->
        numberFilter.operator = numberFilter.operatorOptions[1]

      it "should set operator to default", ->
        numberFilter.clearValue()
        expect(numberFilter.operator.value).toBe "="
