{
  compileDirective
} = require "spec_helpers"

describe 'ThemisComponents: Directive: thPopoverManager', ->
  directive = element = httpBackend = scope = timeout =
    PopoverManager = contentElement = null
  validTemplate = """
    <a href="" th-popover-url="/template.html">Popover</a>
  """
  mockResponse = "<h1>Popover</h1>"

  addContentToBody = ->
    contentElement = document.createElement 'th-popover-content'
    contentElement.setAttribute(
      'name'
      'content'
    )
    document.body.appendChild contentElement

  popoverExists = ->
    if document.querySelector('.th-popover-view') &&
      document.querySelector('.th-popover-overlay') &&
      document.querySelector('.th-popover-arrow')
    then true
    else false

  removeContentFromBody = ->
    document.body.removeChild contentElement

  beforeEach angular.mock.module 'ThemisComponents'
  beforeEach inject ($injector, _PopoverManager_) ->
    httpBackend = $injector.get '$httpBackend'
    scope = $injector.get('$rootScope').$new()
    timeout = $injector.get '$timeout'
    PopoverManager = _PopoverManager_

  describe 'getContent', ->
    describe 'when content exists in document body but is not added to PopoverManager', ->

      beforeEach ->
        addContentToBody()

      afterEach ->
        removeContentFromBody()

      it 'should throw an error', ->
        expect(-> getContent('content')).toThrow()

    describe 'when content is added to PopoverManager but does not exist in document body', ->
      beforeEach ->
        PopoverManager.addContent('content', 'content')

      it 'should throw an error', ->
        expect(-> getContent('text')).toThrow()

    describe 'when content exists', ->
      beforeEach ->
        PopoverManager.addContent('content', 'content')
        addContentToBody()

      afterEach ->
        removeContentFromBody()

      it "should return a promise that resolves to 'content'", ->
        resolvedContent = null

        contentPromise = PopoverManager.getContent('content')
        contentPromise.getContentPromise().then (content) ->
          resolvedContent = content
        timeout.flush()

        expect(resolvedContent.data).toBe 'content'

  describe 'hidePopover', ->
    describe 'when target does not exist', ->
      it 'should throw an error', ->
        expect(-> PopoverManager.hidePopover('target', undefined)).toThrow()

    describe 'when target exists', ->
      beforeEach ->
        addContentToBody()

        template = """
          <div th-popover-target='target'></div>
          <th-popover-content name='content'>content</th-popover-content>
        """
        compileDirective(template)

      afterEach ->
        angular.element(
          document.querySelector('.th-popover-overlay')
        ).triggerHandler 'click'

        removeContentFromBody()

      it 'should dismiss rendered popover', ->
        PopoverManager.showPopover(
          targetName: 'target'
          contentCallback: -> PopoverManager.getContent('content')
        )
        timeout.flush()

        PopoverManager.hidePopover('target')

        expect(popoverExists()).toBe false

  describe 'showPopover', ->
    describe 'when target does not exist', ->
      it 'should throw an error', ->
        expect(-> PopoverManager.showPopover('target', undefined)).toThrow()

    describe 'when target exists', ->
      beforeEach ->
        addContentToBody()

        template = """
          <div th-popover-target='target'></div>
          <th-popover-content name='content'>content</th-popover-content>
        """
        compileDirective(template)

      afterEach ->
        angular.element(
          document.querySelector('.th-popover-overlay')
        ).triggerHandler 'click'

        removeContentFromBody()

      describe "when contentCallback is not defined or not a function", ->
        it "should throw an error", ->
          expect(-> PopoverManager.showPopover(targetName: 'target')).toThrow()
          expect(-> PopoverManager.showPopover(
            targetName: 'target'
            contentCallback: '2'
          )).toThrow()

      it 'should render popover', ->
        PopoverManager.showPopover(
          targetName: 'target'
          contentCallback: -> PopoverManager.getContent('content')
        )
        timeout.flush()

        expect(popoverExists()).toBe true

  describe 'attachPopover', ->
    beforeEach ->
      httpBackend.when('GET', '/template.html').respond mockResponse
      directive = compileDirective(validTemplate)
      element = directive.element

    afterEach ->
      # Cleanup any popovers we may leave open after tests run.
      for overlay in document.querySelectorAll('.th-popover-overlay')
        angular.element(overlay).triggerHandler 'click'

    it 'should request a template', ->
      element.triggerHandler 'click'
      httpBackend.flush()
      httpBackend.expectGET '/template.html'

    it 'should open popover', ->
      element.triggerHandler 'click'
      expect(document.querySelector('.th-popover-view')).not.toBeNull()

    it 'should open overlay under the popover', ->
      element.triggerHandler 'click'
      expect(document.querySelector('.th-popover-overlay')).not.toBeNull()

    it 'should close after it opens', ->
      element.triggerHandler 'click'
      angular.element(document.querySelector('.th-popover-overlay')).triggerHandler 'click'

      expect(document.querySelector('.th-popover-view')).toBeNull()
      expect(document.querySelector('.th-popover-overlay')).toBeNull()
