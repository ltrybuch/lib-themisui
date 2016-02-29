describe 'ThemisComponents: Directive: thPopoverContent', ->
  PopoverManager = null

  beforeEach ->
    angular.mock.module 'ThemisComponents'

  beforeEach inject (_PopoverManager_) ->
    PopoverManager = _PopoverManager_

  describe 'when name attribute is not specified', ->
    it 'should throw an error', ->
      template = '<th-popover-content></th-popover-content>'
      expect(-> compileDirective(template)).toThrow()

  describe 'when template is valid', ->
    beforeEach ->
      template = "<th-popover-content name='content'>inner</th-popover-content>"
      compileDirective(template)

    it 'should be added to PopoverManager', ->
      expect(PopoverManager.getContent('content')).toBe 'inner'
