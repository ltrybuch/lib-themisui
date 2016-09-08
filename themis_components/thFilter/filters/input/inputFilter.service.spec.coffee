describe "ThemisComponents: Service: InputFilter", ->
  FilterBase = InputFilter = inputFilter = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($injector, _FilterBase_, _InputFilter_) ->
    FilterBase = _FilterBase_
    InputFilter = _InputFilter_

  describe "#constructor", ->
    beforeEach ->
      inputFilter = new InputFilter {
        placeholder: "placeholder"
      }

    it "should return a new InputFilter object", ->
      expect(inputFilter.placeholder).toBe "placeholder"

    it "should inherit from FilterBase", ->
      expect(inputFilter.prototype).toBe instanceof FilterBase

  describe "#getState", ->
    describe "when no initial value is provided", ->
      it "should return null", ->
        inputFilter = new InputFilter
        expect(inputFilter.getState()).toBe null

    describe "when initial value is provided", ->
      it "should return value", ->
        inputFilter = new InputFilter(null, {value: "value"})
        expect(inputFilter.getState()).toEqual {value: "value"}

  describe "#clearState", ->
    beforeEach ->
      inputFilter = new InputFilter

    describe "when value is not null", ->
      beforeEach ->
        inputFilter.model = "test"

      it "should set value to null", ->
        expect(inputFilter.getState()).not.toBe null
        inputFilter.clearState()
        expect(inputFilter.getState()).toBe null
