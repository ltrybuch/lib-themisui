context = describe

describe 'ThemisComponents: Component: thMetaLoader', ->
  controller = $componentController = rootScope = null

  beforeEach ->
    angular.mock.module 'ThemisComponents'

  beforeEach inject (_$componentController_, $rootScope) ->
    $componentController = _$componentController_
    rootScope = $rootScope

  beforeEach ->
    controller = $componentController "thMetaLoader"

  context "when component is initialized", ->
    it "exposes a lazyPromises array", ->
      expect(controller.lazyPromises).toEqual []

    it "exposes a loading value and sets to true", ->
      expect(controller.loading).toEqual true

  describe "#registerWithMetaLoader", ->
    it "adds a promise to lazyPromises", ->
      controller.registerWithMetaLoader()
      expect(controller.lazyPromises.length).toEqual 1

    it "returns a resolve function", ->
      resolveFunc = controller.registerWithMetaLoader()
      expect(typeof resolveFunc).toEqual "function"
      expect(resolveFunc.name).toEqual "resolveFn"

  context "when all thLazys are loaded", ->
    it "set the thMetaLoaders loading state to false", ->
      thLazyResolve1 = controller.registerWithMetaLoader()
      thLazyResolve2 = controller.registerWithMetaLoader()

      expect(controller.loading).toBe true

      controller.$postLink()
      thLazyResolve1()
      thLazyResolve2()
      rootScope.$apply()

      expect(controller.loading).toBe false
