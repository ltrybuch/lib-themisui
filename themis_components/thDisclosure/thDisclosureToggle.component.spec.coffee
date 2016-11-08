describe "ThemisComponents: Component: thDisclosureToggle", ->
  $timeout = disclosureManager = element = $componentController = null

  componentName = -> "disclosureToggle"
  createDisclosureToggleCtrl = (bindings) ->
    return $componentController "thDisclosureToggle", null, bindings

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    inject (_$componentController_, _DisclosureManager_, _$timeout_) ->
      $componentController = _$componentController_
      disclosureManager = _DisclosureManager_
      $timeout = _$timeout_

    spyOn disclosureManager, "registerDisclosureToggle"
    spyOn disclosureManager, "updateState"

  describe "#onInit", ->
    controller = null

    beforeEach ->
      controller = createDisclosureToggleCtrl
        name: componentName()
      controller.$onInit()
      $timeout.flush()
      $timeout.verifyNoPendingTasks()

    it "defaults the textSide property to 'left'", ->
      expect(controller.textSide).toEqual "left"

    it "defaults the expanded property to false", ->
      expect(controller.expanded).toBe false

    it "calls registerDisclosureToggle on the DisclosureManager and updates the expanded value", ->
      registerCall = disclosureManager.registerDisclosureToggle.calls
      handlers = registerCall.argsFor(0)[1]

      expect(registerCall.count()).toBe 1
      expect(registerCall.argsFor(0)[0]).toEqual componentName()
      expect(controller.expanded).toBe false
      handlers.handleOpen()
      expect(controller.expanded).toBe true
      handlers.handleClose()
      expect(controller.expanded).toBe false

    it "calls updateState on the DisclosureManager with the expand parameter set to false", ->
      updateStateArguments = disclosureManager.updateState.calls.argsFor 0
      expect(disclosureManager.updateState.calls.count()).toBe 1
      expect(updateStateArguments[0]).toBe componentName()
      expect(updateStateArguments[1]).toBe false

    describe "#toggle", ->
      it "calls updateState on the DisclosureManager with the inverse of expanded", ->
        updateStateCalls = disclosureManager.updateState.calls
        expect(updateStateCalls.count()).toBe 1
        controller.toggle()
        expect(updateStateCalls.count()).toBe 2
        expect(updateStateCalls.mostRecent().args[1]).toBe not controller.expanded

  describe "when the component is disabled", ->
    controller = null

    beforeEach ->
      controller = createDisclosureToggleCtrl
        name: componentName()
        ngDisabled: true
      controller.$onInit()
      $timeout.flush()
      $timeout.verifyNoPendingTasks()

    it "does not call updateState when toggle is called", ->
      expect(disclosureManager.updateState.calls.count()).toBe 1
      controller.toggle()
      expect(disclosureManager.updateState.calls.count()).toBe 1

  describe "when the component is disabled and the default state is set to expanded", ->
    controller = null

    beforeEach ->
      controller = createDisclosureToggleCtrl
        name: componentName()
        ngDisabled: true
        expanded: true
      controller.$onInit()
      $timeout.flush()
      $timeout.verifyNoPendingTasks()

    it "calls updateState on the DisclosureManager with the expanded parameter", ->
      updateStateArguments = disclosureManager.updateState.calls.argsFor 0
      expect(disclosureManager.updateState.calls.count()).toBe 1
      expect(updateStateArguments[0]).toBe componentName()
      expect(updateStateArguments[1]).toBe true

    it "does not call updateState when toggle is called", ->
      expect(disclosureManager.updateState.calls.count()).toBe 1
      controller.toggle()
      expect(disclosureManager.updateState.calls.count()).toBe 1
