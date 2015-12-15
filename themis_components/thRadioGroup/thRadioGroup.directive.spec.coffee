describe 'ThemisComponents: Directive: thRadioGroup', ->
  element = scope = compile = null
  validTemplate = """
    <th-radio-group ng-model='value'>
      <th-radio-button value='red'></th-radio-button>
      <th-radio-button value='blue'></th-radio-button>
    </th-radio-group>
  """

  beforeEach ->
    module 'ThemisComponents'

  compileRadioGroupDirective = (template, value, callback) ->
    scopeAdditions =
      value: value
      callback: callback

    directive = compileDirective(template, scopeAdditions)
    element = directive.element
    scope = directive.scope

  describe 'when value is undefined', ->
    beforeEach ->
      compileRadioGroupDirective(validTemplate, undefined)

    it 'should have an indicator for each button', ->
      expect(element.find('i').length).toBe 2

    it 'should be unchecked', ->
      expect(element.find('.th-radio-button').first().hasClass('checked')).toBe false
      expect(element.find('.th-radio-button').last().hasClass('checked')).toBe false

    describe 'when first element is clicked', ->
      beforeEach ->
        element.find('.th-radio-button').first().triggerHandler 'click'

      it 'should have second element checked only', ->
        expect(element.find('.th-radio-button').first().hasClass('checked')).toBe true
        expect(element.find('.th-radio-button').last().hasClass('checked')).toBe false

    describe 'when second element is clicked', ->
      beforeEach ->
        element.find('.th-radio-button').last().triggerHandler 'click'

      it 'should have second element checked only', ->
        expect(element.find('.th-radio-button').first().hasClass('checked')).toBe false
        expect(element.find('.th-radio-button').last().hasClass('checked')).toBe true

  describe 'when value is initialized to second element', ->
    beforeEach ->
      compileRadioGroupDirective(validTemplate, 'blue')

    it 'should have second element checked only', ->
      expect(element.find('.th-radio-button').first().hasClass('checked')).toBe false
      expect(element.find('.th-radio-button').last().hasClass('checked')).toBe true

    describe 'when first element is clicked', ->
      beforeEach ->
        element.find('.th-radio-button').first().triggerHandler 'click'

      it 'should have first element checked only', ->
        expect(element.find('.th-radio-button').first().hasClass('checked')).toBe true
        expect(element.find('.th-radio-button').last().hasClass('checked')).toBe false

    describe 'when first element is clicked then second element is clicked', ->
      beforeEach ->
        element.find('.th-radio-button').first().triggerHandler 'click'
        element.find('.th-radio-button').last().triggerHandler 'click'

      it 'should have second element checked only', ->
        expect(element.find('.th-radio-button').first().hasClass('checked')).toBe false
        expect(element.find('.th-radio-button').last().hasClass('checked')).toBe true

    describe 'when second element is clicked', ->
      beforeEach ->
        element.find('.th-radio-button').last().triggerHandler 'click'

      it 'should have second element checked only', ->
        expect(element.find('.th-radio-button').first().hasClass('checked')).toBe false
        expect(element.find('.th-radio-button').last().hasClass('checked')).toBe true

  describe 'when template specifies ng-change callback on radio group ', ->
    beforeEach ->
      formTemplate = """
          <th-radio-group name='colour' ng-model='value' ng-change='callback()'>
            <th-radio-button value='red'></th-radio-button>
            <th-radio-button value='green'></th-radio-button>
          </th-radio-group>
        """
      compileRadioGroupDirective(
        formTemplate,
        'red',
        ->
          return
      )
      spyOn scope, 'callback'

    describe 'when user clicks on unselected element', ->
      beforeEach ->
        element.find('.th-radio-button').last().triggerHandler 'click'

      it 'should trigger callback', ->
        expect(scope.callback).toHaveBeenCalled()

    describe 'when user clicks on selected element', ->
      beforeEach ->
        element.find('.th-radio-button').first().triggerHandler 'click'
      it 'should not trigger callback', ->
        expect(scope.callback).not.toHaveBeenCalled()

  describe 'when template specifies ng-change callback on radio button ', ->
    beforeEach ->
      formTemplate = """
          <th-radio-group name='colour' ng-model='value'>
            <th-radio-button ng-change='callback()' value='red'></th-radio-button>
            <th-radio-button value='green'></th-radio-button>
          </th-radio-group>
        """
      compileRadioGroupDirective(
        formTemplate,
        'red',
        ->
          return
      )
      spyOn scope, 'callback'

    describe 'when user clicks on unselected element', ->
      beforeEach ->
        element.find('.th-radio-button').last().triggerHandler 'click'

      it 'should trigger callback', ->
        expect(scope.callback).toHaveBeenCalled()

    describe 'when user clicks on selected element', ->
      beforeEach ->
        element.find('.th-radio-button').first().triggerHandler 'click'
      it 'should not trigger callback', ->
        expect(scope.callback).not.toHaveBeenCalled()
