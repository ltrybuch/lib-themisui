describe "ThemisComponents: Service: FilterBase", ->
  FilterBase = filterBase = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($injector, _FilterBase_) ->
    FilterBase = _FilterBase_

  describe "#constructor", ->
    it "should return a new FilterBase object", ->
      filterBase = new FilterBase {
        fieldIdentifier: "id"
        name: "name"
      }
      expect(filterBase.fieldIdentifier).toBe "id"
      expect(filterBase.name).toBe "name"

  describe "#getValue", ->
    it "should throw an error when called on base class", ->
      filterBase = new FilterBase
      expect(-> filterBase.getValue()).toThrow()
