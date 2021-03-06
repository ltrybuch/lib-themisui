{
  compileDirective
} = require "spec_helpers"

describe 'ThemisComponents: Directive: thPopoverLegacy', ->
  PopoverManager = null

  beforeEach angular.mock.module 'ThemisComponents'
  beforeEach inject ($injector, _PopoverManager_) ->
    PopoverManager = _PopoverManager_

  describe 'when name is not specified', ->
    beforeEach ->
      spyOn(PopoverManager, "attachPopover")

    it 'should throw an error', ->
      expect ->
        compileDirective("<div th-popover-legacy></div>")
      .toThrow()

  describe 'when template is valid', ->
    beforeEach ->
      spyOn(PopoverManager, "attachPopover")
      spyOn(PopoverManager, "getContent")
      compileDirective("<div th-popover-legacy='test'></div>")

    it "should call 'PopoverManager.attachPopover'", ->
      expect(PopoverManager.attachPopover).toHaveBeenCalled()
