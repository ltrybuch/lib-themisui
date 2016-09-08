describe "ThemisComponents: Service: AutocompleteFilter", ->
  FilterBase = AutocompleteFilter = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($injector, _FilterBase_, _AutocompleteFilter_) ->
    FilterBase = _FilterBase_
    AutocompleteFilter = _AutocompleteFilter_

  describe "#constructor", ->
    beforeEach ->
      @autocompleteFilter = new AutocompleteFilter(placeholder: "placeholder")

    it "should set placeholder", ->
      expect(@autocompleteFilter.placeholder).toBe "placeholder"

    it "should inherit from FilterBase", ->
      expect(@autocompleteFilter.prototype).toBe instanceof FilterBase

  describe "#getState", ->
    beforeEach ->
      @autocompleteFilter = new AutocompleteFilter()

    describe "when model is undefined", ->
      it "should return null", ->
        expect(@autocompleteFilter.getState()).toBe null

    describe "when model is defined", ->
      it "should return value as model[id]", ->
        @autocompleteFilter.model = {id: "123", name: "test"}
        expect(@autocompleteFilter.getState()).toEqual {name: "test", value: "123"}

    describe "when 'displayField' is defined", ->
      it "should return name as model[displayField]", ->
        @autocompleteFilter = new AutocompleteFilter(null, null, "displayField")
        @autocompleteFilter.model = {id: "456", displayField: "test"}
        expect(@autocompleteFilter.getState()).toEqual {name: "test", value: "456"}

    describe "when 'trackField' is defined", ->
      it "should return value as model[trackField]", ->
        @autocompleteFilter = new AutocompleteFilter(null, null, null, "trackField")
        @autocompleteFilter.model = {trackField: "789", name: "test"}
        expect(@autocompleteFilter.getState()).toEqual {name: "test", value: "789"}

    describe "when 'initialState' is defined", ->
      it "should return initial value", ->
        @autocompleteFilter = new AutocompleteFilter(null, {value: "000", name: "init"})
        expect(@autocompleteFilter.getState()).toEqual {name: "init", value: "000"}

  describe "#clearState", ->
    describe "when value is not null", ->
      beforeEach ->
        @autocompleteFilter = new AutocompleteFilter()
        @autocompleteFilter.model = {id: "123"}

      it "should set value to null", ->
        expect(@autocompleteFilter.getState()).not.toBe null
        @autocompleteFilter.clearState()
        expect(@autocompleteFilter.getState()).toBe null
