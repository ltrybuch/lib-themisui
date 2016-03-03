describe 'ThemisComponents: Directive: thPopoverUrl', ->
  httpBackend = PopoverManager = null

  beforeEach ->
    angular.mock.module 'ThemisComponents'

  beforeEach inject ($injector, _PopoverManager_) ->
    PopoverManager = _PopoverManager_
    httpBackend = $injector.get '$httpBackend'
    httpBackend.when('GET', '').respond ''

  describe 'when url is not specified', ->
    it 'should throw an error', ->
      expect(-> compileDirective('<div th-popover-url></div>')).toThrow()

  describe 'when template is valid', ->
    beforeEach ->
      spyOn(PopoverManager, 'attachPopover')
      compileDirective("<div th-popover-url='test'></div>")

    it "should call 'PopoverManager.attachPopover'", ->
      expect(PopoverManager.attachPopover).toHaveBeenCalled()
