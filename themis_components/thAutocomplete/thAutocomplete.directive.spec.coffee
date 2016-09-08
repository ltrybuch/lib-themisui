{
  compileDirective
} = require "spec_helpers"

describe 'ThemisComponents: Directive: thAutocomplete', ->
  element = scope = timeout = hiddenFormInput = null
  validTemplate = """
    <th-autocomplete
      delegate='delegate'
      >
    </th-autocomplete>
  """
  data = [
    {id: "0", anotherId: "3", name: "test0", anotherName: "test3"}
    {id: "1", anotherId: "4", name: "test1", anotherName: "test4"}
    {id: "2", anotherId: "5", name: "test2", anotherName: "test5"}
  ]

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($timeout) ->
    timeout = $timeout

  getSelect = ->
    angular.element(element[0].querySelector('.ui-select-container')).scope().$select

  getHiddenFormInput = ->
    element[0].querySelector("input[type='hidden']")

  search = (searchString) ->
    getSelect().search = searchString
    timeout.flush()

  openDropDown = ->
    getSelect().open = true
    scope.$digest()

  selectItem = (item) ->
    getSelect().select(item)

  describe 'when delegate is not specified', ->
    it 'should throw an error', ->
      invalidTemplate = '<th-autocomplete></th-autocomplete>'
      expect(-> compileDirective(invalidTemplate)).toThrow()

  describe 'when fetchData is not specified', ->
    it 'should throw an error', ->
      expect(-> compileDirective(
        validTemplate
        delegate: {}
      )).toThrow()

  describe 'when fetchData is specified', ->
    beforeEach ->
      {element, scope} = compileDirective(
        validTemplate
        delegate:
          fetchData: ({searchString}, updateData) -> return
      )
      spyOn scope.delegate, 'fetchData'

    it 'should have no icon element', ->
      expect(element[0].querySelector('.th-autocomplete-icon')).toBe null

    it 'should call fetchData', ->
      search('a')
      expect(scope.delegate.fetchData).toHaveBeenCalled

  describe 'when updateData is called without an array', ->
    beforeEach ->
      {element, scope} = compileDirective(
        validTemplate
        delegate:
          fetchData: ({searchString}, updateData) ->
            updateData({})
      )

    it 'should throw an error', ->
      expect(-> search('a')).toThrow()

  describe 'when updateData is called with an array', ->
    beforeEach ->
      {element, scope} = compileDirective(
        validTemplate
        delegate:
          fetchData: ({searchString}, updateData) ->
            updateData(data)
      )

    it 'should update the list of options', ->
      search('a')
      openDropDown()
      expect(element.find('.ui-select-choices-row').length).toEqual 3

  describe "when icon is specified", ->
    beforeEach ->
      {element, scope} = compileDirective(
        """
        <th-autocomplete
          delegate='delegate'
          icon='test'
          >
        </th-autocomplete>
        """
        delegate:
          fetchData: -> return
      )
      @iconElement = element.find(".th-autocomplete-icon")

    it "should have icon element with specified class", ->
      expect(@iconElement).not.toBe null
      expect(@iconElement.hasClass("fa-test")).toBeTruthy()

    it "should have icon element preceding 'ui-select-container' for sibling selector", ->
      expect(@iconElement.next().hasClass("ui-select-container")).toBeTruthy()

  describe 'when user starts typing', ->
    onChangeSpy = null

    beforeEach ->
      template = """
       <th-autocomplete
         delegate='delegate'
         ng-model='value'
         ng-change='change()'
         name='test'
         >
       </th-autocomplete>
      """
      {element, scope} = compileDirective(
        template
        value: data[0]
        delegate:
          fetchData: ({searchString}, updateData) ->
            updateData(data)
        change: -> return
      )
      onChangeSpy = spyOn scope, "change"
      hiddenFormInput = getHiddenFormInput()
      search('a')
      openDropDown()

    it "should have hidden input element with name attribute", ->
      expect(hiddenFormInput.getAttribute("name")).toBe "test"

    it "should not call 'onChange'", ->
      expect(onChangeSpy).not.toHaveBeenCalled()

    describe "when user selects option", ->
      testSelectOption = (item) ->
        beforeEach ->
          onChangeSpy.calls.reset()
          selectItem item
          timeout.flush()

        it 'updates model', ->
          expect(scope.value).toEqual item

        it "calls 'ngChange' function", ->
          expect(onChangeSpy.calls.count()).toBe 1

        it "updates value on hidden input", ->
          expect(hiddenFormInput.getAttribute("value")).toBe item.id

      testSelectOption data[2]

      describe "when user selects another option", ->
        testSelectOption data[1]

  describe 'when displayField is not specified', ->
    beforeEach ->
      {element, scope} = compileDirective(
        validTemplate
        delegate:
          fetchData: ({searchString}, updateData) ->
            updateData(data)
      )

    it 'binds to default name', ->
      search('a')
      openDropDown()

      # Get inner span of first item of drop down.
      selectChoice = element[0].querySelector('.ui-select-choices-row-inner').children[0]
      expect(selectChoice.textContent).toEqual 'test0'

      # Get inner span of match element.
      matchChoice = element[0].querySelector('.ui-select-match-text').children[0]
      expect(matchChoice.textContent).toEqual ''
      selectItem(data[0])
      scope.$digest()
      expect(matchChoice.textContent).toEqual 'test0'

  describe 'when displayField is specified', ->
    beforeEach ->
      {element, scope} = compileDirective(
        validTemplate
        delegate:
          displayField: 'anotherName'
          fetchData: ({searchString}, updateData) ->
            updateData(data)
      )

    it 'binds to displayField', ->
      search('a')
      openDropDown()

      # Get inner span of first item of drop down.
      selectChoice = element[0].querySelector('.ui-select-choices-row-inner').children[0]
      expect(selectChoice.textContent).toEqual 'test3'

      selectItem(data[0])
      scope.$digest()

      # Get inner span of match element.
      matchChoice = element[0].querySelector('.ui-select-match-text').children[0]
      expect(matchChoice.textContent).toEqual 'test3'

  describe 'when trackField is not specified', ->
    beforeEach ->
      {element} = compileDirective(
        validTemplate
        delegate:
          fetchData: ({searchString}, updateData) -> return
      )

    it 'does not specify what to track by', ->
      selectChoices = element[0].querySelector('.ui-select-choices')
      expect(selectChoices.getAttribute('repeat')).toEqual 'item in thAutocomplete.data'

  describe 'when trackField is specified', ->
    beforeEach ->
      {element} = compileDirective(
        validTemplate
        delegate:
          trackField: 'anotherId'
          fetchData: ({searchString}, updateData) ->
            updateData(data)
      )
      hiddenFormInput = getHiddenFormInput()
      search('a')
      openDropDown()

    it 'tracks by trackField', ->
      selectChoices = element[0].querySelector('.ui-select-choices')
      expect(selectChoices.getAttribute('repeat')).toEqual(
        'item in thAutocomplete.data track by item.anotherId'
      )

    describe "when user selects item", ->
      beforeEach ->
        search('a')
        openDropDown()
        selectItem(data[0])
        timeout.flush()

      it "should update value to alt-id", ->
        expect(hiddenFormInput.getAttribute("value")).toBe "3"

  describe "when 'multiple' is enabled and user applies focus and blur to input field", ->
    beforeEach ->
      template = """
       <th-autocomplete
         delegate='delegate'
         multiple
         >
       </th-autocomplete>
      """
      {@element} = compileDirective(
        template
        delegate:
          fetchData: ({searchString}, updateData) ->
            updateData(data)
      )
      timeout.flush()

    it "should add and remove 'has-focus' class from container", ->
      input = @element.querySelectorAll(".ui-select-search")
      select = @element.querySelectorAll(".ui-select-container")
      input.triggerHandler("focus")
      expect(select.hasClass("has-focus")).toBe true
      input.triggerHandler("blur")
      expect(select.hasClass("has-focus")).toBe false
