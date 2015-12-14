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

  compileRadioGroupDirective = (template, blah, callback) ->
    scopeAdditions =
      value: blah
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
