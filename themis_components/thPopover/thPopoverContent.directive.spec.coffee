describe 'ThemisComponents: Directive: thPopoverContent', ->
  directive = element = PopoverManager = null

  beforeEach ->
    angular.mock.module 'ThemisComponents'

  beforeEach inject ($injector, _PopoverManager_) ->
    PopoverManager = _PopoverManager_ 

  describe 'when name attribute is not specified', ->
    it 'should throw an error', ->
      template = '<th-popover-content></th-popover-content>'
      expect(-> compileDirective(template)).toThrow()

  describe 'when template is valid', ->
    beforeEach ->
      spyOn(PopoverManager, "addContent")
      
      template = "<th-popover-content name='content'>inner</th-popover-content>"
      directive = compileDirective(template)
      element = directive.element

    it 'should hide the dom element', ->
      expect(element[0].style.display).toBe 'none'
      expect(PopoverManager.addContent).toHaveBeenCalled()
