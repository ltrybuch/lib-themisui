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

  describe "#getValue", ->
    describe "when no initial value is provided", ->
      it "should return null", ->
        inputFilter = new InputFilter
        expect(inputFilter.getValue()).toBe null

    describe "when initial value is provided", ->
      it "should return value", ->
        inputFilter = new InputFilter(null, "value")
        expect(inputFilter.getValue()).toBe "value"

  describe "#clearValue", ->
    beforeEach ->
      inputFilter = new InputFilter

    describe "when value is not null", ->
      beforeEach ->
        inputFilter.model = "test"

      it "should set value to null", ->
        expect(inputFilter.getValue()).not.toBe null
        inputFilter.clearValue()
        expect(inputFilter.getValue()).toBe null
