context = describe
describe 'ThemisComponents: Directive: thDatePicker', ->
  element = scope = compile = defaultState = validTemplate = null


  
  describe "thDatePicker", ->
    beforeEach ->
      scopeAdditions = {}
      scopeAdditions.model = "string"
      validTemplate = """
        <th-date-picker ng-model="model"></th-date-picker>
      """
      {element, scope} = compileDirective validTemplate, scopeAdditions
    it "has a name", ->
      # debugger
      expect(element.find("input").val()).toBe "on"
