{
  compileDirective
} = require "spec_helpers"
context = describe

describe "ThemisComponents: Directive: thModal", ->
  directive = element = scope = ModalManager = null

  beforeEach angular.mock.module "ThemisComponents"

  describe "#dismiss", ->

    it "calls ModalManager.dismiss", ->
      t = """<th-modal modal-data="{name: 'test', content: '<p>testing</p>'}"></th-modal>"""
      ctrl = compileDirective(t).scope.$$childHead.modal
      inject (_ModalManager_) ->
        ModalManager = _ModalManager_

      spyOn(ModalManager, "dismiss")
      ctrl.dismiss()
      expect(ModalManager.dismiss).toHaveBeenCalled()

  describe "#confirm", ->

    it "calls ModalManager.confirm", ->
      t = """<th-modal modal-data="{name: 'test', content: '<p>testing</p>'}"></th-modal>"""
      ctrl = compileDirective(t).scope.$$childHead.modal
      inject (_ModalManager_) ->
        ModalManager = _ModalManager_

      spyOn(ModalManager, "confirm")
      ctrl.confirm()
      expect(ModalManager.confirm).toHaveBeenCalled()
