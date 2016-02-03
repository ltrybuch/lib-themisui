describe 'ThemisComponents: Directive: thAutocomplete', ->
  element = scope = timeout = null
  validTemplate = """
    <th-autocomplete
      delegate='delegate'
      >
    </th-autocomplete>
  """

  click = document.createEvent('MouseEvent')
  click.initEvent('click')

  enterEvent = document.createEvent('KeyboardEvent')
  enterEvent.initEvent('keydown', true, true)
  enterEvent.which = 13
  enterEvent.keyCode = 13

  beforeEach ->
    module 'ThemisComponents'

    inject ($timeout) ->
      timeout = $timeout

  search = (searchString) ->
    input = element[0].querySelector('.ui-select-container')

    # Set search term
    angular.element(input).scope().$select.search = searchString

    # input.dispatchEvent enterEvent
    timeout.flush()

  openDropDown = ->
    input = element[0].querySelector('.ui-select-container')

    angular.element(input).scope().$select.open = true

    scope.$digest()

  selectItem = (item) ->
    input = element[0].querySelector('.ui-select-container')

    angular.element(input).scope().$select.select(item)

    timeout.flush()
    scope.$digest()

    timeout.flush()

  describe 'when fetch-data is specified', ->
    beforeEach ->
      {element, scope} = compileDirective(validTemplate,
        delegate:
          fetchData: (searchString, updateData) -> return
      )

      spyOn scope.delegate, 'fetchData'

    it 'should call fetch-data', ->
      search('a')
      expect(scope.delegate.fetchData).toHaveBeenCalled

  describe 'when updateData is called', ->
    beforeEach ->
      data = [
        {id: 0, text: 'a0'}
        {id: 1, text: 'a1'}
        {id: 2, text: 'a2'}
      ]
      {element, scope} = compileDirective(validTemplate,
        delegate:
          fetchData: (searchString, updateData) ->
            updateData(data)
      )

    it 'should update the list of options', ->
      search('a')
      openDropDown()
      expect(element.find('.ui-select-choices-row').length).toEqual 3

  describe 'when user selects option', ->
    data = [
      {id: 0, text: 'a0'}
      {id: 1, text: 'a1'}
      {id: 2, text: 'a2'}
    ]

    beforeEach ->
      template = """
        <th-autocomplete
          delegate='delegate'
          ng-model='model.value'
          >
        </th-autocomplete>
      """
      {element, scope} = compileDirective(validTemplate,
        model:
          value: data[0]
        delegate:
          fetchData: (searchString, updateData) ->
            updateData(data)
      )

    it 'updates the model', ->
      search('a')
      openDropDown()
      selectItem(data[1])
      expect(scope.model.value).toEqual data[1]


