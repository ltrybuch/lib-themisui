{
  compileDirective
} = require "spec_helpers"

describe 'ThemisComponents: Directive: thPopoverTarget', ->
  PopoverManager = null

  beforeEach angular.mock.module 'ThemisComponents'
  beforeEach inject ($injector, _PopoverManager_) ->
    PopoverManager = _PopoverManager_

  describe 'when name is not specified', ->
    it 'should throw an error', ->
      expect(-> compileDirective('<div th-popover-target></div>')).toThrow()

  describe 'when template is valid', ->
    beforeEach ->
      spyOn(PopoverManager, 'addTarget')

      template = "<div th-popover-target='test'></div>"
      compileDirective(template)

    it "should call 'PopoverManager.addTarget'", ->
      expect(PopoverManager.addTarget).toHaveBeenCalled()
