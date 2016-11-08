describe "ThemisComponents: Component: thDisclosureContent", ->
  disclosureManager = utilities = $componentController = controller = $timeout = $element = null

  componentName = -> "disclosureContent"
  getElementActualHeightStub = -> 10

  createDisclosureContentCtrl = ->
    $container = angular.element "<div>"
    $element = angular.element "<ng-transclude>"
    $container.append($element)

    return $componentController "thDisclosureContent",
      {$element: $container}
      {name: componentName()}

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject (_Utilities_, _$timeout_, _$componentController_, _DisclosureManager_) ->
      utilities = _Utilities_
      $timeout = _$timeout_
      $componentController = _$componentController_
      disclosureManager = _DisclosureManager_

    controller = createDisclosureContentCtrl()
    spyOn(utilities, "getElementActualHeight").and.callFake getElementActualHeightStub
    spyOn disclosureManager, "registerDisclosureContent"
    controller.$onInit()

  describe "#onInit", ->
    it "calls registerDisclosureToggle on the DisclosureManager", ->
      registerCall = disclosureManager.registerDisclosureContent.calls
      handlers = registerCall.argsFor(0)[1]

      expect(registerCall.count()).toBe 1
      expect(registerCall.argsFor(0)[0]).toEqual componentName()

  describe "#handleOpen callback", ->
    beforeEach ->
      registerCall = disclosureManager.registerDisclosureContent.calls
      handleOpen = registerCall.argsFor(0)[1].handleOpen
      expect(controller.contentHeight).not.toBeDefined()
      handleOpen()

    it "passes the ng-transclude element to the getElementActualHeight helper", ->
      heightHelperCall = utilities.getElementActualHeight.calls
      expect(heightHelperCall.count()).toBe 1
      expect(heightHelperCall.argsFor(0)[0]).toEqual $element[0]

    it "sets the contentHeight to the value from Uitlities.getElementActualHeight", ->
      $timeout.flush()
      $timeout.verifyNoPendingTasks()
      expect(controller.contentHeight).toBe getElementActualHeightStub()

  describe "#handleClose callback", ->
    it "sets the contentHeight to 0", ->
      registerCall = disclosureManager.registerDisclosureContent.calls
      handleClose = registerCall.argsFor(0)[1].handleClose
      expect(controller.contentHeight).not.toBeDefined()
      handleClose()
      expect(controller.contentHeight).toBe 0
