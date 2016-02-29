describe 'ThemisComponents: Directive: thPopover', ->
  element = scope = compile = $timeout = PopoverManager = null

  beforeEach ->
    angular.mock.module 'ThemisComponents'

  beforeEach ->
    inject (_PopoverManager_, _$timeout_) ->
      PopoverManager = _PopoverManager_
      $timeout = _$timeout_

  describe 'getContent', ->
    describe 'if popover-content exists', ->
      beforeEach ->
        template = """
          <div th-popover="test"></div>
          <th-popover-content name="test">content</th-popover-content>
        """
        directive = compileDirective(template)
        element = directive.element

      it 'should resolve promise', ->
        result = null
        
        promise = element.scope().thPopover.getContent()
        promise.then (content) ->
          result = content
        $timeout.flush()

        expect(result.data).toBe "content"

    describe 'if popover-content does not exist', ->
      beforeEach ->
        template = """
          <div th-popover="test"></div>
        """
        directive = compileDirective(template)
        element = directive.element

      it 'should reject promise', ->
        reject = false
        
        promise = element.scope().thPopover.getContent()
        promise.then (content) ->
          return
        , ->
          reject = true
        $timeout.flush()

        expect(reject).toBe true
