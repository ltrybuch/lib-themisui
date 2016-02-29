describe 'ThemisComponents: Directive: thPopoverContent', ->
  element = scope = null
  validTemplate = """
    <th-popover-content
      name='content'
      >
    </th-popover-content>
  """

  beforeEach ->
    angular.mock.module 'ThemisComponents'

  describe 'when name attribute is not specified', ->
    it 'should throw an error', ->
      invalidTemplate = '<th-popover-content></th-popover-content>'
      expect(-> compileDirective(invalidTemplate)).toThrow()

  

  # describe 'when fetchData is not specified', ->
  #   it 'should throw an error', ->
  #     expect(-> compileDirective(validTemplate,
  #       delegate: {}
  #     )).toThrow()

  # describe 'when fetchData is specified', ->
  #   beforeEach ->
  #     {element, scope} = compileDirective(validTemplate,
  #       delegate:
  #         fetchData: (searchString, updateData) -> return
  #     )
  #     spyOn scope.delegate, 'fetchData'

  #   it 'should call fetchData', ->
  #     search('a')
  #     expect(scope.delegate.fetchData).toHaveBeenCalled

  # describe 'when updateData is called without an array', ->
  #   beforeEach ->
  #     {element, scope} = compileDirective(validTemplate,
  #       delegate:
  #         fetchData: (searchString, updateData) ->
  #           updateData({})
  #     )

  #   it 'should throw an error', ->
  #     expect(-> search('a')).toThrow()

  # describe 'when updateData is called with an array', ->
  #   beforeEach ->
  #     {element, scope} = compileDirective(validTemplate,
  #       delegate:
  #         fetchData: (searchString, updateData) ->
  #           updateData(data)
  #     )

  #   it 'should update the list of options', ->
  #     search('a')
  #     openDropDown()
  #     expect(element.find('.ui-select-choices-row').length).toEqual 3

  # describe 'when user selects option', ->
  #   beforeEach ->
  #     template = """
  #      <th-autocomplete
  #        delegate='delegate'
  #        ng-model='value'
  #        >
  #      </th-autocomplete>
  #     """
  #     {element, scope} = compileDirective(template,
  #       value: data[0]
  #       delegate:
  #         fetchData: (searchString, updateData) ->
  #           updateData(data)
  #     )

  #   it 'updates the model', ->
  #     search('a')
  #     openDropDown()
  #     expect(scope.value).toEqual data[0]
  #     selectItem(data[1])
  #     expect(scope.value).toEqual data[1]

  # describe 'when displayField is not specified', ->
  #   beforeEach ->
  #     {element, scope} = compileDirective(validTemplate,
  #       delegate:
  #         fetchData: (searchString, updateData) ->
  #           updateData(data)
  #     )

  #   it 'binds to default name', ->
  #     search('a')
  #     openDropDown()

  #     # Get inner span of first item of drop down.
  #     selectChoice = element[0].querySelector('.ui-select-choices-row-inner').children[0]
  #     expect(selectChoice.textContent).toEqual 'test0'

  #     # Get inner span of match element.
  #     matchChoice = element[0].querySelector('.ui-select-match-text').children[0]
  #     expect(matchChoice.textContent).toEqual ''
  #     selectItem(data[0])
  #     expect(matchChoice.textContent).toEqual 'test0'

  # describe 'when displayField is specified', ->
  #   beforeEach ->
  #     {element, scope} = compileDirective(validTemplate,
  #       delegate:
  #         displayField: 'text'
  #         fetchData: (searchString, updateData) ->
  #           updateData(data)
  #     )

  #   it 'binds to displayField', ->
  #     search('a')
  #     openDropDown()

  #     # Get inner span of first item of drop down.
  #     selectChoice = element[0].querySelector('.ui-select-choices-row-inner').children[0]
  #     expect(selectChoice.textContent).toEqual 'a0'

  #     selectItem(data[0])

  #     # Get inner span of match element.
  #     matchChoice = element[0].querySelector('.ui-select-match-text').children[0]
  #     expect(matchChoice.textContent).toEqual 'a0'

  # describe 'when trackField is not specified', ->
  #   beforeEach ->
  #     {element} = compileDirective(validTemplate,
  #       delegate:
  #         fetchData: (searchString, updateData) -> return
  #     )

  #   it 'does not specify what to track by', ->
  #     selectChoices = element[0].querySelector('.ui-select-choices')
  #     expect(selectChoices.getAttribute('repeat')).toEqual 'item in thAutocomplete.data'

  # describe 'when trackField is specified', ->
  #   beforeEach ->
  #     {element} = compileDirective(validTemplate,
  #       delegate:
  #         trackField: 'id'
  #         fetchData: (searchString, updateData) -> return
  #     )

  #   it 'tracks by trackField', ->
  #     selectChoices = element[0].querySelector('.ui-select-choices')
  #     expect(selectChoices.getAttribute('repeat')).toEqual(
  #       'item in thAutocomplete.data track by item.id'
  #     )
