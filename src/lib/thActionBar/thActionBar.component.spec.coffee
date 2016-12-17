context = describe

describe "ThemisComponents: Component: thActionBar", ->
  $componentController = ActionBarDelegate = controller = null

  createActionBarCtrl = ->
    delegate = new ActionBarDelegate
      onApply: ({ids, selectedAction}, reset) -> return
    controller = $componentController "thActionBar", null, delegate: delegate
    return controller

  beforeEach ->
    angular.mock.module "ThemisComponents"

  beforeEach inject (_$componentController_, _ActionBarDelegate_) ->
    $componentController = _$componentController_
    ActionBarDelegate = _ActionBarDelegate_
    controller = createActionBarCtrl()

  describe "#$onInit", ->
    it "sets up a watch on delegate's allSelected value", ->
      spyOn controller, "_setUpWatch"
      controller.$onInit()
      expect(controller._setUpWatch).toHaveBeenCalled()

  describe "#toggleAll", ->
    it "triggers delegate's toggleAll", ->
      spyOn controller.delegate, "toggleAll"

      controller.toggleAll()
      expect(controller.delegate.toggleAll).toHaveBeenCalled()

  describe "#triggerAply", ->
    it "executes delegate's triggerApply", ->
      spyOn controller.delegate, "triggerApply"

      controller.triggerApply()
      expect(controller.delegate.triggerApply).toHaveBeenCalled()

