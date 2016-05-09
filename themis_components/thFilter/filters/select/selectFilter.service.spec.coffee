describe "ThemisComponents: Service: SelectFilter", ->
  FilterBase = SelectFilter = selectFilter = httpBackend = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($injector, _FilterBase_, _SelectFilter_, $httpBackend) ->
    FilterBase = _FilterBase_
    SelectFilter = _SelectFilter_
    httpBackend = $httpBackend

  describe "#constructor", ->
    describe "when specifying options array", ->
      emptyData = []
      beforeEach ->
        selectFilter = new SelectFilter {
          placeholder: "placeholder"
          selectOptions: emptyData
        }

      it "should return a new SelectFilter object", ->
        expect(selectFilter.placeholder).toBe "placeholder"
        expect(selectFilter.options).toBe emptyData

      it "should inherit from FilterBase", ->
        expect(selectFilter.prototype).toBe instanceof FilterBase

    describe "when specifying options url", ->
      describe "when using default options name and value field", ->
        beforeEach ->
          httpBackend.when("GET", "/options.json").respond """[
            {"name":"n0", "value":"v0"},
            {"name":"n1", "value":"v1"}
          ]"""
          selectFilter = new SelectFilter {
            selectOptionsUrl: "/options.json"
          }

        it "should fetch options from url", ->
          httpBackend.flush()
          httpBackend.expectGET "/options.json"
          expect(selectFilter.options.length).toBe 2
          expect(selectFilter.options[0].name).toBe "n0"
          expect(selectFilter.options[1].value).toBe "v1"

      describe "when specifying options name and value field", ->
        beforeEach ->
          httpBackend.when("GET", "/options.json").respond """[
            {"testName":"n0", "testValue":"v0"},
            {"testName":"n1", "testValue":"v1"}
          ]"""
          selectFilter = new SelectFilter {
            selectOptionsUrl: "/options.json"
            selectOptionsNameField: "testName"
            selectOptionsValueField: "testValue"
          }

        it "should fetch options from url", ->
          httpBackend.flush()
          expect(selectFilter.options.length).toBe 2
          expect(selectFilter.options[0].name).toBe "n0"
          expect(selectFilter.options[1].value).toBe "v1"

  describe "#getValue", ->
    it "return undefined", ->
      selectFilter = new SelectFilter
      expect(selectFilter.getValue()).toBe undefined
