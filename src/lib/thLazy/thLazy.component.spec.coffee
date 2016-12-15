context = describe

describe "ThemisComponents: Component: thLazy", ->
  controller = $componentController = LazyManager = resolved = null

  createMetaLoaderCtrl = ->
    resolveFunc = -> resolved = true
    spy = jasmine
      .createSpy("registerWithMetaLoader")
      .and.returnValue(resolveFunc)

    return {registerWithMetaLoader: spy}

  createLazyCtrl = (bindings = {}) ->
    unless bindings.src?
      Object.assign bindings, {src: "/template.html"}
    controller = $componentController "thLazy", null, bindings
    controller.metaLoader = createMetaLoaderCtrl()
    return controller

  beforeEach -> angular.mock.module 'ThemisComponents'

  beforeEach inject (_$componentController_, _LazyManager_) ->
    $componentController = _$componentController_
    LazyManager = _LazyManager_

  context "with a valid template path", ->
    beforeEach ->
      controller = createLazyCtrl()

    it "exposes a src value", ->
      expect(controller.src).toBe "/template.html"

    it "triggers the loading indicator", ->
      expect(controller.loading).toBe true

    it "triggers the error message", ->
      expect(controller.loadError).toBe false

    it "registers itself with the LazyManager", ->
      addLazyObjectSpy = spyOn(LazyManager, "addLazyObject")

      expect(LazyManager.addLazyObject.calls.count()).toEqual 0
      controller.$onInit()
      expect(LazyManager.addLazyObject.calls.count()).toEqual 1
      expect(LazyManager.addLazyObject).toHaveBeenCalledWith(controller)

    context "template is loaded", ->
      it "stops loading", ->
        controller.loadingComplete()
        expect(controller.loading).toBe false

  context "when an invalid template path", ->
    beforeEach ->
      controller = createLazyCtrl()
      controller.$onInit()
      controller.$scope.$broadcast "$includeContentError"

    it "triggers the 'loadError'", ->
      expect(controller.loadError).toBe true

    it "hides the loading indicator", ->
      expect(controller.loading).toBe false

  context "inside a 'thMetaLoader'", ->
    beforeEach ->
      resolved = false
      controller = createLazyCtrl()

    it "registers itself with the MetaLoader", ->
      metaLoaderSpy = controller.metaLoader.registerWithMetaLoader.calls
      expect(metaLoaderSpy.count()).toEqual 0
      controller.$onInit()
      expect(metaLoaderSpy.count()).toEqual 1

    context "on 'loadingComplete'", ->
      it "executes the metaLoader resolve function", ->
        controller.$onInit()
        controller.loadingComplete()
        expect(resolved).toBe true

    context "with custom error message", ->
      errorMsg = "Survey says… nope"

      beforeEach ->
        controller = createLazyCtrl errorMessage: errorMsg

      it "should expose a errorMessage value", ->
        expect(controller.errorMessage).toBe errorMsg

      it "sets the messageOverride to true", ->
        expect(controller.messageOverride).toBe true

    context "with name property", ->
      beforeEach ->
        controller = createLazyCtrl name: "example"

      it "exposes a name value", ->
        expect(controller.name).toBe "example"

  context "can be reloaded", ->
    it "adds a cachebuster param to the url's query string", ->
      controller = createLazyCtrl()

      expect(controller.src).toBe "/template.html"
      controller.reload()

      deCachedTemplate = controller.src.substring(0, 34)
      expect(deCachedTemplate).toBe "/template.html?refreshCacheBuster="

    it "should retain the exisiting params", ->
      controller = createLazyCtrl(src: "/template.html?foo=bar")

      expect(controller.src).toBe "/template.html?foo=bar"
      controller.reload()

      deCachedTemplate = controller.src.substring(0, 42)
      expect(deCachedTemplate).toBe "/template.html?foo=bar&refreshCacheBuster="

    it "subsequent reloads updates cachebuster", ->
      controller = createLazyCtrl()

      controller.reload()
      firstSrc = controller.src

      controller.reload()
      secondSrc = controller.src

      expect(firstSrc).not.toEqual secondSrc
