describe "ThemisComponents: Service: AutocompleteFilter", ->
  FilterBase = AutocompleteFilter = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($injector, _FilterBase_, _AutocompleteFilter_) ->
    FilterBase = _FilterBase_
    AutocompleteFilter = _AutocompleteFilter_

  describe "#constructor", ->
    beforeEach ->
      @autocompleteFilter = new AutocompleteFilter {
        placeholder: "placeholder"
      }

    it "should set placeholder", ->
      expect(@autocompleteFilter.placeholder).toBe "placeholder"

    it "should inherit from FilterBase", ->
      expect(@autocompleteFilter.prototype).toBe instanceof FilterBase

  describe "#getValue", ->
    describe "when 'trackField' is undefined", ->
      beforeEach ->
        @autocompleteFilter = new AutocompleteFilter

      describe "when model is undefined", ->
        it "should return null", ->
          expect(@autocompleteFilter.getValue()).toBe null

      describe "when model is defined", ->
        it "should return model[id]", ->
          @autocompleteFilter.model = {id: "123"}
          expect(@autocompleteFilter.getValue()).toBe "123"

    describe "when 'trackField' is defined", ->
      it "should return model[trackField]", ->
        @autocompleteFilter = new AutocompleteFilter {
          autocompleteOptions:
            trackField: "test"
        }
        @autocompleteFilter.model = {test: "456"}
        expect(@autocompleteFilter.getValue()).toBe "456"

  describe "#clearValue", ->
    describe "when value is not null", ->
      beforeEach ->
        @autocompleteFilter = new AutocompleteFilter
        @autocompleteFilter.model = {id: "123"}

      it "should set value to null", ->
        expect(@autocompleteFilter.getValue()).not.toBe null
        @autocompleteFilter.clearValue()
        expect(@autocompleteFilter.getValue()).toBe null
