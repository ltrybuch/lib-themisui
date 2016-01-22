describe 'ThemisComponents: Directive: thAutocomplete', ->
  searchFieldSelector = '.select2-search__field'
  autocompleteSelector = '.select2'

  element = scope = compile = timeout = null
  validTemplate = """
    <th-autocomplete ng-model='value'>
      <option value='0'>aa</option>
      <option value='1' selected>bb</option>
    </th-autocomplete>
  """
  click = document.createEvent('MouseEvent')
  click.initEvent('click')

  beforeEach ->
    module 'ThemisComponents'

    inject ($timeout, _jQuery_) ->
      timeout = $timeout

  queryRadioButtonSelector = (position) ->
    selector = '.th-radio-button'
    selector += ':' + position + '-child' if position
    element[0].querySelector(selector)

  queryRadioButtonChecked = (position) ->
    button = queryRadioButtonSelector(position)
    button.matches('.checked')

  querySearchField = ->
    element[0].querySelector(searchFieldSelector)

  querySelect = ->
    element[0].querySelector("select")

  queryAutocomplete = ->
    element[0].querySelector(autocompleteSelector)

  search = (term) ->
    setTimeout ->
      debugger
    , 1000



    autocomplete = queryAutocomplete()
    autocomplete.dispatchEvent click
    search = querySearchField()
    "blah"

  getValue = ->
    select = querySelectSelector()
    select.value


  compileAutocompleteDirective = (template, scopeAdditions) ->
    directive = compileDirective(template, scopeAdditions)
    element = directive.element
    scope = directive.scope

  describe 'when remote data is used', ->
    beforeEach ->
      remoteDataTemplate = """
        <th-autocomplete fetch-data='fetchData'>
        </th-autocomplete>
        """
      compileAutocompleteDirective(remoteDataTemplate, {
        fetchData: ->
          return
      })
      spyOn scope, 'fetchData'

    it 'should call fetch-data', (done) ->
      search('aa')
      expect(scope.fetchData).toHaveBeenCalled()

  # describe 'when value is undefined', ->
  #   beforeEach ->
  #     compileAutocompleteDirective(validTemplate)

  #   it 'should have an indicator for each button', ->
  #     debugger


  #     expect(queryRadioButtonSelector().querySelector('i')).toExist

  #   it 'should be unchecked', ->
  #     expect(queryRadioButtonChecked('first')).toBe false
  #     expect(queryRadioButtonChecked('last')).toBe false

  #   describe 'when first element is clicked', ->
  #     beforeEach ->
  #       queryRadioButtonSelector('first').dispatchEvent click

  #     it 'should have first element checked only', ->
  #       expect(queryRadioButtonChecked('first')).toBe true
  #       expect(queryRadioButtonChecked('last')).toBe false

  #   describe 'when second element is clicked', ->
  #     beforeEach ->
  #       queryRadioButtonSelector('last').dispatchEvent click

  #     it 'should have second element checked only', ->
  #       expect(queryRadioButtonChecked('first')).toBe false
  #       expect(queryRadioButtonChecked('last')).toBe true

  # describe 'when value is initialized to second element', ->
  #   beforeEach ->
  #     compileRadioGroupDirective(validTemplate, 'blue')

  #   it 'should have second element checked only', ->
  #     expect(queryRadioButtonChecked('first')).toBe false
  #     expect(queryRadioButtonChecked('last')).toBe true

  #   describe 'when first element is clicked', ->
  #     beforeEach ->
  #       queryRadioButtonSelector('first').dispatchEvent click

  #     it 'should have first element checked only', ->
  #       expect(queryRadioButtonChecked('first')).toBe true
  #       expect(queryRadioButtonChecked('last')).toBe false

  #   describe 'when first element is clicked then second element is clicked', ->
  #     beforeEach ->
  #       queryRadioButtonSelector('first').dispatchEvent click
  #       queryRadioButtonSelector('last').dispatchEvent click

  #     it 'should have second element checked only', ->
  #       expect(queryRadioButtonChecked('first')).toBe false
  #       expect(queryRadioButtonChecked('last')).toBe true

  #   describe 'when second element is clicked', ->
  #     beforeEach ->
  #       queryRadioButtonSelector('last').dispatchEvent click

  #     it 'should have second element checked only', ->
  #       expect(queryRadioButtonChecked('first')).toBe false
  #       expect(queryRadioButtonChecked('last')).toBe true

  # describe 'when template specifies ng-change callback on radio group ', ->
  #   beforeEach ->
  #     formTemplate = """
  #         <th-radio-group name='colour' ng-model='value' ng-change='callback()'>
  #           <th-radio-button value='red'></th-radio-button>
  #           <th-radio-button value='green'></th-radio-button>
  #         </th-radio-group>
  #       """
  #     compileRadioGroupDirective(
  #       formTemplate,
  #       'red',
  #       ->
  #         return
  #     )
  #     spyOn scope, 'callback'

  #   describe 'when user clicks on unselected element', ->
  #     beforeEach ->
  #       queryRadioButtonSelector('last').dispatchEvent click

  #     it 'should trigger callback', ->
  #       expect(scope.callback).toHaveBeenCalled()

  #   describe 'when user clicks on selected element', ->
  #     beforeEach ->
  #       queryRadioButtonSelector('first').dispatchEvent click
  #     it 'should not trigger callback', ->
  #       expect(scope.callback).not.toHaveBeenCalled()

  # describe 'when template specifies ng-change callback on radio button ', ->
  #   beforeEach ->
  #     formTemplate = """
  #         <th-radio-group name='colour' ng-model='value'>
  #           <th-radio-button ng-change='callback()' value='red'></th-radio-button>
  #           <th-radio-button value='green'></th-radio-button>
  #         </th-radio-group>
  #       """
  #     compileRadioGroupDirective(
  #       formTemplate,
  #       'red',
  #       ->
  #         return
  #     )
  #     spyOn scope, 'callback'

  #   describe 'when user clicks on unselected element', ->
  #     beforeEach ->
  #       queryRadioButtonSelector('last').dispatchEvent click

  #     it 'should trigger callback', ->
  #       expect(scope.callback).toHaveBeenCalled()

  #   describe 'when user clicks on selected element', ->
  #     beforeEach ->
  #       queryRadioButtonSelector('first').dispatchEvent click
  #     it 'should not trigger callback', ->
  #       expect(scope.callback).not.toHaveBeenCalled()
