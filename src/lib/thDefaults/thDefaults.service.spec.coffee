getDefaults = ->
  thDefaults = null
  inject (_thDefaults_) ->
    thDefaults = _thDefaults_

  return thDefaults

describe "ThemisComponents: Service: thDefaults", ->
  beforeEach ->
    angular.mock.module "ThemisComponents"

  describe "Syntax", ->
    it "#entries()", ->
      thDefaults = getDefaults()
      expect(thDefaults.entries() instanceof Object).toBe true

    it "#get(key<String) → value<Object>", ->
      thDefaults = getDefaults()
      thDefaults.set "foo", "bar"
      expect(thDefaults.get("foo")).toBe thDefaults.entries()["foo"]

    it "#set(key<String>, value<Object>)", ->
      thDefaults = getDefaults()
      thDefaults.set "foo", "bar"
      expect(thDefaults.get("foo")).toBe "bar"

    it "#set(collection<Object>)", ->
      thDefaults = getDefaults()
      thDefaults.set
        foo: "bar"
        sean: "is awesome"
      expect(thDefaults.get("foo")).toBe "bar"
      expect(thDefaults.get("sean")).toBe "is awesome"

  describe "Preset defaults", ->
    it "dateFormat should be 'yyyy-MM-dd'", ->
      thDefaults = getDefaults()
      expect(thDefaults.get("dateFormat")).toBe "yyyy-MM-dd"
