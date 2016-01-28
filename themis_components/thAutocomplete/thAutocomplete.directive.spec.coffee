describe 'ThemisComponents: Directive: thAutocomplete', ->
  element = scope = timeout = null

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

  search = (term) ->
    input = element[0].querySelector('.ui-select-search')

    # Set search term
    angular.element(input).scope().$select.search = term

    input.dispatchEvent enterEvent
    timeout.flush()

  describe 'when fetch-data is specified', ->
    beforeEach ->
      delegateTemplate = """
        <th-autocomplete
          delegate='delegate'
          >
        </th-autocomplete>
        """

      {element, scope} = compileDirective(delegateTemplate,
          delegate:
            fetchData: (term) -> return
        )

      spyOn scope.delegate, 'fetchData'

    it 'should call fetch-data', ->
      search('a')
      expect(scope.delegate.fetchData).toHaveBeenCalled()
